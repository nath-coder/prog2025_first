import 'package:flutter/material.dart';

class ShippingInfoCard extends StatelessWidget {
  const ShippingInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Icon(Icons.credit_card, color: Colors.black),
            Text("VISA ***** ***** ***** 2143",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Icon(Icons.keyboard_arrow_down, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
