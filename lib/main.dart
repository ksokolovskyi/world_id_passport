import 'package:flutter/material.dart';
import 'package:world_id_passport/world_id_passport.dart';
import 'package:world_id_passport/world_id_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        extensions: [WorldIdTheme.regular()],
      ),
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: const WorldIdPassport(),
            ),
          ),
        ),
      ),
    );
  }
}
