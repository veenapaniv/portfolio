import 'package:flutter/material.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../theme/accent.dart';
import '../widgets/page_shell.dart';
import '../widgets/cards.dart';

/// ---------------------------------------------------------------------
/// PROJECTS PAGE
/// ---------------------------------------------------------------------
/// Shows every project from PortfolioData.projects in a responsive grid,
/// with filter chips at the top that narrow the list down by category.
/// This page is a StatefulWidget (unlike most other pages) specifically
/// because "which filter is selected" needs to persist across rebuilds —
/// a StatelessWidget has nowhere to keep that kind of local UI state.
/// ---------------------------------------------------------------------
class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  // The one piece of state this page owns: which filter chip is active.
  // Changing this via setState() triggers a rebuild, which recomputes
  // `filtered` below and re-renders the grid with fewer/more cards.
  String selected = 'All';

  @override
  Widget build(BuildContext context) {
    final filtered = selected == 'All'
        ? PortfolioData.projects
        : PortfolioData.projects.where((p) => p.category == selected).toList();

    return PageShell(children: [
      ContentColumn(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width < AppBreakpoints.mobile ? 20 : 48,
          vertical: MediaQuery.of(context).size.width < AppBreakpoints.mobile ? 40 : 64,
        ).copyWith(bottom: 8), // tighter bottom gap since the filter row follows directly
        child: const PageHeader(
          eyebrow: 'Selected Work',
          title: 'Projects that moved the needle',
          subtitle: 'Architecture, platform, and delivery work from six years at Rx Savings '
              'Solutions and Cerner Corporation.',
        ),
      ),
      ContentColumn(
        padding: const EdgeInsets.symmetric(horizontal: 48).copyWith(top: 8, bottom: 0),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final cat in PortfolioData.projectCategories)
              _FilterChip(label: cat, active: cat == selected, onTap: () => setState(() => selected = cat)),
          ],
        ),
      ),
      ContentColumn(
        child: ResponsiveGrid(
          children: [for (final p in filtered) _ProjectCard(project: p)],
        ),
      ),
    ]);
  }
}

/// A single filter chip. Purely visual state (active vs. not) is passed
/// in from the parent's `selected` field — this widget itself holds no
/// state, it just reports taps via `onTap`.
class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(
            color: active ? AppColors.ink : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: active ? AppColors.ink : AppColors.line, width: 1.5),
          ),
          child: Text(label,
              style: AppText.body(13.5, color: active ? Colors.white : AppColors.slate, weight: FontWeight.w600)),
        ),
      ),
    );
  }
}

/// Full project card (more detail than the Home page's teaser version):
/// category tag, title, description, tech-stack chips, and an impact badge.
class _ProjectCard extends StatelessWidget {
  final dynamic project; // always a ProjectEntry at runtime
  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return AccentCard(
      accent: accentColor(project.accent),
      borderSide: Axis.horizontal, // accent stripe along the top edge
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(project.category.toUpperCase(),
              style: AppText.mono(11, color: AppColors.slate).copyWith(letterSpacing: 1)),
          const SizedBox(height: 12),
          Text(project.title, style: AppText.display(18)),
          const SizedBox(height: 10),
          Text(project.description, style: AppText.body(14, color: AppColors.slate)),
          const SizedBox(height: 14),
          Wrap(spacing: 6, runSpacing: 6, children: [for (final t in project.tech) MonoChip(t)]),
          const SizedBox(height: 14),
          ImpactBadge(project.impact),
        ],
      ),
    );
  }
}
