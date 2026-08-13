import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ---------------------------------------------------------------------
/// DESIGN TOKENS
/// ---------------------------------------------------------------------
/// This file is the single place that defines "what the site looks like":
/// colors, fonts, and responsive breakpoints. Every widget in the app
/// should reference AppColors / AppText / AppBreakpoints instead of
/// hard-coding a Color(...) or TextStyle(...) inline — that way, changing
/// the whole site's look (e.g. swapping the accent color) means editing
/// values in ONE place instead of hunting through every page.
/// ---------------------------------------------------------------------

/// All colors used across the site. Named after their *role* (ink, paper,
/// teal accent, etc.) rather than where they're used, so the same name
/// makes sense whether it's used in the nav bar or a project card.
class AppColors {
  static const ink = Color(0xFF14172D);   // near-black navy — headings, dark backgrounds
  static const paper = Color(0xFFF8F7FB); // off-white — page background
  static const teal = Color(0xFF00BFA6);  // primary accent
  static const coral = Color(0xFFFF6F59); // secondary accent
  static const violet = Color(0xFF8C7AE6);// tertiary accent
  static const slate = Color(0xFF5B6178); // muted body text
  static const line = Color(0x1714172D);  // ink at ~9% opacity — hairline borders
  static const white = Colors.white;
}

/// Typography helpers. Flutter's TextStyle is a plain data class with no
/// concept of "the app's heading font" built in, so these functions stand
/// in for that: call AppText.display(...) instead of writing
/// GoogleFonts.manrope(fontSize: ..., ...) every time you need a heading.
class AppText {
  /// Headings — Manrope, bold, tight letter-spacing for a confident look.
  static TextStyle display(double size, {Color? color, FontWeight? weight}) =>
      GoogleFonts.manrope(
        fontSize: size,
        fontWeight: weight ?? FontWeight.w700,
        color: color ?? AppColors.ink,
        letterSpacing: -0.5,
        height: 1.1,
      );

  /// Body copy and UI text — Inter, chosen for legibility at small sizes.
  static TextStyle body(double size, {Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: size,
        fontWeight: weight ?? FontWeight.w400,
        color: color ?? AppColors.ink,
        height: 1.6,
      );

  /// Monospace — JetBrains Mono, used sparingly for labels/stats/chips as
  /// a nod to the "engineer" identity. Deliberately NOT used for body text,
  /// since long paragraphs in monospace hurt readability.
  static TextStyle mono(double size, {Color? color, FontWeight? weight}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: size,
        fontWeight: weight ?? FontWeight.w500,
        color: color ?? AppColors.ink,
      );
}

/// Screen-width thresholds used everywhere a widget needs to ask
/// "am I on mobile right now?" (Flutter web has no separate "mobile build" —
/// the same code runs at every width, so layout has to react to
/// MediaQuery.of(context).size.width at build time.)
class AppBreakpoints {
  static const mobile = 860.0;       // below this: stack layouts, hide desktop nav
  static const tablet = 960.0;       // below this: drop from 3 columns to 2
  static const maxContent = 1240.0;  // page content never grows wider than this
}

/// Builds the MaterialApp-level ThemeData. Kept minimal on purpose — most
/// widgets set their own colors/fonts explicitly via AppColors/AppText
/// rather than relying on theme inheritance, since the design has very
/// specific per-element colors (e.g. accent-colored borders) that don't
/// map cleanly onto Material's ColorScheme roles.
ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.paper,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.teal,
      brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.interTextTheme(),
    // Flat, no-ripple interactions feel more "product site" than "Material app".
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
  );
}
