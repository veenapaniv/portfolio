import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'theme/app_theme.dart';
import 'pages/home_page.dart';
import 'pages/experience_page.dart';
import 'pages/projects_page.dart';
import 'pages/skills_page.dart';
import 'pages/resume_page.dart';
import 'pages/contact_page.dart';

/// ---------------------------------------------------------------------
/// ROUTING
/// ---------------------------------------------------------------------
/// go_router maps URL paths to page widgets. Each GoRoute below pairs a
/// path (e.g. '/experience') with the widget to show for it; AppNavBar
/// (in widgets/app_nav_bar.dart) reads this same list of paths to build
/// its links and figure out which one is currently "active".
///
/// NOTE ON ROUTING STRATEGY: this intentionally uses go_router's default
/// HASH-based URLs (e.g. yoursite.com/#/experience) instead of "clean"
/// path URLs (yoursite.com/experience). Here's why that matters for this
/// specific deployment:
///
/// GitHub Pages serves plain static files with no server-side logic. If a
/// visitor loads yoursite.com/experience directly (or refreshes the page
/// while on it), GitHub Pages looks for an actual file at that path,
/// doesn't find one, and returns a 404 — because "/experience" only
/// exists as a client-side route inside the already-loaded Flutter app,
/// not as a real file on the server. Hash URLs sidestep this entirely:
/// everything after the '#' is handled purely by the browser/JS and never
/// sent to the server as part of the request path, so GitHub Pages always
/// just serves index.html regardless of what's after the '#'.
///
/// If you ever move this to a host that supports rewriting all unknown
/// paths back to index.html (e.g. Netlify, Vercel, Firebase Hosting),
/// you could switch to clean URLs by calling usePathUrlStrategy() from
/// package:flutter_web_plugins before runApp() below.
/// ---------------------------------------------------------------------
final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(path: '/experience', builder: (context, state) => const ExperiencePage()),
    GoRoute(path: '/projects', builder: (context, state) => const ProjectsPage()),
    GoRoute(path: '/skills', builder: (context, state) => const SkillsPage()),
    GoRoute(path: '/resume', builder: (context, state) => const ResumePage()),
    GoRoute(path: '/contact', builder: (context, state) => const ContactPage()),
  ],
);

/// Every Flutter app's entry point — this is the first code that runs.
/// runApp() takes the root widget and attaches it to the browser page.
void main() {
  runApp(const PortfolioApp());
}

/// The root widget of the whole site. MaterialApp.router (rather than the
/// plain MaterialApp) is the variant built for go_router / declarative
/// routing — it hands URL/navigation handling off to `routerConfig`
/// instead of managing a Navigator stack manually.
class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Veenapani Veena — Portfolio',
      debugShowCheckedModeBanner: false, // hides the red "DEBUG" corner ribbon
      theme: buildAppTheme(), // see theme/app_theme.dart for colors/fonts
      routerConfig: _router,
    );
  }
}
