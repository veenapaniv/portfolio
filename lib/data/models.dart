/// ---------------------------------------------------------------------
/// DATA MODELS
/// ---------------------------------------------------------------------
/// Plain data classes (no Flutter imports here) describing the shape of
/// the content used across the site. Keeping these separate from
/// portfolio_data.dart means the *shape* of the data (this file) is
/// separate from the *actual content* (that file) — if you ever wanted to
/// load this from a JSON file or a CMS instead of hard-coded Dart, only
/// portfolio_data.dart would need to change.
/// ---------------------------------------------------------------------

/// One job on the Experience page timeline.
class ExperienceEntry {
  final String title;          // job title, e.g. "Engineering Manager"
  final String company;        // employer name
  final String dates;          // display string, e.g. "Jan 2024 – Present"
  final List<String> bullets;  // achievement bullets; '**text**' renders bold
  final List<String> metrics;  // short "impact" chips shown under the bullets
  final String accent;         // 'teal' | 'coral' | 'violet' — see theme/accent.dart

  const ExperienceEntry({
    required this.title,
    required this.company,
    required this.dates,
    required this.bullets,
    required this.metrics,
    required this.accent,
  });
}

/// One card on the Projects page (and, for the first four, the Home page
/// "Featured Work" teaser).
class ProjectEntry {
  final String category;       // used both as a display tag and a filter-chip value
  final String title;
  final String description;
  final List<String> tech;     // small tech-stack pills, e.g. ['AWS', 'Terraform']
  final String impact;         // single headline result, shown as a dark badge
  final String accent;

  const ProjectEntry({
    required this.category,
    required this.title,
    required this.description,
    required this.tech,
    required this.impact,
    required this.accent,
  });
}

/// One card on the Skills page, e.g. "Cloud (AWS)" with its chip list.
class SkillGroup {
  final String label;
  final List<String> items;
  final String accent;

  const SkillGroup({
    required this.label,
    required this.items,
    required this.accent,
  });
}
