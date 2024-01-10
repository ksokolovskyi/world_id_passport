import 'dart:math' as math;

import 'package:flutter/material.dart';

class RainbowPageBackground extends StatefulWidget {
  const RainbowPageBackground({super.key});

  @override
  State<RainbowPageBackground> createState() => _RainbowPageBackgroundState();
}

class _RainbowPageBackgroundState extends State<RainbowPageBackground> {
  final _backgroundPainter = _BackgroundPainter();

  @override
  void dispose() {
    _backgroundPainter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _backgroundPainter,
        foregroundPainter: _WavesPainter(),
      ),
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  Shader? _gradientPaintShader;
  Rect? _cashedRect;

  void dispose() {
    _gradientPaintShader?.dispose();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    if (_cashedRect != rect) {
      _gradientPaintShader?.dispose();

      const gradient = RadialGradient(
        center: Alignment.topRight,
        colors: <Color>[
          Color(0xFFD0E2DE),
          Color(0xFFECEADE),
          Color(0xFFECDFF0),
          Color(0xFFE0E0EF),
          Color(0xFFD6E9DC),
          Color(0xFFD5E4EF),
        ],
        stops: [0, 0.22, 0.53, 0.74, 0.875, 1],
        radius: 1.6,
        transform: _CustomGradientTransform(),
      );

      _gradientPaintShader = gradient.createShader(rect);
      _cashedRect = rect;
    }

    canvas.drawRect(
      rect,
      Paint()..shader = _gradientPaintShader,
    );
  }

  @override
  bool shouldRepaint(_BackgroundPainter oldDelegate) => false;
}

class _CustomGradientTransform extends GradientTransform {
  const _CustomGradientTransform();

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    const radians = math.pi / 1.35;
    final sinRadians = math.sin(radians);
    final oneMinusCosRadians = 1 - math.cos(radians);
    final center = bounds.topRight;
    final originX = sinRadians * center.dy + oneMinusCosRadians * center.dx;
    final originY = -sinRadians * center.dx + oneMinusCosRadians * center.dy;

    return Matrix4.identity()
      ..translate(originX, originY)
      ..rotateZ(radians)
      ..scale(1.0, 0.5);
  }
}

class _WavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const wavesCount = 60;
    const peaksCount = 11;

    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();

    final waveLength = size.width / peaksCount;
    final halfWaveLength = waveLength / 2;
    final amplitude = size.height / (wavesCount - 1);

    var dx = 0.0;
    var dy = 0.0;

    for (var i = 0; i < wavesCount; i++) {
      path.moveTo(dx, dy);

      for (var j = 0; j < peaksCount; j++) {
        dx += waveLength;

        path.quadraticBezierTo(
          dx - halfWaveLength,
          j.isEven ? dy - amplitude : dy + amplitude,
          dx,
          dy,
        );
      }

      dx = 0;
      dy += amplitude;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_WavesPainter oldDelegate) => false;
}
