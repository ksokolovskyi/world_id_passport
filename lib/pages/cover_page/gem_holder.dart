import 'dart:math' as math;

import 'package:flutter/material.dart';

class GemHolder extends StatefulWidget {
  const GemHolder({super.key});

  @override
  State<GemHolder> createState() => _GemHolderState();
}

class _GemHolderState extends State<GemHolder> {
  final _painter = _GemHolderPainter();

  @override
  void dispose() {
    _painter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AspectRatio(
        aspectRatio: 1,
        child: CustomPaint(painter: _painter),
      ),
    );
  }
}

class _GemHolderPainter extends CustomPainter {
  _GemHolderPainter();

  Shader? _outerCirclePaintShader;
  Shader? _dashesCirclePaintShader;
  Path? _dashesPath;
  Rect? _cachedRect;

  void dispose() {
    _outerCirclePaintShader?.dispose();
    _dashesCirclePaintShader?.dispose();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final outerCircleRect = Offset.zero & size;

    if (_cachedRect != outerCircleRect) {
      _outerCirclePaintShader?.dispose();
      _outerCirclePaintShader = null;
      _dashesCirclePaintShader?.dispose();
      _dashesCirclePaintShader = null;
      _dashesPath = null;
      _cachedRect = outerCircleRect;
    }

    _drawOuterCircle(canvas, outerCircleRect);
    _drawDashes(canvas, outerCircleRect);
    _drawInnerCircle(canvas, outerCircleRect);
  }

  void _drawOuterCircle(Canvas canvas, Rect outerCircleRect) {
    if (_outerCirclePaintShader == null) {
      const gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF131215), Color(0xFF191B1D), Color(0xFF151718)],
        stops: [0.0163, 0.1518, 0.9837],
      );
      _outerCirclePaintShader = gradient.createShader(outerCircleRect);
    }

    canvas.drawCircle(
      outerCircleRect.center,
      outerCircleRect.width / 2,
      Paint()
        ..style = PaintingStyle.fill
        ..shader = _outerCirclePaintShader,
    );
  }

  void _drawDashes(Canvas canvas, Rect outerCircleRect) {
    final dashesCircleRect = outerCircleRect.deflate(
      outerCircleRect.width * 0.0656 / 2,
    );
    final strokeWidth = dashesCircleRect.height * 0.0116;

    if (_dashesPath == null) {
      final source = Path()..addOval(dashesCircleRect.deflate(strokeWidth / 2));
      final metric = source.computeMetrics().toList().first;

      final length = metric.length;
      const gapRatio = 1.3;
      const dashesCount = 40;
      final dashWidth = length / (dashesCount + gapRatio * dashesCount);
      final gapWidth = dashWidth * gapRatio;

      final dashesPath = Path();

      var distance = 0.0;
      var draw = true;

      while (distance <= metric.length) {
        if (draw) {
          dashesPath.addPath(
            metric.extractPath(distance, distance + dashWidth),
            Offset.zero,
          );
          distance += dashWidth;
        } else {
          distance += gapWidth;
        }

        draw = !draw;
      }

      _dashesPath = dashesPath;

      const gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF2D2D2F), Color(0xFF29282B), Color(0xFF29282D)],
        stops: [0.0, 0.495, 1.0],
      );
      _dashesCirclePaintShader = gradient.createShader(dashesCircleRect);
    }

    canvas.drawPath(
      _dashesPath!,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = strokeWidth
        ..shader = _dashesCirclePaintShader,
    );
  }

  void _drawInnerCircle(Canvas canvas, Rect outerCircleRect) {
    final innerCircleRect = outerCircleRect.deflate(
      outerCircleRect.width * 0.2264 / 2,
    );

    final shadow1 = BoxShadow(
      color: const Color(0xFF686666),
      offset: Offset(0, innerCircleRect.height * 0.0585),
      spreadRadius: innerCircleRect.height * -0.0219,
      blurRadius: innerCircleRect.height * 0.0439,
    );

    final shadow2 = BoxShadow(
      color: const Color.fromRGBO(0, 0, 0, 0.25),
      offset: Offset(0, innerCircleRect.height * -0.0146),
      blurRadius: innerCircleRect.height * 0.0292,
    );

    _drawShadow(canvas, innerCircleRect, shadow1);
    _drawShadow(canvas, innerCircleRect, shadow2);

    canvas.drawCircle(
      innerCircleRect.center,
      innerCircleRect.width / 2,
      Paint()..color = const Color(0xFF161819),
    );

    final shadow3 = BoxShadow(
      color: const Color.fromRGBO(0, 0, 0, 0.3),
      offset: Offset(0, innerCircleRect.height * 0.1463),
      blurRadius: innerCircleRect.height * 0.0878,
    );

    _drawInsetShadow(canvas, innerCircleRect, shadow3);
  }

  void _drawShadow(Canvas canvas, Rect circleRect, BoxShadow shadow) {
    final shadowBounds =
        circleRect.shift(shadow.offset).inflate(shadow.spreadRadius);

    canvas.drawCircle(
      shadowBounds.center,
      shadowBounds.width / 2,
      shadow.toPaint(),
    );
  }

  // Inset shadow drawing logic is copied from flutter_inset_box_shadow package.
  // https://github.com/johynpapin/flutter_inset_box_shadow/blob/main/lib/src/box_decoration.dart
  void _drawInsetShadow(Canvas canvas, Rect circleRect, BoxShadow shadow) {
    final borderRadiusGeometry = BorderRadius.circular(circleRect.width);
    final borderRadius = borderRadiusGeometry.resolve(TextDirection.ltr);

    final clipRRect = borderRadius.toRRect(circleRect);

    final innerRect = circleRect.deflate(shadow.spreadRadius);
    final innerRRect = borderRadius.toRRect(innerRect);
    final outerRect = _areaCastingShadowInHole(circleRect, shadow);

    canvas
      ..save()
      ..clipRRect(clipRRect)
      ..drawDRRect(
        RRect.fromRectAndRadius(outerRect, Radius.zero),
        innerRRect.shift(shadow.offset),
        Paint()
          ..color = shadow.color
          ..colorFilter = ColorFilter.mode(shadow.color, BlendMode.src)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadow.blurSigma),
      )
      ..restore();
  }

  Rect _areaCastingShadowInHole(Rect holeRect, BoxShadow shadow) {
    var bounds = holeRect;
    bounds = bounds.inflate(shadow.blurRadius);

    if (shadow.spreadRadius < 0) {
      bounds = bounds.inflate(-shadow.spreadRadius);
    }

    final offsetBounds = bounds.shift(shadow.offset);

    return _unionRects(bounds, offsetBounds);
  }

  Rect _unionRects(Rect a, Rect b) {
    if (a.isEmpty) {
      return b;
    }

    if (b.isEmpty) {
      return a;
    }

    final left = math.min(a.left, b.left);
    final top = math.min(a.top, b.top);
    final right = math.max(a.right, b.right);
    final bottom = math.max(a.bottom, b.bottom);

    return Rect.fromLTRB(left, top, right, bottom);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
