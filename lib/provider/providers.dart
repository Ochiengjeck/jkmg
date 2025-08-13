import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../services/bible_service.dart';
import 'theme_notifier.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

final isDarkModeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(themeProvider);
  return themeMode == ThemeMode.dark;
});

// Bible Service Providers
final bibleServiceProvider = Provider<BibleService>((ref) => BibleService());

final bibleTranslationsProvider = FutureProvider<List<BibleTranslation>>((ref) {
  final bibleService = ref.read(bibleServiceProvider);
  return bibleService.getTranslations();
});

final bibleBooksProvider = FutureProvider.family<List<BibleBook>, String>((ref, translation) {
  final bibleService = ref.read(bibleServiceProvider);
  return bibleService.getBooks(translation: translation);
});

final bibleVerseProvider = FutureProvider.family<BibleVerseResponse, Map<String, String>>((ref, params) {
  final bibleService = ref.read(bibleServiceProvider);
  return bibleService.getVerse(params['reference']!, translation: params['translation']);
});

final bibleChapterProvider = FutureProvider.family<BibleChapterResponse, Map<String, dynamic>>((ref, params) {
  final bibleService = ref.read(bibleServiceProvider);
  return bibleService.getChapter(
    params['translation']!,
    params['bookId']!,
    params['chapter']!,
  );
});

final randomVerseProvider = FutureProvider.family<BibleVerseResponse, Map<String, String?>>((ref, params) {
  final bibleService = ref.read(bibleServiceProvider);
  return bibleService.getRandomVerse(
    translation: params['translation'] ?? 'kjv',
    bookIds: params['bookIds'],
  );
});
