import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/page_shell.dart';

/// ---------------------------------------------------------------------
/// RESUME PAGE
/// ---------------------------------------------------------------------
/// Shows the resume PDF inline (via an embedded browser <iframe>) with a
/// "Download PDF" button, plus a sidebar recapping certifications,
/// education, and awards so those are scannable without opening the PDF.
///
/// This file imports dart:html and dart:ui_web directly — that only
/// works because this whole project targets Flutter *web* exclusively
/// (per the brief: "host it as a flutter web app"). Those two imports
/// don't exist on mobile/desktop Flutter, so if this project ever grows
/// a non-web target, this file's iframe logic would need a conditional
/// import guarding it.
/// ---------------------------------------------------------------------

// pubspec.yaml declares the asset as `assets/resume.pdf`. Flutter's web
// build nests every declared asset under an extra top-level `assets/`
// folder when it copies things into build/web/, so the file actually
// ends up served at .../assets/assets/resume.pdf — hence the doubled path.
const _resumeAssetPath = 'assets/assets/resume.pdf';

// registerViewFactory() needs a unique string ID and can only be called
// ONCE per ID for the lifetime of the app — calling it twice throws. Since
// ResumePage can be built more than once (e.g. navigating away and back),
// `_pdfViewRegistered` is a module-level flag guarding against a second
// registration attempt.
const _pdfViewType = 'resume-pdf-iframe';
bool _pdfViewRegistered = false;

void _registerPdfView() {
  if (_pdfViewRegistered) return;
  // This tells Flutter web: "whenever a widget asks for the platform view
  // named 'resume-pdf-iframe', hand it this actual HTML <iframe> element."
  // It's how Flutter web embeds real browser content (PDFs, maps, etc.)
  // inside what's otherwise a canvas-rendered app.
  ui_web.platformViewRegistry.registerViewFactory(_pdfViewType, (int viewId) {
    return html.IFrameElement()
      ..src = _resumeAssetPath
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%';
  });
  _pdfViewRegistered = true;
}

class ResumePage extends StatefulWidget {
  const ResumePage({super.key});

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  @override
  void initState() {
    super.initState();
    // Registering here (once per State creation, guarded by the flag
    // above) rather than at file-load time keeps the dart:html/ui_web
    // setup scoped to when this page actually gets used.
    _registerPdfView();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < AppBreakpoints.mobile;

    return PageShell(children: [
      ContentColumn(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 48,
          vertical: isMobile ? 40 : 64,
        ).copyWith(bottom: 8),
        child: PageHeader(
          eyebrow: 'The Full Picture',
          title: 'Resume',
          subtitle: 'Everything above, in one document — view it inline or download the PDF.',
          // PageHeader's `trailing` slot places this button beside the
          // title on desktop, or below it on mobile — see page_shell.dart.
          trailing: ElevatedButton.icon(
            // webOnlyWindowName: '_blank' opens the PDF in a new browser
            // tab rather than navigating the current tab away from the app.
            onPressed: () => launchUrl(Uri.parse(_resumeAssetPath), webOnlyWindowName: '_blank'),
            icon: const Icon(Icons.download_rounded, size: 18, color: Colors.white),
            label: Text('Download PDF', style: AppText.body(14, color: Colors.white, weight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.ink,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
          ),
        ),
      ),
      ContentColumn(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 48, vertical: isMobile ? 32 : 40)
            .copyWith(bottom: isMobile ? 60 : 100),
        // Desktop: PDF preview + sidebar side by side. Mobile: sidebar
        // moves below the (shorter) preview since there's no spare width.
        child: isMobile
            ? Column(children: const [_PdfPreview(), SizedBox(height: 24), _SidePanel()])
            : IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(child: _PdfPreview()),
                    SizedBox(width: 32),
                    SizedBox(width: 300, child: _SidePanel()),
                  ],
                ),
              ),
      ),
    ]);
  }
}

/// The card containing the embedded PDF viewer. HtmlElementView is the
/// Flutter widget that renders whatever was registered under
/// `_pdfViewType` above (our <iframe>) at this position in the widget tree.
class _PdfPreview extends StatelessWidget {
  const _PdfPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 640, // fixed height so the iframe has a definite size to fill
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 50, offset: const Offset(0, 20))],
      ),
      // clipBehavior ensures the iframe's square corners get clipped to
      // match the card's rounded corners — without this, the iframe would
      // visually poke out past the rounded border.
      clipBehavior: Clip.antiAlias,
      child: const HtmlElementView(viewType: _pdfViewType),
    );
  }
}

/// Sidebar recapping Certifications / Education / Awards, read straight
/// from PortfolioData so it always matches what's in the actual PDF.
class _SidePanel extends StatelessWidget {
  const _SidePanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _panel('Certifications', [
          for (final c in PortfolioData.certifications) _line(c[0], c.length > 1 ? c[1] : ''),
        ]),
        const SizedBox(height: 16),
        _panel('Education', [
          for (final e in PortfolioData.education) _line(e[0], '${e[1]} · ${e[2]}'),
        ]),
        const SizedBox(height: 16),
        _panel('Awards', [
          for (final a in PortfolioData.awards) _dotLine(a),
        ]),
      ],
    );
  }

  /// A titled white card wrapping a list of rows — shared shell for all
  /// three sidebar sections.
  Widget _panel(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppColors.line), borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: AppText.mono(11, color: AppColors.slate).copyWith(letterSpacing: 1)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  /// A "bold line, optional grey subtitle line" row — used for
  /// Certifications and Education entries.
  Widget _line(String bold, String sub) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(bold, style: AppText.body(13.5, weight: FontWeight.w600)),
          if (sub.isNotEmpty) Text(sub, style: AppText.body(12.5, color: AppColors.slate)),
        ],
      ),
    );
  }

  /// A small teal-dot bullet row — used for Awards entries.
  Widget _dotLine(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6, right: 10),
            child: Container(width: 7, height: 7, decoration: const BoxDecoration(color: AppColors.teal, shape: BoxShape.circle)),
          ),
          Expanded(child: Text(text, style: AppText.body(13.5))),
        ],
      ),
    );
  }
}
