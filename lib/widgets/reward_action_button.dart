// ...existing code...
import 'package:flutter/material.dart';

class RewardActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const RewardActionButton({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const cardBg = Color(0xFF2A2647); // darker purple
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 8, offset: const Offset(0,4))],
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(icon, color: iconColor, size: 36),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// ...existing code...