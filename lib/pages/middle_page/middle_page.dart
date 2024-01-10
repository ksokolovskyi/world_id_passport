import 'package:flutter/material.dart';
import 'package:world_id_passport/pages/pages.dart';

class MiddlePage extends StatelessWidget {
  const MiddlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const RepaintBoundary(
      child: PageClipper(
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            Color(0x11000000),
            BlendMode.srcOver,
          ),
          child: RainbowPageBackground(),
        ),
      ),
    );
  }
}
