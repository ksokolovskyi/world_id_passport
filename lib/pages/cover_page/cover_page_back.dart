import 'package:flutter/material.dart';
import 'package:world_id_passport/pages/pages.dart';

class CoverPageBack extends StatelessWidget {
  const CoverPageBack({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageClipper(
      child: ColoredBox(
        color: Color(0xFF1E1F22),
      ),
    );
  }
}
