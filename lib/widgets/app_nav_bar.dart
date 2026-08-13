import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

/// (label, route) pairs for every page, in the order they should appear
/// in the nav — both the desktop link row and the mobile bottom-sheet menu
/// loop over this same list, so adding a page here updates both at once.
const navItems = [
  ('Home', '/'),
  ('Experience', '/experience'),
  ('Projects', '/projects'),
  ('Skills', '/skills'),
  ('Resume', '/resume'),
  ('Contact', '/contact'),
];

/// The sticky top navigation bar shown on every page (via PageShell).
/// Implements PreferredSizeWidget so it can be passed straight to
/// Scaffold's `appBar:` slot even though it's not a Flutter AppBar.
class AppNavBar extends StatelessWidget implements PreferredSizeWidget {
  const AppNavBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < AppBreakpoints.mobile;

    // GoRouterState.of(context).uri tells us which route is currently
    // showing, so we can underline the matching nav link.
    final currentPath = GoRouterState.of(context).uri.toString();

    return Container(
      height: preferredSize.height,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 48),
      decoration: const BoxDecoration(
        color: AppColors.paper,
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        children: [
          // Logo — "VV." with the period in teal. Tapping it always goes home.
          GestureDetector(
            onTap: () => context.go('/'),
            child: RichText(
              text: TextSpan(
                style: AppText.display(20, weight: FontWeight.w700),
                children: const [
                  TextSpan(text: 'VV'),
                  TextSpan(text: '.', style: TextStyle(color: AppColors.teal)),
                ],
              ),
            ),
          ),
          const Spacer(),
          // Below the mobile breakpoint there's no room for six text links,
          // so swap the whole link row for a single hamburger button.
          if (!isMobile)
            Row(
              children: [
                for (final item in navItems) _NavLink(item: item, currentPath: currentPath),
              ],
            )
          else
            _MobileMenuButton(currentPath: currentPath),
        ],
      ),
    );
  }
}

/// A single desktop nav link. Stateful only so it can track mouse-hover
/// (Flutter has no CSS `:hover` — MouseRegion + setState is the standard
/// way to react to hover on web/desktop).
class _NavLink extends StatefulWidget {
  final (String, String) item; // Dart "record" type: (label, route) pair
  final String currentPath;
  const _NavLink({required this.item, required this.currentPath});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    final (label, path) = widget.item; // destructure the record
    final active = widget.currentPath == path;
    final color = active || hover ? AppColors.ink : AppColors.slate;

    return Padding(
      padding: const EdgeInsets.only(left: 32),
      child: MouseRegion(
        onEnter: (_) => setState(() => hover = true),
        onExit: (_) => setState(() => hover = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => context.go(path), // go_router: replace the current route
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: AppText.body(14, color: color, weight: FontWeight.w500)),
              const SizedBox(height: 4),
              // The little gradient underline that marks the active page.
              // Animates implicitly because AnimatedContainer isn't used —
              // it just pops in/out; swap for AnimatedContainer if you want
              // it to slide.
              Container(
                height: 2,
                width: active ? 20 : 0,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.teal, AppColors.coral]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Hamburger icon shown only on mobile widths; opens a bottom sheet with
/// the same nav items as the desktop row.
class _MobileMenuButton extends StatelessWidget {
  final String currentPath;
  const _MobileMenuButton({required this.currentPath});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu_rounded, color: AppColors.ink),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: AppColors.paper,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final item in navItems)
                    ListTile(
                      title: Text(
                        item.$1, // record field access: .$1 = label, .$2 = route
                        style: AppText.body(
                          16,
                          weight: FontWeight.w600,
                          color: currentPath == item.$2 ? AppColors.teal : AppColors.ink,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context); // close the sheet first...
                        context.go(item.$2);    // ...then navigate
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
