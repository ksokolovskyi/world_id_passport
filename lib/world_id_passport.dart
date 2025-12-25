import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:world_id_passport/pages/pages.dart';

class WorldIdPassport extends StatefulWidget {
  const WorldIdPassport({super.key});

  @override
  State<WorldIdPassport> createState() => _WorldIdPassportState();
}

class _WorldIdPassportState extends State<WorldIdPassport>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  late final _curvedAnimation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
    reverseCurve: Curves.easeOut,
  );

  late final Animation<double> _coverPageAnimation =
      Tween<double>(begin: 0, end: 1).animate(
        CurveTween(curve: const Interval(0, 0.9)).animate(_curvedAnimation),
      );

  late final Animation<double> _middlePageAnimation =
      Tween<double>(begin: 0, end: 1).animate(
        CurveTween(curve: const Interval(0.15, 1)).animate(_curvedAnimation),
      );

  bool get _isClosed => _controller.status == AnimationStatus.dismissed;

  @override
  void dispose() {
    _controller.dispose();
    _curvedAnimation.dispose();
    super.dispose();
  }

  Matrix4 _getPageTransformation(double value) {
    return Matrix4.identity()
      ..setEntry(3, 2, 0.00035)
      ..rotateY(value * math.pi);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_controller.status == AnimationStatus.completed ||
            _controller.status == AnimationStatus.forward) {
          _controller.reverse();
        } else {
          _controller.forward();
        }
      },
      child: RepaintBoundary(
        child: AspectRatio(
          aspectRatio: 392 / 520,
          child: Stack(
            children: [
              Positioned.fill(
                key: const Key('mainPage'),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Offstage(
                      offstage: _isClosed,
                      child: child,
                    );
                  },
                  child: const MainPage(),
                ),
              ),
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _middlePageAnimation,
                  builder: (context, child) {
                    final cover = Positioned.fill(
                      key: const Key('cover'),
                      child: child!,
                    );

                    final middlePage = Positioned.fill(
                      key: const Key('middlePage'),
                      child: Offstage(
                        offstage: _isClosed,
                        child: MatrixTransition(
                          alignment: Alignment.centerLeft,
                          animation: _middlePageAnimation,
                          onTransform: _getPageTransformation,
                          child: const MiddlePage(),
                        ),
                      ),
                    );

                    return Stack(
                      children: _middlePageAnimation.value < 0.5
                          ? [middlePage, cover]
                          : [cover, middlePage],
                    );
                  },
                  child: AnimatedBuilder(
                    animation: _coverPageAnimation,
                    builder: (context, _) {
                      final coverPage = Positioned.fill(
                        key: const Key('coverPage'),
                        child: Offstage(
                          offstage: _coverPageAnimation.value >= 0.5,
                          child: MatrixTransition(
                            alignment: Alignment.centerLeft,
                            animation: _coverPageAnimation,
                            onTransform: _getPageTransformation,
                            child: const CoverPage(),
                          ),
                        ),
                      );

                      final coverPageBack = Positioned.fill(
                        key: const Key('coverPageBack'),
                        child: MatrixTransition(
                          alignment: Alignment.centerLeft,
                          animation: _coverPageAnimation,
                          onTransform: _getPageTransformation,
                          child: const CoverPageBack(),
                        ),
                      );

                      return Stack(
                        children: [
                          coverPageBack,
                          coverPage,
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
