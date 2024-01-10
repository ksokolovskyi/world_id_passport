import 'package:flutter/material.dart';

class PageClipper extends StatelessWidget {
  const PageClipper({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipper: const _PageClipper(),
      child: child,
    );
  }
}

class _PageClipper extends CustomClipper<RRect> {
  const _PageClipper();

  @override
  RRect getClip(Size size) {
    final width = size.width;
    final leftRadius = Radius.circular(width * 0.0102);
    final rightRadius = Radius.circular(width * 0.0408);

    return RRect.fromRectAndCorners(
      Offset.zero & size,
      topLeft: leftRadius,
      bottomLeft: leftRadius,
      topRight: rightRadius,
      bottomRight: rightRadius,
    );
  }

  @override
  bool shouldReclip(covariant CustomClipper<RRect> oldClipper) => false;
}
