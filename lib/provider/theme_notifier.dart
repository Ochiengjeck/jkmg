import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/preference_service.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  PreferenceService? _prefs;
  
  ThemeNotifier() : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    _prefs = await PreferenceService.getInstance();
    state = _prefs!.getThemeMode();
  }

  Future<void> toggleTheme() async {
    _prefs ??= await PreferenceService.getInstance();
    final newTheme = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    state = newTheme;
    await _prefs!.setThemeMode(newTheme);
  }

  Future<void> setTheme(ThemeMode themeMode) async {
    _prefs ??= await PreferenceService.getInstance();
    state = themeMode;
    await _prefs!.setThemeMode(themeMode);
  }
}
