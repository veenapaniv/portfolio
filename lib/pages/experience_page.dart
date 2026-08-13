import 'package:flutter/material.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../theme/accent.dart';
import '../widgets/page_shell.dart';
import '../widgets/cards.dart';

/// ---------------------------------------------------------------------
/// EXPERIENCE PAGE
/// ---------------------------------------------------------------------
/// Renders PortfolioData.experience as a vertical timeline: dates on the
/// left, a colored dot, and a card with the role's bullets on the right.
/// On mobile there's no room for a side-by-side timeline, so it collapses
/// to a simpler stacked layout (dates above the card).
/// ---------------------------------------------------------------------
class ExperiencePage extends StatelessWidget {
  const ExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < AppBreakpoints.mobile;
    return PageShell(children: [
      ContentColumn(
        child: const PageHeader(
          eyebrow: 'Career Path',
          title: '12 years, four companies, one throughline: build it right, then build the team.',
          subtitle: 'From fixing production bugs in financial systems to leading engineering '
              'strategy for a healthcare product team.',
        ),
      ),
      ContentColumn(
        child: Column(
          children: [
            // Loop over every role in the data file — reordering the list
            // in portfolio_data.dart reorders the timeline automatically.
            for (final role in PortfolioData.experience)
              Padding(
                padding: const EdgeInsets.only(bottom: 28),
                child: isMobile ? _MobileRole(role: role) : _DesktopRole(role: role),
              ),
          ],
        ),
      ),
    ]);
  }
}

/// Desktop layout for one role: a fixed-width date column, a colored dot,
/// then the role card filling the remaining space.
class _DesktopRole extends StatelessWidget {
  final ExperienceEntry role;
  const _DesktopRole({required this.role});

  @override
  Widget build(BuildContext context) {
    // IntrinsicHeight lets the date column and dot vertically align with
    // the card next to them, even though the card's height varies role to
    // role (it's however tall its bullet list needs to be).
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(role.dates, textAlign: TextAlign.right, style: AppText.mono(11, color: AppColors.slate)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
            child: Container(width: 14, height: 14, decoration: BoxDecoration(color: accentColor(role.accent), shape: BoxShape.circle)),
          ),
          Expanded(child: _RoleCard(role: role)),
        ],
      ),
    );
  }
}

/// Mobile layout: dates sit above the card instead of beside it — there's
/// not enough width for a 3-column (date / dot / card) row on a phone.
class _MobileRole extends StatelessWidget {
  final ExperienceEntry role;
  const _MobileRole({required this.role});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(role.dates, style: AppText.mono(11, color: AppColors.slate)),
        const SizedBox(height: 8),
        _RoleCard(role: role),
      ],
    );
  }
}

/// The white card for a single role: title, company/dates line, bullet
/// list, and small metric chips. Shared between desktop and mobile layouts.
class _RoleCard extends StatelessWidget {
  final ExperienceEntry role;
  const _RoleCard({required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 26),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(role.title, style: AppText.display(19)),
          const SizedBox(height: 2),
          RichText(
            text: TextSpan(children: [
              TextSpan(text: role.company, style: AppText.body(14, weight: FontWeight.w600)),
              TextSpan(text: ' · ${role.dates}', style: AppText.body(14, color: AppColors.slate)),
            ]),
          ),
          const SizedBox(height: 16),
          for (final b in role.bullets)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _Bullet(text: b),
            ),
          if (role.metrics.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(spacing: 8, runSpacing: 8, children: [for (final m in role.metrics) MonoChip(m)]),
          ],
        ],
      ),
    );
  }
}

/// One bullet-point row: a small round dot + the bullet's text (which may
/// contain **bold** markers, handled by _RichBullet below).
class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, right: 12),
          child: Container(width: 6, height: 6, decoration: BoxDecoration(color: AppColors.slate.withOpacity(0.5), shape: BoxShape.circle)),
        ),
        Expanded(child: _RichBullet(text: text)),
      ],
    );
  }
}

/// Renders bullet text that contains `**bold**` markers (a tiny bit of
/// markdown-style syntax used in portfolio_data.dart to bold key numbers
/// and phrases, e.g. "cut release cycle time **40%**"). Splitting on '**'
/// alternates plain/bold: even-indexed pieces are normal text, odd-indexed
/// pieces (the parts that were between a pair of **) are bold.
class _RichBullet extends StatelessWidget {
  final String text;
  const _RichBullet({required this.text});

  @override
  Widget build(BuildContext context) {
    final parts = text.split('**');
    final spans = <TextSpan>[];
    for (var i = 0; i < parts.length; i++) {
      spans.add(TextSpan(
        text: parts[i],
        style: AppText.body(14.5, weight: i.isOdd ? FontWeight.w700 : FontWeight.w400),
      ));
    }
    return RichText(text: TextSpan(children: spans));
  }
}
