import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'provider/providers.dart';
import 'utils/app_theme.dart';
import 'services/alarm_service.dart';
import 'widgets/app_initializer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  await dotenv.load(fileName: '.env');

  // Initialize timezone data
  tz.initializeTimeZones();

  // Initialize alarm manager and notifications
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await AlarmService.initialize();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'jkm',
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const AppInitializer(),
    );
  }
}
