import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:prog2025_firtst/widgets/player_card.dart';

class PlayersScreen extends StatelessWidget {
  const PlayersScreen({super.key});

  double radians(double degrees) {
    return degrees * (math.pi / 180);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFE0F0), Color(0xFFFFC1E3), Color(0xFFFFA3D6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          children: const [
            PlayerCard(image: 'assets/player1.png'),
            PlayerCard(image: 'assets/player2.png'),
            PlayerCard(image: 'assets/player3.png'),
          ],
        ),
      ),
    );
  }
}