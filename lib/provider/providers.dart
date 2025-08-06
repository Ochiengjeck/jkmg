import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../services/api_service.dart';
import 'theme_notifier.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});
