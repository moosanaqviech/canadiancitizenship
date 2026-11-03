import 'package:flutter/material.dart';

import '../theme/tokens.dart';

enum ButtonVariant { primary, secondary, quiet, dark }

/// 56 pt button, radius 16.
///
/// Primary = maple filled · secondary = lake outline · quiet = mist filled ·
/// dark = forest filled.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (bg, fg, side) = switch (variant) {
      ButtonVariant.primary => (c.maple, Colors.white, BorderSide.none),
      ButtonVariant.secondary => (Colors.transparent, c.lake, BorderSide(color: c.lake, width: 2.5)),
      ButtonVariant.quiet => (c.mist, c.forest, BorderSide.none),
      ButtonVariant.dark => (c.forest, Colors.white, BorderSide.none),
    };
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: Metrics.buttonHeight),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          disabledBackgroundColor: c.mist,
          disabledForegroundColor: c.inkSecondary,
          minimumSize: const Size(Metrics.tapTarget, Metrics.buttonHeight),
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Metrics.buttonRadius),
            side: side,
          ),
          textStyle: context.text.labelLarge,
        ),
        child: Text(label, textAlign: TextAlign.center),
      ),
    );
  }
}

/// Square mist button used for back / close / settings.
class SquareIconButton extends StatelessWidget {
  const SquareIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        excludeSemantics: true,
        child: Material(
          color: c.mist,
          borderRadius: BorderRadius.circular(Metrics.buttonRadius),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(Metrics.buttonRadius),
            child: SizedBox.square(
              dimension: 56,
              child: Icon(icon, color: c.forest, size: 26),
            ),
          ),
        ),
      ),
    );
  }
}

/// Raised card on birch, radius 22.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsetsDirectional.all(22),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(Metrics.cardRadius),
        border: Border.all(color: c.border.withValues(alpha: 0.7)),
      ),
      child: child,
    );
  }
}

/// Thin rounded progress track: lake on mist.
class ProgressTrack extends StatelessWidget {
  const ProgressTrack({
    super.key,
    required this.value,
    this.height = 8,
    this.color,
    this.background,
  });

  final double value;
  final double height;
  final Color? color;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: LinearProgressIndicator(
        value: value.clamp(0, 1),
        minHeight: height,
        color: color ?? c.lake,
        backgroundColor: background ?? c.mist,
      ),
    );
  }
}

/// Segmented progress (one segment per lesson card).
class SegmentedProgress extends StatelessWidget {
  const SegmentedProgress({super.key, required this.done, required this.total});

  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      children: [
        for (var i = 0; i < total; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          Expanded(
            child: Container(
              height: 7,
              decoration: BoxDecoration(
                color: i < done ? c.lake : c.mist,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Header row used by full-screen flows: square button + caption + progress.
class FlowHeader extends StatelessWidget {
  const FlowHeader({
    super.key,
    required this.leading,
    required this.caption,
    required this.progress,
  });

  final Widget leading;
  final String caption;
  final Widget progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        leading,
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                caption,
                style: context.text.bodyMedium!.copyWith(color: context.colors.inkSecondary, fontSize: 16),
              ),
              const SizedBox(height: 8),
              progress,
            ],
          ),
        ),
      ],
    );
  }
}

/// Uppercase eyebrow label in lake.
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: context.text.labelSmall!.copyWith(color: color),
      semanticsLabel: text,
    );
  }
}
