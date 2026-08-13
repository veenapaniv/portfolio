import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Every experience/project/skill entry in portfolio_data.dart stores its
/// accent as a plain string ('teal' | 'coral' | 'violet') rather than a
/// Color — that keeps the data file free of Flutter imports, so it reads
/// like content, not code. This function is the one place that translates
/// those strings into actual theme colors.
///
/// Unknown or missing keys fall back to teal (the primary accent) rather
/// than throwing, so a typo in the data file degrades gracefully instead
/// of crashing the page.
Color accentColor(String key) {
  switch (key) {
    case 'coral':
      return AppColors.coral;
    case 'violet':
      return AppColors.violet;
    case 'teal':
    default:
      return AppColors.teal;
  }
}
