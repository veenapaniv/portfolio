import 'package:flutter/material.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../theme/accent.dart';
import '../widgets/page_shell.dart';
import '../widgets/cards.dart';

/// ---------------------------------------------------------------------
/// SKILLS PAGE
/// ---------------------------------------------------------------------
/// A grid of categorized skill cards (Languages, Cloud, Frameworks, ...)
/// followed by a dark "Beyond the stack" strip calling out leadership /
/// soft skills separately, since those don't fit naturally as tech chips.
/// ---------------------------------------------------------------------
class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageShell(children: [
      ContentColumn(
        child: const PageHeader(
          eyebrow: 'Toolbox',
          title: 'Skills & technologies',
          subtitle: 'The technical foundation behind twelve years of backend systems, '
              'cloud architecture, and mobile delivery.',
        ),
      ),
      ContentColumn(
        padding: const EdgeInsets.symmetric(horizontal: 48).copyWith(top: 0, bottom: 20),
        child: ResponsiveGrid(
          children: [for (final group in PortfolioData.skills) _SkillCard(group: group)],
        ),
      ),
      ContentColumn(
        padding: const EdgeInsets.symmetric(horizontal: 48).copyWith(top: 8, bottom: 80),
        child: const _LeadershipStrip(),
      ),
    ]);
  }
}

/// One category card, e.g. "Cloud (AWS)" with its chip list. Accent color
/// per group comes straight from portfolio_data.dart's SkillGroup.accent.
class _SkillCard extends StatelessWidget {
  final SkillGroup group;
  const _SkillCard({required this.group});

  @override
  Widget build(BuildContext context) {
    return AccentCard(
      accent: accentColor(group.accent),
      borderSide: Axis.vertical, // accent stripe on the left edge (vs. top on project cards)
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(group.label, style: AppText.display(18)),
          const SizedBox(height: 16),
          Wrap(spacing: 8, runSpacing: 8, children: [for (final item in group.items) MonoChip(item)]),
        ],
      ),
    );
  }
}

/// The dark rounded panel at the bottom of the Skills page: intro text on
/// one side, a stack of highlighted "soft skill" rows on the other.
/// Side-by-side on desktop, stacked on mobile (same responsive pattern
/// used in _AboutTeaser on the Home page).
class _LeadershipStrip extends StatelessWidget {
  const _LeadershipStrip();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < AppBreakpoints.mobile;
    // Colors cycle through the three accents for each highlight row's dot.
    final colors = [AppColors.teal, AppColors.coral, AppColors.violet, AppColors.teal];

    final textBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Beyond the stack', style: AppText.display(22, color: Colors.white)),
        const SizedBox(height: 10),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Text(
            "Three-plus years leading cross-functional engineering teams — the skills "
            "that don't fit in a tech chip cloud, but matter just as much.",
            style: AppText.body(14.5, color: const Color(0xFFB9BBD1)),
          ),
        ),
      ],
    );

    final badges = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // `i % colors.length` cycles the color list even though there are
        // 4 highlights and only 3 colors — this is what makes the last
        // one wrap back around to teal instead of erroring on an
        // out-of-range index.
        for (var i = 0; i < PortfolioData.leadershipHighlights.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.06), borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Container(width: 7, height: 7, decoration: BoxDecoration(color: colors[i % colors.length], shape: BoxShape.circle)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(PortfolioData.leadershipHighlights[i],
                        style: AppText.body(13.5, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
      ],
    );

    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 36),
      decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(16)),
      child: isMobile
          ? Column(children: [textBlock, const SizedBox(height: 20), badges])
          : Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(flex: 6, child: textBlock),
              const SizedBox(width: 32),
              Expanded(flex: 5, child: badges),
            ]),
    );
  }
}
