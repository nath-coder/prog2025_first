import 'package:flutter/material.dart';
import 'package:prog2025_firtst/widgets/attribute_painter.dart';

class AttributeWidget extends StatelessWidget {
  final double size;
  final double progress;
  final Widget? child;
  final String image;

  const AttributeWidget({
    Key? key,
    required this.progress,
    this.size = 55,
    this.child,
    required this.image,  
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: AttributePainter(
        progressPercent: progress,
      ),
      size: Size(size, size),
      child: Container(
        padding: EdgeInsets.all(size / 3.8),
        width: size,
        height: size,
        child: Image.asset(image),
      ),
    );
  }
}
