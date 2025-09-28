import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../models/catalog_data.dart';
import 'product_detail_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String selectedCategory = 'All Items';
  final Set<String> favorites = {};

  final List<Map<String, dynamic>> categoryOptions = [
    {'label': 'All Items', 'icon': Icons.grid_view},
    {'label': 'Dress', 'icon': Icons.checkroom},
    {'label': 'T-Shirt', 'icon': Icons.checkroom},
    {'label': 'Pants', 'icon': Icons.checkroom},
    {'label': 'Shoes', 'icon': Icons.directions_run},
    {'label': 'Hat', 'icon': Icons.emoji_emotions},
    {'label': 'Watch', 'icon': Icons.watch},
    {'label': 'Bag', 'icon': Icons.work},
  ];

  List<Product> get filteredProducts {
    if (selectedCategory == 'All Items') return demoProducts;
    return demoProducts.where((p) => p.category == selectedCategory).toList();
  }

  void toggleFavorite(String id) {
    setState(() {
      if (favorites.contains(id)) {
        favorites.remove(id);
      } else {
        favorites.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Column(
        children: [
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Hello, Welcome 👋", style: TextStyle(fontSize: 16, color: Colors.black54)),
                    SizedBox(height: 4),
                    Text("Albert Stevano", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=3"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(color: Colors.black87), // Color del texto ingresado
                    decoration: InputDecoration(
                      hintText: "Search clothes...",
                      hintStyle: TextStyle(color: Colors.grey[500]), // Color del hint
                      filled: true,
                      fillColor: Colors.white, // Fondo gris claro
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!), // Borde gris claro
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[500]!, width: 1.5), // Borde más oscuro al enfocar
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(7),
                    child: Icon(Icons.filter_list, color: Colors.white, size: 28),
                  ),
                  onPressed: () {
                    // Acción al presionar el botón de filtro
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categoryOptions.length,
              separatorBuilder: (_, __) => SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = categoryOptions[index];
                final isSelected = cat['label'] == selectedCategory;
                return ChoiceChip(
                  avatar: Icon(cat['icon'], size: 18, color: isSelected ? Colors.white : Colors.black),
                  label: Text(cat['label']),
                  selected: isSelected,
                  onSelected: (_) => setState(() => selectedCategory = cat['label']),
                  selectedColor: Colors.black,
                  labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                  backgroundColor: Colors.grey[200],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  final isFavorite = favorites.contains(product.id);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailScreen(product: product),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                             Hero(
                                tag: product.id,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(16)),
                                  child: Image.network(product.image, fit: BoxFit.cover),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () => toggleFavorite(product.id),
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.black.withOpacity(0.9),
                                    child: Icon(
                                      isFavorite ? Icons.favorite : Icons.favorite_border,
                                      color: isFavorite ? Colors.white : Colors.white,
                                      size: 18,
                                    ),
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
                                Text(product.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Text(product.category, style: TextStyle(fontSize: 14, color: Colors.black54)),
                                SizedBox(height: 4),
                                Row(children: [
                                  
                                  Text("\$${product.price.toStringAsFixed(2)}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  SizedBox(width: 40),
                                  Icon(Icons.star, size: 16, color: Colors.amber),
                                  SizedBox(width: 4),
                                  Text(product.rating.toStringAsFixed(1), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                  
                                ]),
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
    );
  }
}
