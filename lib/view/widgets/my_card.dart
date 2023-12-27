import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final Color bgColor;
  final Color outlineColor;
  final Widget child;

  const MyCard({
    super.key,
    required this.bgColor,
    required this.outlineColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: outlineColor, width: 1.5),
          borderRadius: BorderRadius.circular(16)),
      child: child,
    );
  }
}
