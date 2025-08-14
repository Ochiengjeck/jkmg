import 'dart:typed_data';
import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

class AlarmService {
  static const int morningAlarmId = 1;
  static const int noonAlarmId = 2;
  static const int eveningAlarmId = 3;
  static const int deeperPrayerAlarmId = 4;
  
  // SharedPreferences keys
  static const String _prayerAlarmsEnabledKey = 'prayer_alarms_enabled';
  static const String _deeperPrayerAlarmsEnabledKey = 'deeper_prayer_alarms_enabled';

  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static Future<void> initialize() async {
    // Initialize notifications for both platforms
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
        
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      requestCriticalPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notifications.initialize(initializationSettings);

    // Request notification permissions
    if (Platform.isAndroid) {
      await _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    } else if (Platform.isIOS) {
      await _notifications
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
            critical: true,
          );
    }
  }

  static Future<void> schedulePrayerAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final prayerAlarmsEnabled = prefs.getBool(_prayerAlarmsEnabledKey) ?? true;
    final deeperPrayerAlarmsEnabled = prefs.getBool(_deeperPrayerAlarmsEnabledKey) ?? true;
    
    if (prayerAlarmsEnabled) {
      if (Platform.isAndroid) {
        await _scheduleAndroidAlarms();
      } else if (Platform.isIOS) {
        await _scheduleIOSAlarms();
      }
    }
    
    if (deeperPrayerAlarmsEnabled) {
      if (Platform.isAndroid) {
        await _scheduleAndroidDeeperPrayerAlarm();
      } else if (Platform.isIOS) {
        await _scheduleIOSDeeperPrayerAlarm();
      }
    }
  }

  // Alarm management functions
  static Future<void> enablePrayerAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prayerAlarmsEnabledKey, true);
    await schedulePrayerAlarms();
  }

  static Future<void> disablePrayerAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prayerAlarmsEnabledKey, false);
    await _cancelRegularPrayerAlarms();
  }

  static Future<void> enableDeeperPrayerAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_deeperPrayerAlarmsEnabledKey, true);
    await schedulePrayerAlarms();
  }

  static Future<void> disableDeeperPrayerAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_deeperPrayerAlarmsEnabledKey, false);
    await _cancelDeeperPrayerAlarms();
  }

  static Future<bool> arePrayerAlarmsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prayerAlarmsEnabledKey) ?? true;
  }

  static Future<bool> areDeeperPrayerAlarmsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_deeperPrayerAlarmsEnabledKey) ?? true;
  }

  static Future<void> _scheduleAndroidAlarms() async {
    // Cancel any existing regular prayer alarms
    await AndroidAlarmManager.cancel(morningAlarmId);
    await AndroidAlarmManager.cancel(noonAlarmId);
    await AndroidAlarmManager.cancel(eveningAlarmId);

    final now = DateTime.now();

    // Schedule morning prayer (6 AM)
    final morningTime = DateTime(now.year, now.month, now.day, 6, 0);
    final nextMorning = morningTime.isBefore(now)
        ? morningTime.add(const Duration(days: 1))
        : morningTime;

    // Schedule noon prayer (12 PM)
    final noonTime = DateTime(now.year, now.month, now.day, 12, 0);
    final nextNoon = noonTime.isBefore(now)
        ? noonTime.add(const Duration(days: 1))
        : noonTime;

    // Schedule evening prayer (6 PM)
    final eveningTime = DateTime(now.year, now.month, now.day, 18, 0);
    final nextEvening = eveningTime.isBefore(now)
        ? eveningTime.add(const Duration(days: 1))
        : eveningTime;

    // Schedule the alarms
    await AndroidAlarmManager.oneShotAt(
      nextMorning,
      morningAlarmId,
      morningPrayerAlarm,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );

    await AndroidAlarmManager.oneShotAt(
      nextNoon,
      noonAlarmId,
      noonPrayerAlarm,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );

    await AndroidAlarmManager.oneShotAt(
      nextEvening,
      eveningAlarmId,
      eveningPrayerAlarm,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
  }

  static Future<void> _scheduleIOSAlarms() async {
    // Cancel existing notifications
    await _notifications.cancelAll();

    final now = DateTime.now();
    final prayerTimes = [
      {'hour': 6, 'label': 'Morning Prayer', 'id': morningAlarmId},
      {'hour': 12, 'label': 'Noon Prayer', 'id': noonAlarmId},
      {'hour': 18, 'label': 'Evening Prayer', 'id': eveningAlarmId},
    ];

    for (var prayer in prayerTimes) {
      await _scheduleIOSNotification(
        prayer['id'] as int,
        prayer['label'] as String,
        prayer['hour'] as int,
      );
    }
  }

  static Future<void> _scheduleAndroidDeeperPrayerAlarm() async {
    // Cancel any existing deeper prayer alarm
    await AndroidAlarmManager.cancel(deeperPrayerAlarmId);

    final now = DateTime.now();
    
    // Schedule deeper prayer (12:00 AM - Midnight)
    final midnightTime = DateTime(now.year, now.month, now.day, 0, 0);
    final nextMidnight = midnightTime.isBefore(now)
        ? midnightTime.add(const Duration(days: 1))
        : midnightTime;

    await AndroidAlarmManager.oneShotAt(
      nextMidnight,
      deeperPrayerAlarmId,
      deeperPrayerAlarm,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
  }

  static Future<void> _scheduleIOSDeeperPrayerAlarm() async {
    await _scheduleIOSNotification(
      deeperPrayerAlarmId,
      'Deeper Prayer',
      0, // Midnight
    );
  }

  static Future<void> _cancelRegularPrayerAlarms() async {
    if (Platform.isAndroid) {
      await AndroidAlarmManager.cancel(morningAlarmId);
      await AndroidAlarmManager.cancel(noonAlarmId);
      await AndroidAlarmManager.cancel(eveningAlarmId);
    } else if (Platform.isIOS) {
      await _notifications.cancel(morningAlarmId);
      await _notifications.cancel(noonAlarmId);
      await _notifications.cancel(eveningAlarmId);
    }
  }

  static Future<void> _cancelDeeperPrayerAlarms() async {
    if (Platform.isAndroid) {
      await AndroidAlarmManager.cancel(deeperPrayerAlarmId);
    } else if (Platform.isIOS) {
      await _notifications.cancel(deeperPrayerAlarmId);
    }
  }

  static Future<void> _scheduleIOSNotification(
    int id,
    String prayerType,
    int hour,
  ) async {
    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day, hour, 0);
    
    // If the time has passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'cellphone-ringing-6475.mp3',
      interruptionLevel: InterruptionLevel.critical,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(iOS: iOSPlatformChannelSpecifics);

    await _notifications.zonedSchedule(
      id,
      'Prayer Time! 🕌',
      'It\'s time for $prayerType. Join Rev. Julian in this sacred moment.',
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> _showPrayerNotification(String title, String body) async {
    if (Platform.isAndroid) {
      final AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
            'prayer_alarm_channel',
            'Prayer Alarms',
            channelDescription: 'Notifications for prayer times',
            importance: Importance.max,
            priority: Priority.high,
            sound: RawResourceAndroidNotificationSound('cellphone_ringing_6475'),
            playSound: true,
            enableVibration: true,
            vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
            fullScreenIntent: true,
            category: AndroidNotificationCategory.alarm,
            visibility: NotificationVisibility.public,
          );

      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await _notifications.show(0, title, body, platformChannelSpecifics);
    } else if (Platform.isIOS) {
      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'cellphone-ringing-6475.mp3',
        interruptionLevel: InterruptionLevel.critical,
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(iOS: iOSPlatformChannelSpecifics);

      await _notifications.show(0, title, body, platformChannelSpecifics);
    }
  }

  static Future<void> _playAlarmSound() async {
    try {
      await _audioPlayer.play(
        AssetSource('ringtons/cellphone-ringing-6475.mp3'),
        mode: PlayerMode.mediaPlayer,
      );

      // Play for 30 seconds then stop
      await Future.delayed(const Duration(seconds: 30));
      await _audioPlayer.stop();
    } catch (e) {
      print('Error playing alarm sound: $e');
    }
  }

  static Future<void> triggerPrayerAlarm(String prayerType) async {
    await _playAlarmSound();
    await _showPrayerNotification(
      'Prayer Time! 🕌',
      'It\'s time for $prayerType. Join Rev. Julian in this sacred moment.',
    );
  }

  static Future<void> cancelAllAlarms() async {
    if (Platform.isAndroid) {
      await AndroidAlarmManager.cancel(morningAlarmId);
      await AndroidAlarmManager.cancel(noonAlarmId);
      await AndroidAlarmManager.cancel(eveningAlarmId);
      await AndroidAlarmManager.cancel(deeperPrayerAlarmId);
    } else if (Platform.isIOS) {
      await _notifications.cancelAll();
    }
  }

  static String getNextAlarmTime() {
    final now = DateTime.now();
    final prayerTimes = [
      DateTime(now.year, now.month, now.day, 6, 0),
      DateTime(now.year, now.month, now.day, 12, 0),
      DateTime(now.year, now.month, now.day, 18, 0),
    ];

    for (var time in prayerTimes) {
      if (time.isAfter(now)) {
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      }
    }

    // If no more prayers today, return tomorrow's 6 AM
    final tomorrow = now.add(const Duration(days: 1));
    return '${DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 6, 0).hour.toString().padLeft(2, '0')}:00';
  }
}

// Top-level callback functions for alarm manager
@pragma('vm:entry-point')
void morningPrayerAlarm() async {
  await AlarmService.triggerPrayerAlarm('Morning Prayer');
  // Reschedule for next day
  await AndroidAlarmManager.oneShotAt(
    DateTime.now()
        .add(const Duration(days: 1))
        .copyWith(hour: 6, minute: 0, second: 0),
    AlarmService.morningAlarmId,
    morningPrayerAlarm,
    exact: true,
    wakeup: true,
    rescheduleOnReboot: true,
  );
}

@pragma('vm:entry-point')
void noonPrayerAlarm() async {
  await AlarmService.triggerPrayerAlarm('Noon Prayer');
  // Reschedule for next day
  await AndroidAlarmManager.oneShotAt(
    DateTime.now()
        .add(const Duration(days: 1))
        .copyWith(hour: 12, minute: 0, second: 0),
    AlarmService.noonAlarmId,
    noonPrayerAlarm,
    exact: true,
    wakeup: true,
    rescheduleOnReboot: true,
  );
}

@pragma('vm:entry-point')
void eveningPrayerAlarm() async {
  await AlarmService.triggerPrayerAlarm('Evening Prayer');
  // Reschedule for next day
  await AndroidAlarmManager.oneShotAt(
    DateTime.now()
        .add(const Duration(days: 1))
        .copyWith(hour: 18, minute: 0, second: 0),
    AlarmService.eveningAlarmId,
    eveningPrayerAlarm,
    exact: true,
    wakeup: true,
    rescheduleOnReboot: true,
  );
}

@pragma('vm:entry-point')
void deeperPrayerAlarm() async {
  await AlarmService.triggerPrayerAlarm('Deeper Prayer - Midnight Session');
  // Reschedule for next day
  await AndroidAlarmManager.oneShotAt(
    DateTime.now()
        .add(const Duration(days: 1))
        .copyWith(hour: 0, minute: 0, second: 0),
    AlarmService.deeperPrayerAlarmId,
    deeperPrayerAlarm,
    exact: true,
    wakeup: true,
    rescheduleOnReboot: true,
  );
}
