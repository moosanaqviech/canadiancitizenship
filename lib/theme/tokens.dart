import 'package:flutter/material.dart';

/// Brand colour tokens from BUILD-NOTES.md.
///
/// Forest marks a correct answer; amber is reserved for incorrect answers.
/// Maple is for primary actions and celebration (the leaf, passed, ready),
/// never for judging an answer, since most people read red as "wrong".
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.forest,
    required this.lake,
    required this.birch,
    required this.card,
    required this.mist,
    required this.ink,
    required this.inkSecondary,
    required this.maple,
    required this.mapleText,
    required this.mapleTint,
    required this.forestTint,
    required this.lakeTint,
    required this.amberFill,
    required this.amberBorder,
    required this.amberText,
    required this.border,
    required this.outline,
  });

  final Color forest;
  final Color lake;
  final Color birch;
  final Color card;
  final Color mist;
  final Color ink;
  final Color inkSecondary;
  final Color maple;

  /// Maple used as text on birch/card (#A3221F) for contrast.
  final Color mapleText;

  /// Pale maple fill (current chapter marker).
  final Color mapleTint;

  /// Pale forest fill behind a correct answer.
  final Color forestTint;

  /// Pale lake fill behind a selected (unjudged) answer.
  final Color lakeTint;
  final Color amberFill;
  final Color amberBorder;
  final Color amberText;

  /// Card and answer-row borders.
  final Color border;

  /// Unselected radio rings and not-started chapter rings.
  final Color outline;

  static const standard = AppColors(
    forest: Color(0xFF1F4D3A),
    lake: Color(0xFF2E6A8E),
    birch: Color(0xFFF7F4EC),
    card: Color(0xFFFFFDF8),
    mist: Color(0xFFE3EBE8),
    ink: Color(0xFF1B2621),
    inkSecondary: Color(0xFF45554E),
    maple: Color(0xFFC62E2B),
    mapleText: Color(0xFFA3221F),
    mapleTint: Color(0xFFFBEBEA),
    forestTint: Color(0xFFE4F0E9),
    lakeTint: Color(0xFFEAF1F6),
    amberFill: Color(0xFFF6E9CF),
    amberBorder: Color(0xFFB07A22),
    amberText: Color(0xFF7A4B0E),
    border: Color(0xFFD5DDD9),
    outline: Color(0xFF9BB0A7),
  );

  /// "Higher contrast" setting: darker text and borders.
  static final highContrast = standard.copyWith(
    inkSecondary: const Color(0xFF26332D),
    border: const Color(0xFF6E827A),
    outline: const Color(0xFF52665E),
    lake: const Color(0xFF245878),
  );

  @override
  AppColors copyWith({
    Color? forest,
    Color? lake,
    Color? birch,
    Color? card,
    Color? mist,
    Color? ink,
    Color? inkSecondary,
    Color? maple,
    Color? mapleText,
    Color? mapleTint,
    Color? forestTint,
    Color? lakeTint,
    Color? amberFill,
    Color? amberBorder,
    Color? amberText,
    Color? border,
    Color? outline,
  }) {
    return AppColors(
      forest: forest ?? this.forest,
      lake: lake ?? this.lake,
      birch: birch ?? this.birch,
      card: card ?? this.card,
      mist: mist ?? this.mist,
      ink: ink ?? this.ink,
      inkSecondary: inkSecondary ?? this.inkSecondary,
      maple: maple ?? this.maple,
      mapleText: mapleText ?? this.mapleText,
      mapleTint: mapleTint ?? this.mapleTint,
      forestTint: forestTint ?? this.forestTint,
      lakeTint: lakeTint ?? this.lakeTint,
      amberFill: amberFill ?? this.amberFill,
      amberBorder: amberBorder ?? this.amberBorder,
      amberText: amberText ?? this.amberText,
      border: border ?? this.border,
      outline: outline ?? this.outline,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      forest: l(forest, other.forest),
      lake: l(lake, other.lake),
      birch: l(birch, other.birch),
      card: l(card, other.card),
      mist: l(mist, other.mist),
      ink: l(ink, other.ink),
      inkSecondary: l(inkSecondary, other.inkSecondary),
      maple: l(maple, other.maple),
      mapleText: l(mapleText, other.mapleText),
      mapleTint: l(mapleTint, other.mapleTint),
      forestTint: l(forestTint, other.forestTint),
      lakeTint: l(lakeTint, other.lakeTint),
      amberFill: l(amberFill, other.amberFill),
      amberBorder: l(amberBorder, other.amberBorder),
      amberText: l(amberText, other.amberText),
      border: l(border, other.border),
      outline: l(outline, other.outline),
    );
  }
}

/// Component metrics.
abstract final class Metrics {
  static const gutter = 20.0;
  static const buttonHeight = 56.0;
  static const buttonRadius = 16.0;
  static const answerMinHeight = 60.0;
  static const answerRadius = 16.0;
  static const cardRadius = 22.0;
  static const tapTarget = 44.0;
  static const iconButton = 48.0;
}

extension AppThemeContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
  TextTheme get text => Theme.of(this).textTheme;
}
