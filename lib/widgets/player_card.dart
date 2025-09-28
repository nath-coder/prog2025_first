import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:prog2025_firtst/widgets/attribute_widget.dart';

class PlayerCard extends StatelessWidget {
  final String image;
  const PlayerCard({super.key, required this.image});

  double radians(double degrees) {
    return degrees * (math.pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.translate(
            offset: const Offset(-10, 0),
            child: Transform(
              alignment: FractionalOffset.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.01)
                ..rotateY(radians(1.5)),
              child: Container(
                height: 216,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.pink.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(22)),
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(-44, 0),
            child: Transform(
              alignment: FractionalOffset.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.01)
                ..rotateY(radians(8)),
              child: Container(
                height: 188,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.pink.withOpacity(0.4),
                  borderRadius: const BorderRadius.all(Radius.circular(22)),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Transform.translate(
              offset: const Offset(-30, 0),
              child: Image.asset(
                image,
                width: 325,
                height: 325,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.only(right: 58),
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const AttributeWidget(
                    progress: 10.5,
                    image: "assets/pata.png",
                  ),
                  const AttributeWidget(
                    progress: 40,
                    image: "assets/mascota.png",
                  ),
                  const AttributeWidget(
                    progress: 67,
                    image: "assets/juguete.png",
                  ),
                  SizedBox(
                    height: 32,
                    child: OutlinedButton(
                      child: const Text(
                        'See Details',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                     onPressed: () {
                        Navigator.pushNamed(
                          context,
                          "/details",
                          arguments: image,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}