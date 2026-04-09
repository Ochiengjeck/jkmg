import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'services/alarm_service.dart';

void initializeSqflite() {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}

Future<void> initializeAlarms() async {
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await AlarmService.initialize();
}
