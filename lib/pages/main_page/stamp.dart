import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:world_id_passport/assets.dart';
import 'package:world_id_passport/pages/pages.dart';
import 'package:world_id_passport/world_id_theme.dart';

class Stamp extends StatefulWidget {
  const Stamp({super.key});

  @override
  State<Stamp> createState() => _StampState();
}

class _StampState extends State<Stamp> {
  _StampPainter? _painter;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final worldIdTheme = context.worldIdTheme;

    _painter?.dispose();

    _painter = _StampPainter(
      titleText: '* VERIFIED MOBILE DEVICE *',
      timestampText: '04 01 24  20 58 36',
      idText: '3333',
      typeText: 'TYPE',
      systemText: 'SYSTEM',
      serialNumberText: 'SERIAL NO',
      color: worldIdTheme.darkTextColor,
      titleStyle: worldIdTheme.labelLargeTextStyle,
      timestampStyle: worldIdTheme.titleMediumTextStyle,
      smallLabelStyle: worldIdTheme.labelSmallTextStyle,
    );
  }

  @override
  void dispose() {
    _painter?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Transform.rotate(
        angle: -math.pi / 10,
        filterQuality: FilterQuality.low,
        child: AspectRatio(
          aspectRatio: 193 / 96,
          child: AssetImageMask(
            assetKey: Assets.stampMask,
            blendMode: BlendMode.dstOut,
            child: CustomPaint(painter: _painter),
          ),
        ),
      ),
    );
  }
}

class _StampPainter extends CustomPainter {
  _StampPainter({
    required this.titleText,
    required this.timestampText,
    required this.idText,
    required this.typeText,
    required this.systemText,
    required this.serialNumberText,
    required this.color,
    required this.titleStyle,
    required this.timestampStyle,
    required this.smallLabelStyle,
  });

  final String titleText;

  final String timestampText;

  final String idText;

  final String typeText;

  final String systemText;

  final String serialNumberText;

  final Color color;

  final TextStyle titleStyle;

  final TextStyle timestampStyle;

  final TextStyle smallLabelStyle;

  final _titleTextPainter = TextPainter(
    maxLines: 1,
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );
  final _idTextPainter = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );
  final _timestampTextPainter = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );
  final _typeTextPainter = TextPainter(
    textDirection: TextDirection.ltr,
  );
  final _systemTextPainter = TextPainter(
    textDirection: TextDirection.ltr,
  );
  final _serialNumberTextPainter = TextPainter(
    textDirection: TextDirection.ltr,
  );

  void dispose() {
    _titleTextPainter.dispose();
    _idTextPainter.dispose();
    _timestampTextPainter.dispose();
    _typeTextPainter.dispose();
    _systemTextPainter.dispose();
    _serialNumberTextPainter.dispose();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;

    final strokeWidth = math.min<double>(height * 0.0156, 3);
    final halfStrokeWidth = strokeWidth / 2;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final outerRect = (Offset.zero & size).deflate(halfStrokeWidth);
    canvas.drawRect(outerRect, paint);

    final titleRect = Rect.fromLTWH(
      outerRect.left,
      outerRect.top,
      outerRect.width * 0.932,
      outerRect.height * 0.218,
    );
    canvas.drawRect(titleRect, paint);

    final dateRect = Rect.fromLTWH(
      outerRect.left,
      titleRect.bottom,
      titleRect.width,
      outerRect.height * 0.564,
    );
    canvas.drawRect(dateRect, paint);

    final idRect = Rect.fromLTWH(
      titleRect.right,
      outerRect.top,
      outerRect.width * 0.068,
      outerRect.height * 0.782,
    );
    canvas.drawRect(idRect, paint);

    final typeRect = Rect.fromLTWH(
      outerRect.left,
      dateRect.bottom,
      outerRect.width * 1 / 3,
      outerRect.height * 0.218,
    );
    canvas.drawRect(typeRect, paint);

    final systemRect = Rect.fromLTWH(
      typeRect.right,
      dateRect.bottom,
      typeRect.width,
      typeRect.height,
    );
    canvas.drawRect(systemRect, paint);

    final serialNumberRect = Rect.fromLTWH(
      systemRect.right,
      dateRect.bottom,
      systemRect.width,
      systemRect.height,
    );
    canvas.drawRect(serialNumberRect, paint);

    final titleSize = height * 0.1;
    final maxTitleWidth = titleRect.width;
    final maxTitleHeight = titleRect.height;
    _titleTextPainter
      ..text = TextSpan(
        text: titleText,
        style: titleStyle.copyWith(
          fontSize: titleSize,
          letterSpacing: titleSize * 0.14,
        ),
      )
      ..layout(maxWidth: maxTitleWidth);
    final titleWidth = _titleTextPainter.width;
    final titleHeight = _titleTextPainter.height;
    _titleTextPainter.paint(
      canvas,
      Offset(
        (maxTitleWidth - titleWidth) / 2 + halfStrokeWidth,
        (maxTitleHeight - titleHeight) / 2 + strokeWidth,
      ),
    );

    final timestampSize = height * 0.156;
    final maxTimestampWidth = dateRect.width;
    final maxTimestampHeight = dateRect.height;
    _timestampTextPainter
      ..text = TextSpan(
        text: timestampText,
        style: timestampStyle.copyWith(fontSize: timestampSize),
      )
      ..layout(maxWidth: maxTimestampWidth);
    final timestampWidth = _timestampTextPainter.width;
    final timestampHeight = _timestampTextPainter.height;
    _timestampTextPainter.paint(
      canvas,
      Offset(
        (maxTimestampWidth - timestampWidth) / 2 + halfStrokeWidth,
        titleRect.bottom +
            (maxTimestampHeight - timestampHeight) / 2 +
            halfStrokeWidth,
      ),
    );

    final idSize = height * 0.094;
    final maxIdWidth = idRect.width;
    final maxIdHeight = idRect.height;
    _idTextPainter
      ..text = TextSpan(
        text: idText.split('').join('\n\n'),
        style: timestampStyle.copyWith(fontSize: idSize),
      )
      ..layout(maxWidth: maxIdWidth);
    final idWidth = _idTextPainter.width;
    final idHeight = _idTextPainter.height;
    _idTextPainter.paint(
      canvas,
      Offset(
        idRect.left + (maxIdWidth - idWidth) / 2,
        idRect.top + (maxIdHeight - idHeight) / 2,
      ),
    );

    final smallLabelPadding = height * 0.03;
    final smallLabelSize = height * 0.052;
    final maxSmallLabelWidth = typeRect.width;

    _typeTextPainter
      ..text = TextSpan(
        text: typeText,
        style: smallLabelStyle.copyWith(fontSize: smallLabelSize),
      )
      ..layout(maxWidth: maxSmallLabelWidth)
      ..paint(
        canvas,
        Offset(
          smallLabelPadding + halfStrokeWidth,
          typeRect.top + smallLabelPadding + halfStrokeWidth,
        ),
      );

    _systemTextPainter
      ..text = TextSpan(
        text: systemText,
        style: smallLabelStyle.copyWith(fontSize: smallLabelSize),
      )
      ..layout(maxWidth: maxSmallLabelWidth)
      ..paint(
        canvas,
        Offset(
          typeRect.right + smallLabelPadding + halfStrokeWidth,
          systemRect.top + smallLabelPadding + halfStrokeWidth,
        ),
      );

    _serialNumberTextPainter
      ..text = TextSpan(
        text: serialNumberText,
        style: smallLabelStyle.copyWith(fontSize: smallLabelSize),
      )
      ..layout(maxWidth: maxSmallLabelWidth)
      ..paint(
        canvas,
        Offset(
          systemRect.right + smallLabelPadding + halfStrokeWidth,
          serialNumberRect.top + smallLabelPadding + halfStrokeWidth,
        ),
      );
  }

  @override
  bool shouldRepaint(_StampPainter oldDelegate) {
    return titleText != oldDelegate.titleText ||
        timestampText != oldDelegate.timestampText ||
        idText != oldDelegate.idText ||
        typeText != oldDelegate.typeText ||
        systemText != oldDelegate.systemText ||
        serialNumberText != oldDelegate.serialNumberText ||
        color != oldDelegate.color ||
        titleStyle != oldDelegate.titleStyle ||
        timestampStyle != oldDelegate.timestampStyle ||
        smallLabelStyle != oldDelegate.smallLabelStyle;
  }
}
