import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:media_kit/media_kit.dart';

import 'provider/providers.dart';
import 'utils/app_theme.dart';
import 'services/alarm_service.dart';
import 'widgets/app_initializer.dart';

// Conditional imports for native-only packages
import 'main_native.dart' if (dart.library.html) 'main_web.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  await dotenv.load(fileName: '.env');

  // Initialize MediaKit for video playback
  MediaKit.ensureInitialized();

  // Initialize timezone data
  tz.initializeTimeZones();

  // Initialize sqflite (platform-specific: FFI for desktop, WASM for web)
  initializeSqflite();

  if (!kIsWeb) {
    // Initialize alarm manager and notifications (native only)
    await initializeAlarms();
  }

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
