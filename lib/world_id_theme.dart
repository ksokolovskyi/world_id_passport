import 'package:flutter/material.dart';

extension WorldIdThemeExtension on BuildContext {
  WorldIdTheme get worldIdTheme => Theme.of(this).extension<WorldIdTheme>()!;
}

class WorldIdTheme extends ThemeExtension<WorldIdTheme> {
  const WorldIdTheme({
    required this.goldColor,
    required this.darkTextColor,
    required this.labelLargeTextStyle,
    required this.labelSmallTextStyle,
    required this.titleLargeTextStyle,
    required this.titleMediumTextStyle,
    required this.headlineLargeTextStyle,
    required this.headlineMediumTextStyle,
  });

  factory WorldIdTheme.regular() {
    const goldColor = Color(0xFFCBBE93);
    const darkTextColor = Color(0xFF222427);

    return const WorldIdTheme(
      goldColor: goldColor,
      darkTextColor: darkTextColor,
      labelLargeTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        height: 1,
        color: darkTextColor,
      ),
      labelSmallTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        color: darkTextColor,
      ),
      titleLargeTextStyle: TextStyle(
        fontFamily: 'SFMono',
        fontWeight: FontWeight.w400,
        height: 1.1,
        color: darkTextColor,
      ),
      titleMediumTextStyle: TextStyle(
        fontFamily: 'SFMono',
        fontWeight: FontWeight.w500,
        height: 1,
        color: darkTextColor,
      ),
      headlineLargeTextStyle: TextStyle(
        fontFamily: 'SpaceMono',
        fontWeight: FontWeight.w400,
        height: 1,
        color: goldColor,
      ),
      headlineMediumTextStyle: TextStyle(
        fontFamily: 'SFMono',
        fontWeight: FontWeight.w500,
        height: 1.7,
        color: goldColor,
      ),
    );
  }

  final Color goldColor;

  final Color darkTextColor;

  final TextStyle labelLargeTextStyle;

  final TextStyle labelSmallTextStyle;

  final TextStyle titleLargeTextStyle;

  final TextStyle titleMediumTextStyle;

  final TextStyle headlineLargeTextStyle;

  final TextStyle headlineMediumTextStyle;

  @override
  ThemeExtension<WorldIdTheme> copyWith({
    Color? goldColor,
    Color? darkTextColor,
    TextStyle? labelLargeTextStyle,
    TextStyle? labelSmallTextStyle,
    TextStyle? titleLargeTextStyle,
    TextStyle? titleMediumTextStyle,
    TextStyle? headlineLargeTextStyle,
    TextStyle? headlineMediumTextStyle,
  }) {
    return WorldIdTheme(
      goldColor: goldColor ?? this.goldColor,
      darkTextColor: darkTextColor ?? this.darkTextColor,
      labelLargeTextStyle: labelLargeTextStyle ?? this.labelLargeTextStyle,
      labelSmallTextStyle: labelSmallTextStyle ?? this.labelSmallTextStyle,
      titleLargeTextStyle: titleLargeTextStyle ?? this.titleLargeTextStyle,
      titleMediumTextStyle: titleMediumTextStyle ?? this.titleMediumTextStyle,
      headlineLargeTextStyle:
          headlineLargeTextStyle ?? this.headlineLargeTextStyle,
      headlineMediumTextStyle:
          headlineMediumTextStyle ?? this.headlineMediumTextStyle,
    );
  }

  @override
  ThemeExtension<WorldIdTheme> lerp(
    WorldIdTheme? other,
    double t,
  ) {
    if (other == null) {
      return this;
    }

    return WorldIdTheme(
      goldColor: Color.lerp(goldColor, other.goldColor, t)!,
      darkTextColor: Color.lerp(darkTextColor, other.darkTextColor, t)!,
      labelLargeTextStyle: TextStyle.lerp(
        labelLargeTextStyle,
        other.labelLargeTextStyle,
        t,
      )!,
      labelSmallTextStyle: TextStyle.lerp(
        labelSmallTextStyle,
        other.labelSmallTextStyle,
        t,
      )!,
      titleLargeTextStyle: TextStyle.lerp(
        titleLargeTextStyle,
        other.titleLargeTextStyle,
        t,
      )!,
      titleMediumTextStyle: TextStyle.lerp(
        titleMediumTextStyle,
        other.titleMediumTextStyle,
        t,
      )!,
      headlineLargeTextStyle: TextStyle.lerp(
        headlineLargeTextStyle,
        other.headlineLargeTextStyle,
        t,
      )!,
      headlineMediumTextStyle: TextStyle.lerp(
        headlineMediumTextStyle,
        other.headlineMediumTextStyle,
        t,
      )!,
    );
  }
}
