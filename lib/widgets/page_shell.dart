import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'app_nav_bar.dart';
import 'app_footer.dart';

/// EdgeInsets doesn't ship with a copyWith() method (unlike most Flutter
/// value classes), but several pages want to take a "standard" padding
/// and just override one side (e.g. "same as usual, but no top padding
/// since the filter row sits right above"). This extension adds that
/// convenience so those call sites read naturally as `.copyWith(top: 0)`.
extension EdgeInsetsCopyWith on EdgeInsets {
  EdgeInsets copyWith({double? left, double? top, double? right, double? bottom}) {
    return EdgeInsets.fromLTRB(
      left ?? this.left,
      top ?? this.top,
      right ?? this.right,
      bottom ?? this.bottom,
    );
  }
}

/// ---------------------------------------------------------------------
/// SHARED PAGE LAYOUT
/// ---------------------------------------------------------------------
/// Every page in lib/pages/ is built as:
///   PageShell(children: [ ...page-specific sections..., ])
/// PageShell takes care of the three things every page needs: the sticky
/// nav bar, a scroll view, and the footer at the bottom — so individual
/// page files only need to describe their own content.
/// ---------------------------------------------------------------------
class PageShell extends StatelessWidget {
  final List<Widget> children;
  const PageShell({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavBar(),
      // SingleChildScrollView + Column is the standard Flutter pattern for
      // "a page that's just one long vertical scroll" — there's no fixed
      // list of items here (so no need for ListView), just a stack of
      // differently-shaped sections.
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...children,
            const AppFooter(), // always last, on every page
          ],
        ),
      ),
    );
  }
}

/// Centers its child and caps it at AppBreakpoints.maxContent wide, with
/// responsive horizontal padding. This is what keeps text from stretching
/// edge-to-edge on a wide desktop monitor — every section on every page
/// wraps its content in one of these.
class ContentColumn extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding; // override the default spacing if needed
  const ContentColumn({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < AppBreakpoints.mobile;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppBreakpoints.maxContent),
        child: Padding(
          // Smaller side padding on mobile since there's less width to spare.
          padding: padding ??
              EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 48,
                vertical: isMobile ? 40 : 64,
              ),
          child: child,
        ),
      ),
    );
  }
}

/// The "small teal label, then big headline, then optional subtext" block
/// that opens every inner page (Experience, Projects, Skills, etc.).
/// `trailing` is an optional widget (e.g. a button) placed to the right
/// of the text on desktop, or below it on mobile — see the Resume page's
/// "Download PDF" button for an example.
class PageHeader extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  const PageHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < AppBreakpoints.mobile;

    final textBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(eyebrow.toUpperCase(),
            style: AppText.body(13, color: AppColors.teal, weight: FontWeight.w600)
                .copyWith(letterSpacing: 1.2)), // TextStyle DOES have copyWith — this one's built-in
        const SizedBox(height: 14),
        Text(title, style: AppText.display(isMobile ? 30 : 40)),
        if (subtitle != null) ...[
          const SizedBox(height: 14),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560), // keeps long subtitles readable
            child: Text(subtitle!, style: AppText.body(16, color: AppColors.slate)),
          ),
        ],
      ],
    );

    if (trailing == null) return textBlock;

    // On mobile, stack the trailing widget below the text (a Row would be
    // too cramped); on desktop, put it to the right, bottom-aligned.
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [textBlock, const SizedBox(height: 20), trailing!],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: textBlock), // textBlock takes all remaining width
        const SizedBox(width: 24),
        trailing!,
      ],
    );
  }
}
