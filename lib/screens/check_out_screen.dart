import 'package:flutter/material.dart';
import '../models/catalog_data.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/checkout_button.dart';
import '../widgets/chekut_summary.dart';
import '../widgets/cheout_appbar.dart';
import '../widgets/shipping_info_card.dart';

import 'product_detail_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final Map<String, int> cart = {
    'p1': 4,
    'p2': 1,
  };

  double get totalPrice {
    return cart.entries.fold(0, (sum, entry) {
      final product = demoProducts.firstWhere((p) => p.id == entry.key);
      return sum + product.price * entry.value;
    });
  }

  int get totalItems => cart.values.fold(0, (sum, qty) => sum + qty);

  void increment(String id) => setState(() => cart[id] = (cart[id] ?? 0) + 1);

  void decrement(String id) {
    setState(() {
      if ((cart[id] ?? 0) > 1) cart[id] = cart[id]! - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CheckoutAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: cart.entries.map((entry) {
                  final product =
                      demoProducts.firstWhere((p) => p.id == entry.key);
                  final qty = entry.value;
                  return CartItemTile(
                    product: product,
                    qty: qty,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProductDetailScreen(product: product),
                        ),
                      );
                    },
                    onIncrement: () => increment(product.id),
                    onDecrement: () => decrement(product.id),
                  );
                }).toList(),
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
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Pago realizado con éxito"),
                    backgroundColor: Colors.black,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
