import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prog2025_firtst/database/purchase.dart';
import 'package:prog2025_firtst/database/purchase_detail.dart';
import 'package:prog2025_firtst/models/product_dao.dart';
import 'package:prog2025_firtst/database/product_detail.dart';
import 'package:prog2025_firtst/models/productDetail_dao.dart';
import 'package:prog2025_firtst/models/purchaseDatail_dao.dart';
import 'package:prog2025_firtst/models/purchase_dao.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductDao product;
  const ProductDetailScreen({required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String selectedSize = '';
  String selectedColor = '';
  int quantity = 1;
  bool isFavorite = false;
  late User user;
  late String userId;
  bool _loadingDetails = true;
  final ProductDetailDatabase _pdDB = ProductDetailDatabase();
  final PurchaseDatabaseCRUD _purchaseDatabaseCRUD = PurchaseDatabaseCRUD(); 
  final PurchaseDetailDatabase _purchaseDetailDatabaseCRUD = PurchaseDetailDatabase();
  List<ProductdetailDao> _details = [];
  List<String> _sizes = [];
  List<String> _colors = [];
  // map "color|size" -> stock
  Map<String, int> _stockByCombo = {};
  // map "color|size" -> image (optional)
  Map<String, String?> _imageByCombo = {};
  //map "color|size" _> idProductDetail
  Map<String, int> _idByCombo = {};

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    userId = user.uid;
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    print('Loading details for product id: ${widget.product.idProduct}');
    final pid = widget.product.idProduct;

    if (pid == null) {
      setState(() {
        _loadingDetails = false;
      });
      return;
    }

    try {
      print('Loading details for product id: $pid');
      final details = await _pdDB.SELECT_BY_PRODUCT(pid);
      // normalize and extract unique sizes/colors and stock map
      final sizeSet = <String>{};
      final colorSet = <String>{};
      final stockMap = <String, int>{};
      final idMap = <String, int>{};
      final imageMap = <String, String?>{};

      for (var d in details) {
        print("details of product: ${d.idProductDetail}, color: ${d.color}, size: ${d.size}, stock: ${d.quantity}");
        final size = (d.size ?? '').trim();
        final color = (d.color ?? '').trim();
        if (size.isNotEmpty) sizeSet.add(size);
        if (color.isNotEmpty) colorSet.add(color);
        final key = '${color.toLowerCase()}|${size.toLowerCase()}';
        stockMap[key] = (d.quantity ?? 0);
        imageMap[key] = d.imageDetail;
        idMap[key] = d.idProductDetail??0;
        print("Mapped key: $key combo id ${idMap[key]}");
      }

      setState(() {
        _details = details;
        _sizes = sizeSet.toList()..sort();
        _colors = colorSet.toList();
        _stockByCombo = stockMap;
        _imageByCombo = imageMap;
        _idByCombo = idMap;
        
        // choose defaults if available
        if (_sizes.isNotEmpty) selectedSize = _sizes.first;
        if (_colors.isNotEmpty) selectedColor = _colors.first;
        // ensure quantity not exceed stock
        _ensureQuantityWithinStock();
        _loadingDetails = false;
      });
    } catch (e) {
      setState(() {
        _loadingDetails = false;
      });
    }
  }

  void _ensureQuantityWithinStock() {
    final key = '${selectedColor.toLowerCase()}|${selectedSize.toLowerCase()}';
    final stock = _stockByCombo[key] ?? 0;
    if (quantity > stock) quantity = stock > 0 ? stock : 1;
    if (quantity < 1) quantity = 1;
  }

  int _currentStockForSelection() {
    final key = '${selectedColor.toLowerCase()}|${selectedSize.toLowerCase()}';
    print("Current stock key: $key");
    return _stockByCombo[key] ?? 0;
  }

  int _currentProductDetailIdForSelection() {
    final key = '${selectedColor.toLowerCase()}|${selectedSize.toLowerCase()}';
    return _idByCombo[key] ?? 0;
  }
  String? _currentImageForSelection() {
    final key = '${selectedColor.toLowerCase()}|${selectedSize.toLowerCase()}';
    return _imageByCombo[key];
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    final displayImage = _currentImageForSelection() ?? product.image;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F3),
      body: Stack(
        children: [
          Column(
            children: [
              Hero(
                tag: product.idProduct ?? '',
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 40, bottom: 0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    child: displayImage != null && displayImage.isNotEmpty
                        ? Image.network(
                            displayImage,
                            height: 450,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 450,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_outlined, size: 64),
                          ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: _loadingDetails
                      ? const Center(child: CircularProgressIndicator())
                      : ListView(
                          padding: const EdgeInsets.only(bottom: 100),
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(product.titulo ?? '',
                                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_rounded),
                                      onPressed: () => setState(() {
                                        if (quantity > 1) quantity--;
                                      }),
                                    ),
                                    Text(quantity.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle_rounded, color: Colors.black),
                                      onPressed: () => setState(() {
                                        final stock = _currentStockForSelection();
                                        if (stock == 0 || quantity < stock) quantity++;
                                      }),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star, size: 16, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text((product.puntuation ?? 0.0).toStringAsFixed(1),
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
                                const SizedBox(width: 8),
                                const Text("(7,932 reviews)", style: TextStyle(color: Colors.blueAccent, fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Its simple and elegant shape makes it perfect for those of you who like you who want minimalist clothes.",
                              style: TextStyle(color: Colors.black87),
                            ),
                            const Text("Read More...", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Sizes
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Choose size", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 8,
                                        children: _sizes.isNotEmpty
                                            ? _sizes.map((size) {
                                                final isSelected = selectedSize == size;
                                                return GestureDetector(
                                                  onTap: () => setState(() {
                                                    selectedSize = size;
                                                    _ensureQuantityWithinStock();
                                                  }),
                                                  child: Container(
                                                    padding: const EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: isSelected ? Colors.black : Colors.grey[300],
                                                    ),
                                                    child: Text(
                                                      size,
                                                      style: TextStyle(
                                                        color: isSelected ? Colors.white : Colors.black,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList()
                                            : [
                                                const Text('No sizes', style: TextStyle(color: Colors.grey))
                                              ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Colors
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Color", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 8,
                                        children: _colors.isNotEmpty
                                            ? _colors.map((colorName) {
                                                final isSelected = selectedColor == colorName;
                                                Color color;
                                                switch (colorName.toLowerCase()) {
                                                  case 'black':
                                                    color = Colors.black;
                                                    break;
                                                  case 'white':
                                                    color = Colors.white;
                                                    break;
                                                  case 'gray':
                                                  case 'grey':
                                                    color = Colors.grey;
                                                    break;
                                                  case 'red':
                                                    color = Colors.red;
                                                    break;
                                                  case 'blue':
                                                    color = Colors.blue;
                                                    break;
                                                  case 'pink':
                                                    color = Colors.pink;
                                                    break;
                                                  case 'brown':
                                                    color = Colors.brown;
                                                    break;
                                                  case 'beige':
                                                    color = const Color(0xFFF5F5DC);
                                                    break;
                                                  case 'multicolor':
                                                    color = Colors.deepPurpleAccent;
                                                    break;
                                                  default:
                                                    color = Colors.grey;
                                                }

                                                return GestureDetector(
                                                  onTap: () => setState(() {
                                                    selectedColor = colorName;
                                                    _ensureQuantityWithinStock();
                                                  }),
                                                  child: Container(
                                                    padding: const EdgeInsets.all(2),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(color: isSelected ? Colors.black : Colors.transparent, width: 2),
                                                    ),
                                                    child: CircleAvatar(
                                                      radius: 14,
                                                      backgroundColor: color,
                                                      child: color == Colors.white
                                                          ? Container(decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey)))
                                                          : null,
                                                    ),
                                                  ),
                                                );
                                              }).toList()
                                            : [
                                                const Text('No colors', style: TextStyle(color: Colors.grey))
                                              ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Stock info
                            Builder(builder: (_) {
                              final stock = _currentStockForSelection();
                              return Row(
                                children: [
                                  const Icon(Icons.inventory_2_outlined, size: 16, color: Colors.black54),
                                  const SizedBox(width: 6),
                                  Text(
                                    stock > 0 ? 'Stock: $stock' : 'Out of stock',
                                    style: TextStyle(color: stock > 0 ? Colors.black87 : Colors.red),
                                  ),
                                ],
                              );
                            }),
                            const SizedBox(height: 8),
                            // Price
                            Row(
                              children: [
                                Text('\$${(product.price ?? 0.0).toStringAsFixed(2)}',
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 12),
                                const Text('(incl. taxes)', style: TextStyle(color: Colors.black54)),
                              ],
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
          // back and favorite buttons
          Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.black),
                onPressed: () => setState(() => isFavorite = !isFavorite),
              ),
            ),
          ),
          // add to cart button
          Positioned(
            bottom: 50,
            left: 16,
            right: 16,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 6,
              ),
              onPressed: _currentStockForSelection() > 0
                  ? () async {
                      int res = 0;
                      List<PurchaseDao> cart = await _purchaseDatabaseCRUD.SELECT_BY_USER_AND_STATE(userId, 'CART');
                      
                      print("details of product: ${widget.product.idProduct}");
                      print("details of cart: ${cart.map((e) => e.idPurchase).toList()}");
                      print(  'Current cart items: ${cart.length}');
                      if(cart.isEmpty){
                        res = await _purchaseDatabaseCRUD.INSERT(PurchaseDao( 
                          state: 'CART',
                          userId: userId,
                          total: 0.0,
                          date: DateTime.now().toString(),
                        ));
                        cart = await _purchaseDatabaseCRUD.SELECT_BY_USER_AND_STATE(userId, 'CART');

                      }
                      if (widget.product.idProduct != null) {
                        List<PurchaseDetailDao> aux = (await _purchaseDetailDatabaseCRUD.SELECT_BY_PURCHASE(
                          cart.first.idPurchase!,
                        ) as List<dynamic>).map((e) => PurchaseDetailDao.fromMap(e as Map<String, dynamic>)).toList();

                       /* for (var detail in aux) {
                          print('Cart detail - idPurchase: ${detail.idPurchase}, idProductDetail: ${detail.idProductDetail}, quantity: ${detail.quantity}');
                          if (detail.idProductDetail == widget.product.idProduct) {
                            print('Matching product found in cart: ${detail.idProductDetail}');
                          }
                        }*/
                        final existingDetail = aux.firstWhere(
                          (detail) =>
                              detail.idProductDetail == _currentProductDetailIdForSelection(),
                          orElse: () => PurchaseDetailDao(),
                        );
                        print('Existing detail found: ${existingDetail.idProductDetail}');
                        if (existingDetail.idProductDetail != null) {
                          // Update existing item quantity
                          final newQuantity = (existingDetail.quantity ?? 0) + quantity;
                          res = await _purchaseDetailDatabaseCRUD.UPDATE_QUANTITY(
                            cart.first.idPurchase!,
                            _currentProductDetailIdForSelection(),
                            newQuantity,
                          );
                        } else {
                          // Insert new item
                          res = await _purchaseDetailDatabaseCRUD.INSERT(
                            cart.first.idPurchase!,
                            _currentProductDetailIdForSelection(),
                            quantity,
                            (widget.product.price ?? 0.0),
                          );
                        }
                        
                      }
                      
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(res > 0 ? 'Product added to cart!' : 'Failed to add product to cart!'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.black87,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  : null,
              child: Text(
                'Add to Cart | \$${(product.price ?? 0.0).toStringAsFixed(2)} (\$${((product.price ?? 0.0)*quantity).toStringAsFixed(2)})',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}