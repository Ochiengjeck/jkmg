import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class Responsive {
  static const double desktopBreakpoint = 900.0;
  static const double sidebarWidth = 280.0;
  static const double authFormMaxWidth = 480.0;

  /// True when on web AND viewport width >= desktopBreakpoint.
  static bool isDesktop(BuildContext context) =>
      kIsWeb && MediaQuery.of(context).size.width >= desktopBreakpoint;

  /// True whenever running on web (any width).
  static bool isWeb() => kIsWeb;
}
