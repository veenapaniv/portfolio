import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// ---------------------------------------------------------------------
/// SHARED CARD/CHIP COMPONENTS
/// ---------------------------------------------------------------------
/// Small, reusable pieces used across Experience/Projects/Skills so those
/// pages don't each reinvent "a white card with a colored border" or
/// "a small pill-shaped label".
/// ---------------------------------------------------------------------

/// White rounded card with a single colored accent border — either along
/// the top (used for project cards) or the left side (used for skill
/// cards). Two Container-level decorations are used here on purpose:
/// `decoration` draws the base card (white fill, all-around hairline
/// border, rounded corners), and `foregroundDecoration` draws the accent
/// border ON TOP of that — a plain single BoxDecoration can't have a
/// different color/width per side easily while also rendering above the
/// base fill, so layering two Containers' worth of decoration is the
/// simplest way to get "3 thin grey sides + 1 thick colored side".
class AccentCard extends StatelessWidget {
  final Widget child;
  final Color accent;
  final Axis borderSide; // Axis.horizontal = accent on top, .vertical = accent on left
  final EdgeInsets padding;
  const AccentCard({
    super.key,
    required this.child,
    required this.accent,
    this.borderSide = Axis.horizontal,
    this.padding = const EdgeInsets.all(26),
  });

  @override
  Widget build(BuildContext context) {
    final isTop = borderSide == Axis.horizontal;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border(
          top: isTop ? BorderSide(color: accent, width: 4) : BorderSide.none,
          left: !isTop ? BorderSide(color: accent, width: 4) : BorderSide.none,
        ),
      ),
      padding: padding,
      child: child,
    );
  }
}

/// A small pill-shaped label in monospace — used for tech-stack tags,
/// skill chips, and stat labels. All styling is optional so the same
/// widget can render as a plain grey chip or an accent-colored outlined
/// one, depending on what's passed in.
class MonoChip extends StatelessWidget {
  final String label;
  final Color? borderColor;
  final Color? textColor;
  final Color? background;
  const MonoChip(this.label, {super.key, this.borderColor, this.textColor, this.background});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background ?? AppColors.paper,
        borderRadius: BorderRadius.circular(6),
        border: borderColor != null ? Border.all(color: borderColor!) : null,
      ),
      child: Text(label, style: AppText.mono(11.5, color: textColor ?? AppColors.ink)),
    );
  }
}

/// The small dark "impact" badge on project cards (e.g. "40% faster
/// release cycles") — always ink-colored/white-text regardless of the
/// card's accent, so it reads as the headline result at a glance.
class ImpactBadge extends StatelessWidget {
  final String label;
  const ImpactBadge(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: AppText.mono(12, color: Colors.white, weight: FontWeight.w500)),
    );
  }
}

/// A responsive card grid without using Flutter's GridView.
///
/// Why not GridView? GridView needs a fixed number of columns decided in
/// advance; what we actually want is "3 columns on desktop, 2 on tablet,
/// 1 on mobile" purely based on how much width is available *right now*.
/// LayoutBuilder gives us that available width, and Wrap + a computed
/// per-item width gets us equal-width, wrapping "columns" without any
/// manual row-splitting logic.
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int columnsWide;   // column count when width >= 980
  final int columnsMedium; // column count when 700 <= width < 980
  final int columnsNarrow; // column count when width < 700
  final double spacing;
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.columnsWide = 3,
    this.columnsMedium = 2,
    this.columnsNarrow = 1,
    this.spacing = 22,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      final cols = w < 700 ? columnsNarrow : (w < 980 ? columnsMedium : columnsWide);
      // Subtract the gaps between columns, then divide the remaining width
      // evenly — this is what makes every card end up the same width no
      // matter how many columns are currently active.
      final itemWidth = (w - spacing * (cols - 1)) / cols;
      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: [
          for (final c in children) SizedBox(width: itemWidth, child: c),
        ],
      );
    });
  }
}
