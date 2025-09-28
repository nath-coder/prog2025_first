import 'package:flutter/material.dart';

class PointsCard extends StatelessWidget {
  final int value;
  final int maxLevel;

  const PointsCard({super.key, required this.value, required this.maxLevel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0052FF),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 28,
                child: Icon(Icons.emoji_events,
                    color: Colors.amber, size: 32),
              ),
              const Spacer(),
              SizedBox(
                width: 140,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      right: 0,
                      top: 0,
                      child: _circle(90, 0.08),
                    ),
                    Positioned(
                      left: 10,
                      bottom: -20,
                      child: _circle(90, 0.12),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: _circle(90, 0.18),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text("Point:",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18)),
                          Text(
                            "$value",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: value / maxLevel,
              backgroundColor: Colors.white,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.red),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$value",
                  style: const TextStyle(color: Colors.white)),
              Text("Max Level: $maxLevel",
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circle(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}
