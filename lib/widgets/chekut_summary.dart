import 'package:flutter/material.dart';

class CheckoutSummary extends StatelessWidget {
  final int totalItems;
  final double totalPrice;

  const CheckoutSummary({
    super.key,
    required this.totalItems,
    required this.totalPrice,
  });

  Widget _summaryRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(color: Colors.grey[200], thickness: 1),
        _summaryRow("Total ($totalItems items)",
            "\$${totalPrice.toStringAsFixed(2)}"),
        _summaryRow("Shipping Fee", "\$0.00"),
        _summaryRow("Discount", "\$0.00"),
        Divider(color: Colors.grey[200], thickness: 1),
        _summaryRow("Sub Total", "\$${totalPrice.toStringAsFixed(2)}",
            bold: true),
      ],
    );
  }
}
