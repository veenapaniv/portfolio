import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/page_shell.dart';

/// ---------------------------------------------------------------------
/// CONTACT PAGE
/// ---------------------------------------------------------------------
/// A "message form" on one side and a stack of direct-contact cards
/// (Email/Phone/LinkedIn/GitHub) on the other. Since this is a static
/// site with no backend server, the form doesn't actually transmit
/// anything over the network — "Send message" builds a mailto: link
/// from whatever the visitor typed and hands it to their own email
/// client to send. This was a deliberate choice (see chat history) over
/// wiring up a third-party form service like Formspree, which would need
/// its own account/setup.
/// ---------------------------------------------------------------------
class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  // TextEditingControllers hold each field's current text and must be
  // disposed when the widget goes away (see dispose() below) — Flutter
  // will emit a memory-leak warning in debug mode if you forget this.
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  /// Builds a mailto: URL from the form fields and opens it — this is what
  /// hands off to the visitor's own email app with the message pre-filled.
  Future<void> _sendMail() async {
    // mailto: URLs need their subject/body percent-encoded (spaces, line
    // breaks, punctuation aren't valid raw in a URL) — Uri.encodeComponent
    // does that encoding for us.
    final subject = Uri.encodeComponent('Portfolio contact from ${_nameCtrl.text.isEmpty ? "your site" : _nameCtrl.text}');
    final bodyLines = [
      if (_emailCtrl.text.isNotEmpty) 'From: ${_emailCtrl.text}',
      '',
      _messageCtrl.text,
    ];
    final body = Uri.encodeComponent(bodyLines.join('\n'));
    final uri = Uri.parse('mailto:${PortfolioData.email}?subject=$subject&body=$body');
    await launchUrl(uri);
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
        child: const PageHeader(
          eyebrow: 'Get In Touch',
          title: "Let's talk.",
          subtitle: 'Open to Engineering Manager and Staff/Principal Backend roles. '
              'Reach out directly or send a note below.',
        ),
      ),
      ContentColumn(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 48, vertical: isMobile ? 32 : 44)
            .copyWith(bottom: isMobile ? 60 : 100),
        // Desktop: form and contact cards side by side. Mobile: form on
        // top, contact cards below.
        child: isMobile
            ? Column(children: [_FormCard(nameCtrl: _nameCtrl, emailCtrl: _emailCtrl, messageCtrl: _messageCtrl, onSend: _sendMail), const SizedBox(height: 24), const _SideStack()])
            : IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _FormCard(nameCtrl: _nameCtrl, emailCtrl: _emailCtrl, messageCtrl: _messageCtrl, onSend: _sendMail)),
                    const SizedBox(width: 32),
                    const Expanded(child: _SideStack()),
                  ],
                ),
              ),
      ),
    ]);
  }
}

/// The white card containing Name/Email/Message fields and the Send button.
/// Receives the controllers and the send callback from its parent (the
/// State object above) rather than owning them itself, since this widget
/// gets rebuilt on every keystroke but the controllers must survive that.
class _FormCard extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController messageCtrl;
  final VoidCallback onSend;
  const _FormCard({required this.nameCtrl, required this.emailCtrl, required this.messageCtrl, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(34),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Send a message', style: AppText.display(19)),
          const SizedBox(height: 18),
          _field('Name', nameCtrl, maxLines: 1),
          const SizedBox(height: 16),
          _field('Email', emailCtrl, maxLines: 1),
          const SizedBox(height: 16),
          _field('Message', messageCtrl, maxLines: 5),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSend,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.ink,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: Text('Send message', style: AppText.body(14.5, color: Colors.white, weight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 10),
          // Sets expectations honestly — this is NOT a live in-page send;
          // it hands off to the visitor's own email client.
          Text('Opens your email app with this message pre-filled.',
              style: AppText.body(12, color: AppColors.slate)),
        ],
      ),
    );
  }

  /// One labelled text field — a small uppercase label above a rounded
  /// TextField, styled to match the rest of the site (teal focus border,
  /// paper-colored fill).
  Widget _field(String label, TextEditingController controller, {required int maxLines}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(),
            style: AppText.body(12.5, color: AppColors.slate, weight: FontWeight.w600).copyWith(letterSpacing: 0.6)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines, // 1 for Name/Email, 5 for the Message textarea
          style: AppText.body(14.5),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.paper,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            // Flutter TextFields need border explicitly set for each
            // interaction state (default/enabled/focused) — otherwise
            // Material's default theme border would be used instead of
            // this site's custom look.
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.line, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.line, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.teal, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

/// The right-hand stack of contact method cards + the "based in Orlando"
/// availability note.
class _SideStack extends StatelessWidget {
  const _SideStack();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ContactCard(
          color: AppColors.teal,
          icon: Icons.alternate_email_rounded,
          label: 'Email',
          value: PortfolioData.email,
          onTap: () => launchUrl(Uri.parse('mailto:${PortfolioData.email}')),
        ),
        const SizedBox(height: 14),
        _ContactCard(
          color: AppColors.coral,
          icon: Icons.call_rounded,
          label: 'Phone',
          value: PortfolioData.phone,
          // tel: links don't accept dashes reliably across platforms, so
          // strip them before building the URI.
          onTap: () => launchUrl(Uri.parse('tel:${PortfolioData.phone.replaceAll('-', '')}')),
        ),
        const SizedBox(height: 14),
        _ContactCard(
          color: AppColors.violet,
          icon: Icons.business_center_rounded,
          label: 'LinkedIn',
          value: PortfolioData.linkedin,
          onTap: () => launchUrl(Uri.parse(PortfolioData.linkedinUrl)),
        ),
        const SizedBox(height: 14),
        _ContactCard(
          color: AppColors.ink,
          icon: Icons.code_rounded,
          label: 'GitHub',
          value: PortfolioData.github,
          onTap: () => launchUrl(Uri.parse(PortfolioData.githubUrl)),
        ),
        const SizedBox(height: 14),
        // Small dark "availability" callout — not a tappable card, just
        // a status note.
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(14)),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.teal,
                  shape: BoxShape.circle,
                  // A soft glow ring around the dot, built from a
                  // zero-blur, spread-only shadow rather than an actual
                  // blur — this keeps the ring crisp instead of fuzzy.
                  boxShadow: [BoxShadow(color: AppColors.teal.withOpacity(0.3), blurRadius: 0, spreadRadius: 4)],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(text: 'Based in Orlando, FL', style: AppText.body(14, color: Colors.white, weight: FontWeight.w700)),
                    TextSpan(text: ' — open to remote and hybrid roles', style: AppText.body(14, color: const Color(0xFFB9BBD1))),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// One tappable contact method card: colored icon square + label/value text.
class _ContactCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  const _ContactCard({required this.color, required this.icon, required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.line),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
                alignment: Alignment.center,
                child: Icon(icon, color: Colors.white, size: 19),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label.toUpperCase(), style: AppText.body(11.5, color: AppColors.slate).copyWith(letterSpacing: 0.5)),
                  const SizedBox(height: 2),
                  Text(value, style: AppText.body(14.5, weight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
