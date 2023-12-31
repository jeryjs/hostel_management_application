import 'package:flutter/material.dart';
import 'dart:math';

class RandomPersonIcon extends StatelessWidget {
  final double size;
  final Color color;

  const RandomPersonIcon({super.key, required this.size, this.color = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return Icon(
      // Show a random icon for student image
      [
        Icons.person,
        Icons.person_2,
        Icons.person_3,
        Icons.person_4,
      ][Random().nextInt(4)],
      size: size,
      color: color,
    );
  }
}
