import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';

/// The dark footer band shown at the bottom of every page (added once,
/// inside PageShell, rather than repeated per-page).
class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < AppBreakpoints.mobile;

    return Container(
      width: double.infinity,
      color: AppColors.ink,
      padding: EdgeInsets.fromLTRB(isMobile ? 20 : 48, 56, isMobile ? 20 : 48, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ConstrainedBox(
            // Same max-width as every page's content column, so the
            // footer's contents line up with everything above it.
            constraints: const BoxConstraints(maxWidth: AppBreakpoints.maxContent),
            child: Wrap(
              // Wrap (not Row) so on narrow screens the link list drops
              // to its own line instead of overflowing horizontally.
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 20,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Let's talk.", style: AppText.display(24, color: Colors.white)),
                    const SizedBox(height: 8),
                    Text(
                      '${PortfolioData.email} · ${PortfolioData.location}',
                      style: AppText.mono(13, color: const Color(0xFFB9BBD1)),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 24,
                  runSpacing: 10,
                  children: [
                    // launchUrl (from url_launcher) opens each link in a
                    // new browser tab/native app — mailto: opens the mail
                    // client, https:// links open normally.
                    _FooterLink('GitHub', () => launchUrl(Uri.parse(PortfolioData.githubUrl))),
                    _FooterLink('LinkedIn', () => launchUrl(Uri.parse(PortfolioData.linkedinUrl))),
                    _FooterLink('Email', () => launchUrl(Uri.parse('mailto:${PortfolioData.email}'))),
                    // 'assets/assets/resume.pdf' — see the comment in
                    // resume_page.dart for why the path is doubled.
                    _FooterLink('Resume PDF', () => launchUrl(Uri.parse('assets/assets/resume.pdf'))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'BUILT WITH FLUTTER · HOSTED ON GITHUB PAGES',
            style: AppText.mono(11, color: const Color(0xFF5B6178)),
          ),
        ],
      ),
    );
  }
}

/// A single footer link: mono-styled text with a hand cursor and a tap
/// handler. Kept as its own tiny widget just to avoid repeating the
/// MouseRegion/GestureDetector/Text boilerplate four times above.
class _FooterLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _FooterLink(this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(label, style: AppText.mono(13, color: const Color(0xFFB9BBD1))),
      ),
    );
  }
}
