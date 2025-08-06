import 'package:flutter/material.dart';

class AppTheme {
  // Black & Gold Color Palette
  static const Color primaryGold = Color(0xFFFFD700);
  static const Color darkGold = Color(0xFFD4AF37);
  static const Color deepGold = Color(0xFFB8860B);
  static const Color richBlack = Color(0xFF000000);
  static const Color charcoalBlack = Color(0xFF1A1A1A);
  static const Color softBlack = Color(0xFF2A2A2A);
  static const Color accentGold = Color(0xFFFFF8DC);
  static const Color errorRed = Color(0xFFFF6B6B);
  static const Color successGreen = Color(0xFF4ECDC4);

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryGold,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: primaryGold,
      primaryContainer: darkGold,
      secondary: deepGold,
      secondaryContainer: accentGold,
      surface: Colors.white,
      surfaceTint: accentGold,
      onPrimary: richBlack,
      onSecondary: Colors.white,
      onSurface: richBlack,
      error: errorRed,
      onError: Colors.white,
      outline: darkGold,
      shadow: richBlack,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: richBlack,
      elevation: 0,
      scrolledUnderElevation: 4,
      shadowColor: primaryGold.withOpacity(0.3),
      surfaceTintColor: accentGold,
      iconTheme: const IconThemeData(color: darkGold, size: 24),
      titleTextStyle: const TextStyle(
        color: richBlack,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style:
          ElevatedButton.styleFrom(
            backgroundColor: primaryGold,
            foregroundColor: richBlack,
            shadowColor: darkGold.withOpacity(0.5),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ).copyWith(
            overlayColor: MaterialStateProperty.resolveWith<Color?>((
              Set<MaterialState> states,
            ) {
              if (states.contains(MaterialState.pressed)) {
                return darkGold.withOpacity(0.3);
              }
              if (states.contains(MaterialState.hovered)) {
                return darkGold.withOpacity(0.1);
              }
              return null;
            }),
          ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: darkGold,
        side: const BorderSide(color: darkGold, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      shadowColor: primaryGold.withOpacity(0.2),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: accentGold.withOpacity(0.3), width: 1),
      ),
      margin: const EdgeInsets.all(8),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: richBlack,
        fontWeight: FontWeight.w900,
        fontSize: 32,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        color: richBlack,
        fontWeight: FontWeight.w800,
        fontSize: 28,
        letterSpacing: -0.3,
      ),
      headlineLarge: TextStyle(
        color: richBlack,
        fontWeight: FontWeight.w700,
        fontSize: 24,
        letterSpacing: 0,
      ),
      headlineMedium: TextStyle(
        color: richBlack,
        fontWeight: FontWeight.w600,
        fontSize: 20,
        letterSpacing: 0.2,
      ),
      titleLarge: TextStyle(
        color: darkGold,
        fontWeight: FontWeight.w700,
        fontSize: 18,
        letterSpacing: 0.3,
      ),
      titleMedium: TextStyle(
        color: deepGold,
        fontWeight: FontWeight.w600,
        fontSize: 16,
        letterSpacing: 0.2,
      ),
      bodyLarge: TextStyle(color: richBlack, fontSize: 16, letterSpacing: 0.1),
      bodyMedium: TextStyle(
        color: charcoalBlack,
        fontSize: 14,
        letterSpacing: 0.1,
      ),
      labelLarge: TextStyle(
        color: darkGold,
        fontWeight: FontWeight.w700,
        fontSize: 14,
        letterSpacing: 1.25,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: accentGold.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: primaryGold, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: errorRed),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: errorRed, width: 2),
      ),
      filled: true,
      fillColor: accentGold.withOpacity(0.1),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      labelStyle: const TextStyle(color: darkGold),
      hintStyle: TextStyle(color: Colors.grey.shade600),
      prefixIconColor: darkGold,
      suffixIconColor: darkGold,
    ),
    iconTheme: const IconThemeData(color: darkGold, size: 24),
    dividerColor: accentGold.withOpacity(0.3),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryGold,
      unselectedItemColor: Colors.grey.shade600,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: 16,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryGold,
    scaffoldBackgroundColor: richBlack,
    colorScheme: const ColorScheme.dark(
      primary: primaryGold,
      primaryContainer: darkGold,
      secondary: deepGold,
      secondaryContainer: charcoalBlack,
      surface: charcoalBlack,
      surfaceTint: primaryGold,
      onPrimary: richBlack,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      error: errorRed,
      onError: Colors.white,
      outline: darkGold,
      shadow: primaryGold,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: richBlack,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 4,
      shadowColor: primaryGold.withOpacity(0.3),
      surfaceTintColor: primaryGold,
      iconTheme: const IconThemeData(color: primaryGold, size: 24),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style:
          ElevatedButton.styleFrom(
            backgroundColor: primaryGold,
            foregroundColor: richBlack,
            shadowColor: primaryGold.withOpacity(0.5),
            elevation: 12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ).copyWith(
            overlayColor: MaterialStateProperty.resolveWith<Color?>((
              Set<MaterialState> states,
            ) {
              if (states.contains(MaterialState.pressed)) {
                return darkGold.withOpacity(0.3);
              }
              if (states.contains(MaterialState.hovered)) {
                return darkGold.withOpacity(0.1);
              }
              return null;
            }),
          ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryGold,
        side: const BorderSide(color: primaryGold, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: charcoalBlack,
      shadowColor: primaryGold.withOpacity(0.3),
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: primaryGold.withOpacity(0.2), width: 1),
      ),
      margin: const EdgeInsets.all(8),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w900,
        fontSize: 32,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w800,
        fontSize: 28,
        letterSpacing: -0.3,
      ),
      headlineLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 24,
        letterSpacing: 0,
      ),
      headlineMedium: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 20,
        letterSpacing: 0.2,
      ),
      titleLarge: TextStyle(
        color: primaryGold,
        fontWeight: FontWeight.w700,
        fontSize: 18,
        letterSpacing: 0.3,
      ),
      titleMedium: TextStyle(
        color: darkGold,
        fontWeight: FontWeight.w600,
        fontSize: 16,
        letterSpacing: 0.2,
      ),
      bodyLarge: TextStyle(
        color: Colors.white,
        fontSize: 16,
        letterSpacing: 0.1,
      ),
      bodyMedium: TextStyle(
        color: Colors.white70,
        fontSize: 14,
        letterSpacing: 0.1,
      ),
      labelLarge: TextStyle(
        color: primaryGold,
        fontWeight: FontWeight.w700,
        fontSize: 14,
        letterSpacing: 1.25,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: primaryGold.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: primaryGold, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: errorRed),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: errorRed, width: 2),
      ),
      filled: true,
      fillColor: softBlack.withOpacity(0.3),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      labelStyle: const TextStyle(color: primaryGold),
      hintStyle: TextStyle(color: Colors.grey.shade500),
      prefixIconColor: primaryGold,
      suffixIconColor: primaryGold,
    ),
    iconTheme: const IconThemeData(color: primaryGold, size: 24),
    dividerColor: primaryGold.withOpacity(0.2),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: charcoalBlack,
      selectedItemColor: primaryGold,
      unselectedItemColor: Colors.grey.shade600,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: 16,
    ),
  );

  // Gradient Definitions for consistent use across the app
  static const LinearGradient primaryGoldGradient = LinearGradient(
    colors: [primaryGold, darkGold, deepGold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    colors: [richBlack, charcoalBlack, richBlack],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const RadialGradient goldRadialGradient = RadialGradient(
    colors: [primaryGold, darkGold, deepGold],
    center: Alignment.center,
    radius: 1.0,
  );

  // Text Styles for special use cases
  static const TextStyle heroTitleStyle = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    letterSpacing: 8,
    shadows: [
      Shadow(offset: Offset(0, 2), blurRadius: 8, color: Colors.black54),
    ],
  );

  static TextStyle goldGradientTextStyle = const TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w900,
    letterSpacing: -0.5,
    height: 1.1,
  );

  // Box Decorations for consistent styling
  static BoxDecoration glassmorphismDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: primaryGold.withOpacity(0.3), width: 1),
    color: Colors.black.withOpacity(0.3),
    boxShadow: [
      BoxShadow(
        color: primaryGold.withOpacity(0.1),
        blurRadius: 10,
        spreadRadius: 2,
      ),
    ],
  );

  static BoxDecoration cardGlowDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: primaryGold.withOpacity(0.2), width: 1),
    color: charcoalBlack,
    boxShadow: [
      BoxShadow(
        color: primaryGold.withOpacity(0.3),
        blurRadius: 20,
        spreadRadius: 2,
      ),
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 10,
        offset: const Offset(0, 5),
      ),
    ],
  );
}
