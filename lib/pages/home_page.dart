import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../theme/accent.dart';
import '../widgets/page_shell.dart';
import '../widgets/cards.dart';

/// ---------------------------------------------------------------------
/// HOME PAGE
/// ---------------------------------------------------------------------
/// Sections top-to-bottom: hero (headline + credentials card) → dark
/// stats strip → about teaser → featured projects → skills teaser.
/// Each section is its own private widget below, in the order it renders.
/// ---------------------------------------------------------------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < AppBreakpoints.mobile;

    return PageShell(children: [
      ContentColumn(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 48,
          vertical: isMobile ? 48 : 80,
        ),
        // Desktop: headline on the left, credentials card on the right,
        // side by side. Mobile: card on top, headline below — putting the
        // photo/credentials first reads better on a narrow, tall screen.
        child: isMobile
            ? Column(children: [const _CredentialsCard(), const SizedBox(height: 32), const _HeroText()])
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Expanded(flex: 11, child: _HeroText()),
                  SizedBox(width: 40),
                  Expanded(flex: 9, child: _CredentialsCard()),
                ],
              ),
      ),
      const _StatsStrip(),
      ContentColumn(child: const _AboutTeaser()),
      ContentColumn(child: const _FeaturedProjects()),
      ContentColumn(child: const _SkillsTeaser()),
    ]);
  }
}

/// Left/top half of the hero: eyebrow label, big headline, subhead, and
/// the two call-to-action buttons.
class _HeroText extends StatelessWidget {
  const _HeroText();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < AppBreakpoints.mobile;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ENGINEERING MANAGER · BACKEND ARCHITECT',
            style: AppText.body(13, color: AppColors.teal, weight: FontWeight.w600)
                .copyWith(letterSpacing: 1.1)),
        const SizedBox(height: 18),
        // Headline shrinks on mobile (52 -> 32) so it doesn't wrap into a
        // wall of huge text on a narrow screen.
        Text(PortfolioData.heroHeadline, style: AppText.display(isMobile ? 32 : 52)),
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480), // keeps the paragraph readable
          child: Text(PortfolioData.heroSub, style: AppText.body(17, color: AppColors.slate)),
        ),
        const SizedBox(height: 32),
        // Wrap (not Row) so the two buttons drop to a second line instead
        // of overflowing if the available width gets tight.
        Wrap(spacing: 14, runSpacing: 12, children: [
          _PrimaryButton(label: 'View Resume', onTap: () => context.go('/resume')),
          _OutlineButton(label: 'Get in Touch', onTap: () => context.go('/contact')),
        ]),
      ],
    );
  }
}

/// Solid dark "View Resume"-style button.
class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.ink,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0, // flat, matches the site's overall no-shadow button style
      ),
      child: Text(label, style: AppText.body(14, color: Colors.white, weight: FontWeight.w600)),
    );
  }
}

/// Outlined "Get in Touch"-style secondary button.
class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _OutlineButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.ink,
        side: const BorderSide(color: AppColors.line, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(label, style: AppText.body(14, weight: FontWeight.w600)),
    );
  }
}

/// The white card on the hero showing a placeholder avatar, name/role, and
/// four "credential" rows (AWS cert, years of experience, etc).
class _CredentialsCard extends StatelessWidget {
  const _CredentialsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 50, offset: const Offset(0, 20))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder "VV" monogram avatar. To use a real photo instead:
          //   1. Add the image file to assets/ (e.g. assets/headshot.jpg)
          //   2. List it under `flutter: assets:` in pubspec.yaml
          //   3. Replace this whole Container with:
          //        ClipRRect(
          //          borderRadius: BorderRadius.circular(16),
          //          child: Image.asset('assets/headshot.jpg', width: 96, height: 96, fit: BoxFit.cover),
          //        )
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.violet, AppColors.coral]),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text('VV', style: AppText.display(30, color: Colors.white)),
          ),
          const SizedBox(height: 18),
          Text(PortfolioData.name, style: AppText.display(19)),
          const SizedBox(height: 2),
          Text('Engineering Manager, Rx Savings Solutions',
              style: AppText.body(13.5, color: AppColors.slate)),
          const SizedBox(height: 20),
          _credential(AppColors.teal, 'AWS Certified', 'Cloud Practitioner'),
          _credential(AppColors.coral, '12 years', 'software engineering'),
          _credential(AppColors.violet, '3+ years', 'leading engineering teams'),
          _credential(AppColors.teal, 'Hack Midwest', 'Hackathon Winner, 2022'),
        ],
      ),
    );
  }

  /// One row inside the credentials card: a colored dot + "bold, then
  /// grey" text, e.g. "AWS Certified  Cloud Practitioner".
  Widget _credential(Color dot, String bold, String rest) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(color: AppColors.paper, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
            const SizedBox(width: 12),
            // RichText lets "bold" and "rest" share one line with different
            // styles, and Flexible lets the text wrap instead of overflow
            // if the card gets narrow.
            Flexible(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: '$bold  ', style: AppText.body(13.5, weight: FontWeight.w600)),
                    TextSpan(text: rest, style: AppText.body(13.5, color: AppColors.slate)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The full-width dark strip below the hero showing quick stats in a
/// terminal-command style, e.g. "$ release_cycle — 40% faster".
class _StatsStrip extends StatelessWidget {
  const _StatsStrip();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < AppBreakpoints.mobile;
    // (label, value) tuples — Dart records again, same pattern as navItems.
    final stats = [
      ('experience', '12 years'),
      ('leadership', '3+ years'),
      ('release_cycle', '40% faster'),
      ('api_performance', '+30%'),
      ('hackathon_wins', '2022'),
    ];
    return Container(
      width: double.infinity,
      color: AppColors.ink,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 48, vertical: 26),
      // Horizontal scroll instead of wrapping, so the strip always stays
      // one line tall — on mobile the user can swipe sideways to see the
      // rest instead of the strip growing vertically.
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final s in stats)
              Padding(
                padding: const EdgeInsets.only(right: 40),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(text: '\$ ', style: AppText.mono(13, color: AppColors.teal)),
                    TextSpan(text: '${s.$1} — ', style: AppText.mono(13, color: const Color(0xFFB9BBD1))),
                    TextSpan(text: s.$2, style: AppText.mono(13, color: Colors.white, weight: FontWeight.w500)),
                  ]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// "About" section: eyebrow + headline on one side, a short paragraph and
/// a "Read the full story" link (which jumps to the Experience page) on
/// the other. Side-by-side on desktop, stacked on mobile.
class _AboutTeaser extends StatelessWidget {
  const _AboutTeaser();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < AppBreakpoints.mobile;
    final left = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('ABOUT', style: AppText.body(13, color: AppColors.violet, weight: FontWeight.w600).copyWith(letterSpacing: 1.1)),
        const SizedBox(height: 10),
        Text('From writing the code to growing the people who write it.',
            style: AppText.display(isMobile ? 24 : 32)),
      ],
    );
    final right = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Veena started as a software engineer fixing production bugs in enterprise "
          "financial systems, and now leads engineering strategy for a healthcare "
          "product team — coaching engineers who'd been stuck for years into "
          "promotions, while modernizing the architecture underneath them.",
          style: AppText.body(15, color: AppColors.slate),
        ),
        const SizedBox(height: 14),
        GestureDetector(
          onTap: () => context.go('/experience'),
          child: Text('Read the full story →', style: AppText.mono(13, color: AppColors.ink)),
        ),
      ],
    );

    if (isMobile) {
      return Column(children: [left, const SizedBox(height: 20), right]);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Expanded(child: left), const SizedBox(width: 48), Expanded(child: right)],
    );
  }
}

/// Shows the first 4 projects from PortfolioData.projects as a teaser grid,
/// with a "View all projects" link to the full Projects page.
class _FeaturedProjects extends StatelessWidget {
  const _FeaturedProjects();

  @override
  Widget build(BuildContext context) {
    // .take(4) — just the first four entries in portfolio_data.dart's
    // `projects` list. Reorder that list if you want different projects
    // featured on the homepage.
    final featured = PortfolioData.projects.take(4).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('FEATURED WORK', style: AppText.body(13, color: AppColors.violet, weight: FontWeight.w600).copyWith(letterSpacing: 1.1)),
        const SizedBox(height: 10),
        Text('Projects that moved the needle', style: AppText.display(32)),
        const SizedBox(height: 8),
        Text('A selection of architectural and platform work from Rx Savings Solutions.',
            style: AppText.body(15, color: AppColors.slate)),
        const SizedBox(height: 28),
        // 2 columns on both desktop and tablet here (unlike the full
        // Projects page, which goes up to 3) since this is just a teaser.
        ResponsiveGrid(
          columnsWide: 2,
          columnsMedium: 2,
          columnsNarrow: 1,
          children: [for (final p in featured) _ProjectCard(project: p)],
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () => context.go('/projects'),
          child: Text('View all projects →', style: AppText.mono(13, color: AppColors.ink)),
        ),
      ],
    );
  }
}

/// A single project teaser card. `project` is typed dynamic here (rather
/// than ProjectEntry) purely to keep this file's imports minimal — it's
/// always actually a ProjectEntry at runtime.
class _ProjectCard extends StatelessWidget {
  final dynamic project;
  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return AccentCard(
      accent: accentColor(project.accent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(project.category.toUpperCase(),
              style: AppText.mono(11, color: AppColors.slate).copyWith(letterSpacing: 1)),
          const SizedBox(height: 10),
          Text(project.title, style: AppText.display(18)),
          const SizedBox(height: 8),
          Text(project.description, style: AppText.body(14, color: AppColors.slate)),
          const SizedBox(height: 14),
          ImpactBadge(project.impact),
        ],
      ),
    );
  }
}

/// Flattens every skill group's chips into one big cloud (unlike the
/// Skills page, which keeps them grouped in cards) — this is meant to be
/// a quick "wall of tech" impression, not a detailed breakdown.
class _SkillsTeaser extends StatelessWidget {
  const _SkillsTeaser();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('TOOLBOX', style: AppText.body(13, color: AppColors.violet, weight: FontWeight.w600).copyWith(letterSpacing: 1.1)),
        const SizedBox(height: 10),
        Text('Skills & technologies', style: AppText.display(32)),
        const SizedBox(height: 24),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            // Nested for-loops inside a collection literal: outer loop over
            // each group (Languages, Cloud, ...), inner loop over that
            // group's items — this is what flattens the grouped data into
            // one flat list of chips.
            for (final group in PortfolioData.skills)
              for (final item in group.items)
                MonoChip(item, borderColor: accentColor(group.accent).withOpacity(0.5), textColor: accentColor(group.accent)),
          ],
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () => context.go('/skills'),
          child: Text('See full skill breakdown →', style: AppText.mono(13, color: AppColors.ink)),
        ),
      ],
    );
  }
}
