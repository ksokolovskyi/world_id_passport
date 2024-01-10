import 'package:flutter/material.dart';
import 'package:world_id_passport/assets.dart';
import 'package:world_id_passport/pages/pages.dart';
import 'package:world_id_passport/world_id_theme.dart';

class CoverPage extends StatelessWidget {
  const CoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: PageClipper(
        child: Stack(
          children: [
            const Positioned.fill(
              child: _CoverPageBackground(),
            ),
            Align(
              alignment: const Alignment(0, -0.15),
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: RepaintBoundary(
                          child: Builder(
                            builder: (context) {
                              return Image.asset(
                                Assets.globe,
                                color: context.worldIdTheme.goldColor,
                                colorBlendMode: BlendMode.srcIn,
                                filterQuality: FilterQuality.medium,
                              );
                            },
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment(0, 0.15),
                        child: FractionallySizedBox(
                          widthFactor: 0.46,
                          child: GemHolder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Positioned.fill(
              child: _CoverPageBody(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoverPageBackground extends StatelessWidget {
  const _CoverPageBackground();

  @override
  Widget build(BuildContext context) {
    return const RepaintBoundary(
      child: AssetImageMask(
        assetKey: Assets.textureMask,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1E1F22),
                Color(0xFF2C2D30),
                Color(0xFF414245),
                Color(0xFF202124),
                Color(0xFF1E1F22),
                Color(0xFF1E1F22),
              ],
              stops: [0.0072, 0.0133, 0.0229, 0.0377, 0.0609, 0.99],
            ),
          ),
        ),
      ),
    );
  }
}

class _CoverPageBody extends StatefulWidget {
  const _CoverPageBody();

  @override
  State<_CoverPageBody> createState() => _CoverPageBodyState();
}

class _CoverPageBodyState extends State<_CoverPageBody> {
  _CoverPageBodyPainter? _painter;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final worldIdTheme = context.worldIdTheme;

    _painter?.dispose();

    _painter = _CoverPageBodyPainter(
      titleText: 'WORLD ID',
      subtitleText: 'UNIVERSAL\nPROOF OF PERSONHOOD',
      titleTextStyle: worldIdTheme.headlineLargeTextStyle,
      subtitleTextStyle: worldIdTheme.headlineMediumTextStyle,
      goldColor: worldIdTheme.goldColor,
    );
  }

  @override
  void dispose() {
    _painter?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _painter);
  }
}

class _CoverPageBodyPainter extends CustomPainter {
  _CoverPageBodyPainter({
    required this.titleText,
    required this.subtitleText,
    required this.titleTextStyle,
    required this.subtitleTextStyle,
    required this.goldColor,
  });

  final String titleText;

  final String subtitleText;

  final TextStyle titleTextStyle;

  final TextStyle subtitleTextStyle;

  final Color goldColor;

  final _titleTextPainter = TextPainter(
    maxLines: 1,
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );
  final _subtitleTextPainter = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );

  void dispose() {
    _titleTextPainter.dispose();
    _subtitleTextPainter.dispose();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Page title drawing.
    final topPadding = height * 0.13;
    final titleSize = height * 0.0653;
    final maxTitleWidth = width;
    _titleTextPainter
      ..text = TextSpan(
        text: titleText,
        style: titleTextStyle.copyWith(
          fontSize: titleSize,
          letterSpacing: titleSize * 0.09,
        ),
      )
      ..layout(maxWidth: maxTitleWidth);
    final titleWidth = _titleTextPainter.width;
    _titleTextPainter.paint(
      canvas,
      Offset((maxTitleWidth - titleWidth) / 2, topPadding),
    );

    // Symbol drawing.
    final bottomPadding = width * 0.107;

    final symbolPaint = Paint()
      ..color = goldColor
      ..style = PaintingStyle.fill;
    final symbolWidth = width * 0.0841;
    final symbolHeight = height * 0.0403;
    final symbolHalfHeight = symbolHeight * 0.4761;
    final symbolGap = symbolHeight - symbolHalfHeight * 2;
    final symbolCircleWidth = symbolWidth / 3;
    final symbolRect = Rect.fromLTWH(
      (width - symbolWidth) / 2,
      height - symbolHeight - bottomPadding,
      symbolWidth,
      symbolHeight,
    );

    final path = Path()
      ..moveTo(symbolRect.left, symbolRect.top)
      ..lineTo(symbolRect.right, symbolRect.top)
      ..lineTo(symbolRect.right, symbolRect.top + symbolHalfHeight)
      ..lineTo(
        symbolRect.right - symbolCircleWidth + symbolGap / 2,
        symbolRect.top + symbolHalfHeight,
      )
      ..arcToPoint(
        Offset(
          symbolRect.left + symbolCircleWidth - symbolGap / 2,
          symbolRect.top + symbolHalfHeight,
        ),
        radius: Radius.circular(symbolCircleWidth / 1.9),
        rotation: 180,
        clockwise: false,
      )
      ..lineTo(symbolRect.left, symbolRect.top + symbolHalfHeight)
      ..close()
      ..moveTo(symbolRect.left, symbolRect.bottom - symbolHalfHeight)
      ..lineTo(symbolRect.left, symbolRect.bottom)
      ..lineTo(symbolRect.right, symbolRect.bottom)
      ..lineTo(symbolRect.right, symbolRect.bottom - symbolHalfHeight)
      ..lineTo(
        symbolRect.right - symbolCircleWidth + symbolGap / 2,
        symbolRect.bottom - symbolHalfHeight,
      )
      ..arcToPoint(
        Offset(
          symbolRect.left + symbolCircleWidth - symbolGap / 2,
          symbolRect.bottom - symbolHalfHeight,
        ),
        radius: Radius.circular(symbolCircleWidth / 1.9),
        rotation: 180,
      )
      ..lineTo(symbolRect.left, symbolRect.bottom - symbolHalfHeight)
      ..close();

    canvas
      ..drawPath(path, symbolPaint)
      ..drawCircle(
        symbolRect.center,
        (symbolCircleWidth - symbolGap) / 2,
        symbolPaint,
      );

    // Page subtitle drawing.
    final symbolSpacing = height * 0.0571;
    final subtitleSize = height * 0.0269;
    final maxSubtitleWidth = width;
    _subtitleTextPainter
      ..text = TextSpan(
        text: subtitleText,
        style: subtitleTextStyle.copyWith(
          fontSize: subtitleSize,
          letterSpacing: subtitleSize * 0.013,
        ),
      )
      ..layout(maxWidth: maxSubtitleWidth);
    final subtitleWidth = _subtitleTextPainter.width;
    final subtitleHeight = _subtitleTextPainter.height;
    _subtitleTextPainter.paint(
      canvas,
      Offset(
        (maxSubtitleWidth - subtitleWidth) / 2,
        symbolRect.top - subtitleHeight - symbolSpacing,
      ),
    );
  }

  @override
  bool shouldRepaint(_CoverPageBodyPainter oldDelegate) {
    return titleText != oldDelegate.titleText ||
        subtitleText != oldDelegate.subtitleText ||
        titleTextStyle != oldDelegate.titleTextStyle ||
        subtitleTextStyle != oldDelegate.subtitleTextStyle ||
        goldColor != oldDelegate.goldColor;
  }
}
