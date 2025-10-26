import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:prog2025_firtst/database/product.dart';
import 'package:prog2025_firtst/database/category.dart';
import 'package:prog2025_firtst/database/favorite.dart';
import 'package:prog2025_firtst/models/product_dao.dart';
import 'package:prog2025_firtst/models/category_dao.dart';
import 'package:prog2025_firtst/models/favorite_dao.dart';
import 'product_detail_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final ProductDatabase _productDB = ProductDatabase();
  final CategoryDatabase _categoryDB = CategoryDatabase();
  final FavoriteDatabase _favoriteDB = FavoriteDatabase();
  late User user;
  late String userId;
  List<ProductDao> _products = [];
  List<CategoryDao> _categories = [];
  Set<int> _favoriteProductIds = {};

  String _selectedCategory = 'All Items';
  String _search = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    userId = user.uid;
    print("userId: $userId");
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() {
      _loading = false;
    });
    try {
      final products = await _productDB.SELECT();
      final categories = await _categoryDB.SELECT();
      print(userId);
      final favs = await _favoriteDB.SELECT_BY_USER(userId);

      setState(() {
        _products = products;
        _categories = categories;
        _favoriteProductIds = favs.map((f) => f.idProduct!).whereType<int>().toSet();
      });
    } catch (e) {
      // ignore errors for now
    } 
  }

  List<ProductDao> get _filteredProducts {
    final q = _search.trim().toLowerCase();
    Iterable<ProductDao> list = _products;
    if (_selectedCategory != 'All Items') {
      // find category id for selectedCategory
      final cat = _categories.firstWhere(
        (c) => c.nameCategory == _selectedCategory,
        orElse: () => CategoryDao(idCategory: -1, nameCategory: ''),
      );
      if (cat.idCategory != null && cat.idCategory! > 0) {
        list = list.where((p) => p.idCategory == cat.idCategory);
      } else {
        list = list.where((p) => (p.titulo ?? '').toLowerCase().contains(_selectedCategory.toLowerCase()));
      }
    }
    if (q.isNotEmpty) {
      list = list.where((p) => (p.titulo ?? '').toLowerCase().contains(q));
    }
    return list.toList();
  }

  Future<void> _toggleFavorite(ProductDao product) async {
    final pid = product.idProduct;
    if (pid == null) return;
    try {
      if (_favoriteProductIds.contains(pid)) {
        // find favorite row id
        final favs = await _favoriteDB.SELECT_BY_USER(userId);
        final match = favs.firstWhere((f) => f.idProduct == pid, orElse: () => FavoriteDao());
        if (match.idFavorite != null) {
          await _favoriteDB.DELETE(match.idFavorite!);
        }
        setState(() => _favoriteProductIds.remove(pid));
      } else {
        await _favoriteDB.INSERT_BY_PRODUCT_ID(pid,userId);
        setState(() => _favoriteProductIds.add(pid));
      }
    } catch (e) {
      // ignore
    }
  }

  String _categoryNameFor(ProductDao p) {
    final cat = _categories.firstWhere((c) => c.idCategory == p.idCategory, orElse: () => CategoryDao(nameCategory: 'Unknown'));
    return cat.nameCategory ?? 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    final categoryLabels = <String>['All Items'] +
        _categories.map((c) => c.nameCategory ?? '').where((s) => s.isNotEmpty).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Hello, Welcome 👋", style: TextStyle(fontSize: 16, color: Colors.black54)),
                        SizedBox(height: 4),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=3"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => _search = v),
                      decoration: InputDecoration(
                        hintText: "Search clothes...",
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[500]!, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(7),
                      child: const Icon(Icons.filter_list, color: Colors.white, size: 20),
                    ),
                    onPressed: () => _showCategorySelector(context, categoryLabels),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categoryLabels.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final label = categoryLabels[index];
                  final isSelected = label == _selectedCategory;
                  return ChoiceChip(
                    avatar: Icon(index == 0 ? Icons.grid_view : Icons.checkroom,
                        size: 18, color: isSelected ? Colors.white : Colors.black),
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategory = label),
                    selectedColor: Colors.black,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                    backgroundColor: Colors.grey[200],
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredProducts.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                                SizedBox(height: 12),
                                Text('No products found', style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          )
                        : MasonryGridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            itemCount: _filteredProducts.length,
                            itemBuilder: (context, index) {
                              final p = _filteredProducts[index];
                              final isFav = p.idProduct != null && _favoriteProductIds.contains(p.idProduct);
                              return GestureDetector(
                                onTap: () {
                                  
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p)),
                                  ).then((_) => _loadAll());
                                },
                                child: Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          Hero(
                                            tag: p.idProduct ?? index,
                                            child: ClipRRect(
                                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                                              child: p.image != null && p.image!.isNotEmpty
                                                  ? Image.network(p.image!, fit: BoxFit.cover, height: 180, width: double.infinity)
                                                  : Container(height: 180, color: Colors.grey[200], child: const Icon(Icons.image_outlined, size: 48)),
                                            ),
                                          ),
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: GestureDetector(
                                              onTap: () => _toggleFavorite(p),
                                              child: CircleAvatar(
                                                radius: 16,
                                                backgroundColor: Colors.black.withOpacity(0.9),
                                                child: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.white, size: 16),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(p.titulo ?? 'No title', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                            const SizedBox(height: 4),
                                            Text(_categoryNameFor(p), style: TextStyle(fontSize: 14, color: Colors.black54)),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Text('\$${(p.price ?? 0).toStringAsFixed(2)}',
                                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                                const Spacer(),
                                                const Icon(Icons.star, size: 16, color: Colors.amber),
                                                const SizedBox(width: 4),
                                                Text((p.puntuation ?? 0.0).toStringAsFixed(1), style: const TextStyle(fontSize: 14)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add_product').then((_) => _loadAll()),
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // simple category selector dialog
  void _showCategorySelector(BuildContext ctx, List<String> labels) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: labels.map((l) {
            return ListTile(
              title: Text(l),
              selected: l == _selectedCategory,
              onTap: () {
                setState(() => _selectedCategory = l);
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  // convert ProductDao to lightweight Product used by ProductDetailScreen in your project
  CatalogProduct _toCatalogProduct(ProductDao dao) {
    return CatalogProduct(
      id: (dao.idProduct ?? 0).toString(),
      title: dao.titulo ?? '',
      category: _categoryNameFor(dao),
      price: dao.price ?? 0.0,
      rating: dao.puntuation ?? 0.0,
      image: dao.image ?? '',
    );
  }
}

// local Product model used by existing ProductDetailScreen
class CatalogProduct {
  final String id;
  final String title;
  final String category;
  final double price;
  final double rating;
  final String image;
  CatalogProduct({required this.id, required this.title, required this.category, required this.price, required this.rating, required this.image});
}