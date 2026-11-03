import 'package:flutter/material.dart';

import 'tokens.dart';

/// Figtree for headings, Noto Sans for body (covers French accents and
/// future translated scripts). Both are bundled in assets/fonts.
///
/// Scale: display 28–34, title 26, heading 21, body 17 (minimum),
/// support 15, label 14.
ThemeData buildTheme({required bool highContrast}) {
  final c = highContrast ? AppColors.highContrast : AppColors.standard;

  TextStyle heading(double size, FontWeight weight, {double height = 1.2, double? letterSpacing, Color? color}) =>
      TextStyle(
          fontFamily: 'Figtree',
          fontSize: size,
          fontWeight: weight,
          height: height,
          letterSpacing: letterSpacing,
          color: color ?? c.ink);
  TextStyle body(double size, FontWeight weight, {double height = 1.45}) =>
      TextStyle(fontFamily: 'NotoSans', fontSize: size, fontWeight: weight, height: height, color: c.ink);

  final textTheme = TextTheme(
    displayLarge: heading(34, FontWeight.w800, height: 1.15),
    displayMedium: heading(30, FontWeight.w800, height: 1.15),
    headlineLarge: heading(26, FontWeight.w800),
    headlineMedium: heading(24, FontWeight.w800, height: 1.3),
    titleLarge: heading(21, FontWeight.w700),
    titleMedium: body(19, FontWeight.w600, height: 1.3),
    bodyLarge: body(17, FontWeight.w400),
    bodyMedium: body(15, FontWeight.w400, height: 1.4),
    labelLarge: heading(19, FontWeight.w700),
    labelMedium: heading(14, FontWeight.w700),
    labelSmall: heading(14, FontWeight.w700, letterSpacing: 1.2, color: c.lake),
  );

  return ThemeData(
    useMaterial3: true,
    fontFamily: 'NotoSans',
    scaffoldBackgroundColor: c.birch,
    colorScheme: ColorScheme.light(
      primary: c.maple,
      onPrimary: Colors.white,
      secondary: c.lake,
      onSecondary: Colors.white,
      surface: c.card,
      onSurface: c.ink,
      error: c.amberBorder,
    ),
    textTheme: textTheme,
    extensions: [c],
    splashFactory: InkSparkle.splashFactory,
    sliderTheme: SliderThemeData(
      activeTrackColor: c.lake,
      inactiveTrackColor: c.mist,
      thumbColor: c.lake,
      trackHeight: 8,
      overlayColor: c.lake.withValues(alpha: 0.12),
      inactiveTickMarkColor: c.outline,
      activeTickMarkColor: Colors.white70,
    ),
    checkboxTheme: CheckboxThemeData(
      side: BorderSide(color: c.outline, width: 1.5),
      fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.forest : c.card),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
  );
}
