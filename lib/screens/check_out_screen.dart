import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:prog2025_firtst/database/category.dart';
import 'package:prog2025_firtst/database/product_detail.dart';
import 'package:prog2025_firtst/database/purchase.dart';
import 'package:prog2025_firtst/database/purchase_detail.dart';
import 'package:prog2025_firtst/models/category_dao.dart';
import 'package:prog2025_firtst/models/product_dao.dart';
import 'package:prog2025_firtst/models/purchase_dao.dart';
import 'package:prog2025_firtst/screens/product_detail_screen.dart';

import '../widgets/cart_item_tile.dart';
import '../widgets/checkout_button.dart';
import '../widgets/chekut_summary.dart';
import '../widgets/cheout_appbar.dart';
import '../widgets/shipping_info_card.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final PurchaseDatabaseCRUD _purchaseDB = PurchaseDatabaseCRUD();
  final PurchaseDetailDatabase _purchaseDetailDB = PurchaseDetailDatabase();
  final ProductDetailDatabase _productDetailDB = ProductDetailDatabase();
  final CategoryDatabase _categoryDB = CategoryDatabase();
  late User user;
  late String userId;
  PurchaseDao? _cartPurchase;
  List<CategoryDao> _categories = [];
  List<Map<String, dynamic>> _items = []; // each map from SELECT_WITH_PRODUCT_INFO
  bool _loading = true;
  late final ConfettiController _confettiController;


  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    userId = user.uid;
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _loadCartPurchase();
  }


  Future<void> _loadCartPurchase() async {
    setState(() => _loading = false);
    try {
      final _categories = await _categoryDB.SELECT();
      for (var cat in _categories) {
        if (kDebugMode) {
          if(cat.idCategory == 2) {
            print('Category loaded: ${cat.idCategory} - ${cat.nameCategory}');
          }
        }
      }
      final purchases = await _purchaseDB.SELECT_BY_USER_AND_STATE(userId, 'CART');
      print('Loaded purchases for user $userId: ${purchases.length} items');
      if (purchases.isNotEmpty) {
        final cart = purchases.first;
        print(  'Current cart purchase ID: ${cart.idPurchase}');
        final details = await _purchaseDetailDB.SELECT_WITH_PRODUCT_INFO(cart.idPurchase ?? 0);
        print('Loaded purchase details: ${details.length} items');
        setState(() {
          _cartPurchase = cart;
          _items = details;
        });
      } else {
        setState(() {
          _cartPurchase = null;
          _items = [];
        });
      }
    } catch (e) {
      // ignore errors for now
      
    } finally {
    }
  }

  int get totalItems => _items.fold(0, (s, it) => s + ((it['quantity'] as int?) ?? 0));

  double get totalPrice {
    return _items.fold(0.0, (s, it) {
      final q = (it['quantity'] as int?) ?? 0;
      final p = (it['price'] as num?)?.toDouble() ?? 0.0;
      return s + q * p;
    });
  }

  Future<void> _incrementItem(Map<String, dynamic> item) async {
    final idPurchase = item['idPurchase'] as int?;
    final idProductDetail = item['idProductDetail'] as int?;
    if (idPurchase == null || idProductDetail == null) return;
    final currentQty = (item['quantity'] as int?) ?? 0;
    final stock = (item['stock'] as int?) ?? 0;
    if (stock > 0 && currentQty >= stock) return; // can't exceed stock
    final newQty = currentQty + 1;
    await _purchaseDetailDB.UPDATE_QUANTITY(idPurchase, idProductDetail, newQty);
    await _refreshDetails();
  }

  Future<void> _decrementItem(Map<String, dynamic> item) async {
    final idPurchase = item['idPurchase'] as int?;
    final idProductDetail = item['idProductDetail'] as int?;
    if (idPurchase == null || idProductDetail == null) return;
    final currentQty = (item['quantity'] as int?) ?? 0;
    if (currentQty <= 1) return;
    final newQty = currentQty - 1;
    await _purchaseDetailDB.UPDATE_QUANTITY(idPurchase, idProductDetail, newQty);
    await _refreshDetails();
  }

  Future<void> _removeItem(Map<String, dynamic> item) async {
    final idPurchase = item['idPurchase'] as int?;
    final idProductDetail = item['idProductDetail'] as int?;
    if (idPurchase == null || idProductDetail == null) return;
    await _purchaseDetailDB.DELETE(idPurchase, idProductDetail);
    await _refreshDetails();
  }

  Future<void> _refreshDetails() async {
    if (_cartPurchase?.idPurchase == null) return _loadCartPurchase();
    final details = await _purchaseDetailDB.SELECT_WITH_PRODUCT_INFO(_cartPurchase!.idPurchase!);
    // also update purchase total (optional) or rely on recompute
    setState(() => _items = details);
  }

  Future<void> _checkout() async {
    if (_cartPurchase?.idPurchase == null) return;

    try {
      for (var item in _items) {
        final idProductDetail = item['idProductDetail'] as int?;
        final quantity = (item['quantity'] as int?) ?? 0;
        if (idProductDetail == null) continue;
        await _productDetailDB.DECREMENT_STOCK(idProductDetail, quantity);
      }
      await _purchaseDB.UPDATE(
        PurchaseDao(
          idPurchase: _cartPurchase!.idPurchase,
          userId: _cartPurchase!.userId,
          date: _cartPurchase!.date,
          total: totalPrice,
          state: 'shipping',
        )
      );

      MotionToast.success(
        title: const Text("Payment complete"),
        description: Text("Your order has been placed. Order #${_cartPurchase!.idPurchase}"),
        animationType: AnimationType.slideInFromTop, // entra desde abajo
        // Removed the invalid 'position' parameter
        width: 350,
        barrierColor: Colors.black26, // opcional: añade un leve fondo semitransparente
        dismissable: true, // permite cerrarlo tocando afuera
      ).show(context);
      _confettiController.play();
      await _loadCartPurchase();
    } catch (e) {
      MotionToast.error(
        title: const Text("Checkout failed"),
        description: Text("An error occurred during checkout: ${e.toString()}"),
        animationType: AnimationType.slideInFromLeft,
        width: 350,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CheckoutAppBar(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _cartPurchase == null || _items.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.shopping_cart_outlined, size: 72, color: Colors.grey),
                          SizedBox(height: 12),
                          Text('Your cart is empty', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            itemCount: _items.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final item = _items[index];
                              final title = (item['titulo'] ?? 'Product') as String;
                              final image = (item['image'] ?? '') as String;
                              final qty = (item['quantity'] as int?) ?? 0;
                              final price = (item['price'] as num?)?.toDouble() ?? 0.0;
                              final size = (item['size'] ?? '') as String;
                              final color = (item['color'] ?? '') as String;
                              return CartItemTile(
                                // CartItemTile expects a product model from demo; adapt to minimal parameters
                                product: ProductDao(
                                  idProduct: item['idProduct'] as int?,
                                  titulo: title,
                                  price: price,
                                  image: image,
                                  idCategory: item['idCategory'] as int?,
                                ),
                                qty: qty,
                                nameCategory: '${item['color']} / ${item['size']}',
                                onTap: () {
                                  print('Tapped on product id: ${item['idProductDetail']}');
                                   Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => ProductDetailScreen(product: ProductDao(
                                  idProduct: item['idProductDetail'] as int?,
                                  titulo: title,
                                  price: price,
                                  image: image,
                                  idCategory: item['idCategory'] as int?,
                                ),
                                 ),)).then((_) =>());
                                },
                                onIncrement: () => _incrementItem(item),
                                onDecrement: () => _decrementItem(item),
                                onDelete: () => _removeItem(item),
                                // show custom child inside tile if needed
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Shipping Information",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const ShippingInfoCard(),
                        const SizedBox(height: 24),
                        CheckoutSummary(
                          totalItems: totalItems,
                          totalPrice: totalPrice,
                        ),
                        const SizedBox(height: 24),
                        CheckoutButton(
                          onPressed: _currentStockCheckAndCheckout,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
        ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _currentStockCheckAndCheckout() async {
    // ensure all items have stock > 0
    final outOfStock = _items.where((it) => ((it['stock'] as int?) ?? 0) <= 0).toList();
    if (outOfStock.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Some items are out of stock'), backgroundColor: Colors.red));
      return;
    }
    await _checkout();
  }
}