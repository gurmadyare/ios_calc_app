import 'package:flutter/material.dart';

class MyFont extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  const MyFont({
    super.key,
    required this.text,
    this.fontSize = 24,
    this.fontWeight = FontWeight.w400,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color),
    );
  }
}
