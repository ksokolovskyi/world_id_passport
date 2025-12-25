import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:world_id_passport/pages/pages.dart';
import 'package:world_id_passport/world_id_theme.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const RepaintBoundary(
      child: PageClipper(
        child: Stack(
          children: [
            Positioned.fill(
              child: RainbowPageBackground(),
            ),
            Positioned.fill(
              child: _MainPageBody(),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainPageBody extends StatefulWidget {
  const _MainPageBody();

  @override
  State<_MainPageBody> createState() => _MainPageBodyState();
}

class _MainPageBodyState extends State<_MainPageBody> {
  _MainPageBodyPainter? _painter;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final worldIdTheme = context.worldIdTheme;

    _painter?.dispose();

    _painter = _MainPageBodyPainter(
      verificationsText: 'VERIFICATIONS',
      deviceVerificationText: 'DEVICE VERIF',
      orbVerificationText: 'ORB VERIF',
      textStyle: worldIdTheme.titleLargeTextStyle,
    );
  }

  @override
  void dispose() {
    _painter?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _painter,
      child: const Column(
        children: [
          Expanded(
            child: SizedBox.shrink(),
          ),
          Expanded(
            child: Align(
              alignment: Alignment(0.5, 0),
              child: FractionallySizedBox(
                widthFactor: 0.492,
                child: Stamp(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MainPageBodyPainter extends CustomPainter {
  _MainPageBodyPainter({
    required this.verificationsText,
    required this.orbVerificationText,
    required this.deviceVerificationText,
    required this.textStyle,
  });

  final String verificationsText;

  final String orbVerificationText;

  final String deviceVerificationText;

  final TextStyle textStyle;

  final _pageTitleTextPainter = TextPainter(
    maxLines: 1,
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );
  final _deviceVerificationTextPainter = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );
  final _orbVerificationTextPainter = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );

  void dispose() {
    _pageTitleTextPainter.dispose();
    _deviceVerificationTextPainter.dispose();
    _orbVerificationTextPainter.dispose();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Page title drawing.
    final fontSize = height * 0.0269;
    final textStyle = this.textStyle.copyWith(
      fontSize: fontSize,
      letterSpacing: fontSize * 0.013,
    );

    final topPadding = height * 0.0465;

    final maxPageTitleWidth = width;
    _pageTitleTextPainter
      ..text = TextSpan(
        text: verificationsText,
        style: textStyle,
      )
      ..layout(maxWidth: maxPageTitleWidth);
    final titleWidth = _pageTitleTextPainter.width;
    _pageTitleTextPainter.paint(
      canvas,
      Offset((maxPageTitleWidth - titleWidth) / 2, topPadding),
    );

    // Divider drawing.
    final dividerX = width * 0.158;
    final dividerY = height * 0.526;
    final dividerWidth = width * 0.785;

    canvas.drawLine(
      Offset(dividerX, dividerY),
      Offset(dividerX + dividerWidth, dividerY),
      Paint()
        ..color = const Color(0xFFD4D4D9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // Vertical section titles drawing.
    // ignore: cascade_invocations
    canvas
      ..save()
      ..rotate(-math.pi / 2)
      ..translate(-height, 0);

    final leftPadding = width * 0.131;
    final maxSectionTitleWidth = height - dividerY;

    _deviceVerificationTextPainter
      ..text = TextSpan(
        text: deviceVerificationText,
        style: textStyle,
      )
      ..layout(maxWidth: maxSectionTitleWidth);
    final deviceVerificationWidth = _deviceVerificationTextPainter.width;
    _deviceVerificationTextPainter.paint(
      canvas,
      Offset(
        (maxSectionTitleWidth - deviceVerificationWidth) / 2,
        leftPadding,
      ),
    );

    _orbVerificationTextPainter
      ..text = TextSpan(
        text: orbVerificationText,
        style: textStyle,
      )
      ..layout(maxWidth: maxSectionTitleWidth);
    final orbVerificationWidth = _orbVerificationTextPainter.width;
    _orbVerificationTextPainter.paint(
      canvas,
      Offset(
        (maxSectionTitleWidth - orbVerificationWidth) / 2 + (height - dividerY),
        leftPadding,
      ),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(_MainPageBodyPainter oldDelegate) {
    return verificationsText != oldDelegate.verificationsText ||
        orbVerificationText != oldDelegate.orbVerificationText ||
        deviceVerificationText != oldDelegate.deviceVerificationText ||
        textStyle != oldDelegate.textStyle;
  }
}
