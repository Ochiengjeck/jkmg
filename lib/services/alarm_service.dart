import 'dart:typed_data';
import 'dart:io';
import 'dart:async';

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

  // Snooze alarm IDs (offset by 100)
  static const int morningSnoozeId = 101;
  static const int noonSnoozeId = 102;
  static const int eveningSnoozeId = 103;
  static const int deeperPrayerSnoozeId = 104;

  // SharedPreferences keys
  static const String _prayerAlarmsEnabledKey = 'prayer_alarms_enabled';
  static const String _deeperPrayerAlarmsEnabledKey =
      'deeper_prayer_alarms_enabled';
  static const String _snoozeTimeKey = 'snooze_time_minutes';
  static const String _alarmMissCountKey = 'alarm_miss_count_';
  static const String _lastAlarmTimeKey = 'last_alarm_time_';

  // Constants
  static const int defaultSnoozeMinutes = 5;
  static const int maxMissedAlarms = 2;
  static const int alarmDurationSeconds = 30;

  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static Future<void> initialize() async {
    // Android init
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    // iOS init
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          requestCriticalPermission: true,
        );

    // Linux init
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');

    // Combine all
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
          linux: initializationSettingsLinux,
        );

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
    );

    // Create Android notification channel
    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'prayer_alarm_channel',
        'Prayer Alarms',
        description: 'Notifications for prayer times',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      );

      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);
    }

    // Permissions
    if (Platform.isAndroid) {
      await _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();

      // Request exact alarm permissions for Android 12+
      await _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestExactAlarmsPermission();
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
    final deeperPrayerAlarmsEnabled =
        prefs.getBool(_deeperPrayerAlarmsEnabledKey) ?? true;

    if (prayerAlarmsEnabled) {
      if (Platform.isAndroid) {
        await _scheduleAndroidAlarms();
      } else if (Platform.isIOS || Platform.isLinux) {
        await _scheduleDesktopAlarms(); // ✅ iOS + Linux use same path
      }
    }

    if (deeperPrayerAlarmsEnabled) {
      if (Platform.isAndroid) {
        await _scheduleAndroidDeeperPrayerAlarm();
      } else if (Platform.isIOS || Platform.isLinux) {
        await _scheduleDesktopDeeperPrayerAlarm();
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

  // Handle notification action responses
  static void _handleNotificationResponse(NotificationResponse response) async {
    final payload = response.payload;
    final actionId = response.actionId;

    if (payload == null) return;

    final parts = payload.split('|');
    if (parts.length < 2) return;

    final alarmType = parts[0];
    final alarmId = int.tryParse(parts[1]) ?? 0;

    // Reset miss count since user interacted
    await _resetMissCount(alarmId);

    if (actionId == 'snooze') {
      await _snoozeAlarm(alarmId, alarmType);
    } else if (actionId == 'cancel') {
      await _cancelCurrentAlarm(alarmId);
    } else {
      // Default tap action - consider as acknowledged
      await _audioPlayer.stop();
      await _notifications.cancel(alarmId);
    }
  }

  // Snooze functionality
  static Future<void> _snoozeAlarm(int alarmId, String alarmType) async {
    final prefs = await SharedPreferences.getInstance();
    final snoozeMinutes = prefs.getInt(_snoozeTimeKey) ?? defaultSnoozeMinutes;

    // Stop current audio
    await _audioPlayer.stop();

    // Schedule snooze alarm
    final snoozeTime = DateTime.now().add(Duration(minutes: snoozeMinutes));
    final snoozeId = _getSnoozeId(alarmId);

    if (Platform.isAndroid) {
      await AndroidAlarmManager.oneShotAt(
        snoozeTime,
        snoozeId,
        _createSnoozeCallback(alarmType),
        exact: true,
        wakeup: true,
      );
    } else {
      await _scheduleSnoozeNotification(snoozeId, alarmType, snoozeTime);
    }

    print('Alarm snoozed for $snoozeMinutes minutes');
  }

  static int _getSnoozeId(int originalId) {
    switch (originalId) {
      case morningAlarmId:
        return morningSnoozeId;
      case noonAlarmId:
        return noonSnoozeId;
      case eveningAlarmId:
        return eveningSnoozeId;
      case deeperPrayerAlarmId:
        return deeperPrayerSnoozeId;
      default:
        return originalId + 100;
    }
  }

  static Function() _createSnoozeCallback(String alarmType) {
    return () async {
      await triggerPrayerAlarm(alarmType);
    };
  }

  static Future<void> _scheduleSnoozeNotification(
    int snoozeId,
    String alarmType,
    DateTime snoozeTime,
  ) async {
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        'prayer_alarm_channel',
        'Prayer Alarms',
        channelDescription: 'Notifications for prayer times',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/launcher_icon',
        sound: RawResourceAndroidNotificationSound('cellphone_ringing_6475'),
        playSound: true,
        enableVibration: true,
        vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
        fullScreenIntent: true,
        category: AndroidNotificationCategory.alarm,
        visibility: NotificationVisibility.public,
        actions: [
          AndroidNotificationAction(
            'snooze',
            'Snooze',
            cancelNotification: false,
          ),
          AndroidNotificationAction(
            'cancel',
            'Cancel',
            cancelNotification: true,
          ),
        ],
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'cellphone-ringing-6475.mp3',
        interruptionLevel: InterruptionLevel.critical,
        categoryIdentifier: 'PRAYER_ALARM',
      ),
    );

    await _notifications.zonedSchedule(
      snoozeId,
      'Prayer Reminder (Snoozed)',
      'Time for $alarmType - Snoozed reminder',
      tz.TZDateTime.from(snoozeTime, tz.local),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: '$alarmType|$snoozeId',
    );
  }

  static Future<void> _cancelCurrentAlarm(int alarmId) async {
    await _audioPlayer.stop();
    await _notifications.cancel(alarmId);
    await _notifications.cancel(_getSnoozeId(alarmId));

    if (Platform.isAndroid) {
      await AndroidAlarmManager.cancel(alarmId);
      await AndroidAlarmManager.cancel(_getSnoozeId(alarmId));
    }

    print('Alarm cancelled');
  }

  // Smart repeat logic - check if alarm should ring
  static Future<bool> _shouldRingAlarm(int alarmId) async {
    final prefs = await SharedPreferences.getInstance();
    final missCountKey = '$_alarmMissCountKey$alarmId';
    final lastAlarmKey = '$_lastAlarmTimeKey$alarmId';

    final missCount = prefs.getInt(missCountKey) ?? 0;
    final lastAlarmTime = prefs.getInt(lastAlarmKey) ?? 0;
    final today = DateTime.now().millisecondsSinceEpoch;
    final isNewDay =
        DateTime.fromMillisecondsSinceEpoch(lastAlarmTime).day !=
        DateTime.now().day;

    // Reset miss count for new day
    if (isNewDay) {
      await prefs.setInt(missCountKey, 0);
      await prefs.setInt(lastAlarmKey, today);
      return true;
    }

    // Don't ring if already missed max times today
    if (missCount >= maxMissedAlarms) {
      return false;
    }

    return true;
  }

  static Future<void> _incrementMissCount(int alarmId) async {
    final prefs = await SharedPreferences.getInstance();
    final missCountKey = '$_alarmMissCountKey$alarmId';
    final currentCount = prefs.getInt(missCountKey) ?? 0;
    await prefs.setInt(missCountKey, currentCount + 1);
    await prefs.setInt(
      '$_lastAlarmTimeKey$alarmId',
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  static Future<void> _resetMissCount(int alarmId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_alarmMissCountKey$alarmId', 0);
  }

  // Snooze time management
  static Future<void> setSnoozeTime(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_snoozeTimeKey, minutes);
  }

  static Future<int> getSnoozeTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_snoozeTimeKey) ?? defaultSnoozeMinutes;
  }

  // ---------------------- ANDROID ----------------------
  static Future<void> _scheduleAndroidAlarms() async {
    // Cancel existing alarms first
    await AndroidAlarmManager.cancel(morningAlarmId);
    await AndroidAlarmManager.cancel(noonAlarmId);
    await AndroidAlarmManager.cancel(eveningAlarmId);

    final now = DateTime.now();

    // Schedule Morning Prayer (6:00 AM)
    final morningTime = DateTime(now.year, now.month, now.day, 6, 0);
    final nextMorning =
        morningTime.isBefore(now) || morningTime.isAtSameMomentAs(now)
        ? morningTime.add(const Duration(days: 1))
        : morningTime;

    // Schedule Noon Prayer (12:00 PM)
    final noonTime = DateTime(now.year, now.month, now.day, 12, 0);
    final nextNoon = noonTime.isBefore(now) || noonTime.isAtSameMomentAs(now)
        ? noonTime.add(const Duration(days: 1))
        : noonTime;

    // Schedule Evening Prayer (6:00 PM)
    final eveningTime = DateTime(now.year, now.month, now.day, 18, 0);
    final nextEvening =
        eveningTime.isBefore(now) || eveningTime.isAtSameMomentAs(now)
        ? eveningTime.add(const Duration(days: 1))
        : eveningTime;

    try {
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
    } catch (e) {
      print('Error scheduling Android alarms: $e');
      // Fallback to notification-based alarms if AndroidAlarmManager fails
      await _scheduleAndroidNotificationAlarms();
    }
  }

  static Future<void> _scheduleAndroidNotificationAlarms() async {
    final now = DateTime.now();
    final prayerTimes = [
      {'hour': 6, 'label': 'Morning Prayer', 'id': morningAlarmId},
      {'hour': 12, 'label': 'Noon Prayer', 'id': noonAlarmId},
      {'hour': 18, 'label': 'Evening Prayer', 'id': eveningAlarmId},
    ];

    for (var prayer in prayerTimes) {
      var scheduledDate = DateTime(
        now.year,
        now.month,
        now.day,
        prayer['hour'] as int,
        0,
      );

      if (scheduledDate.isBefore(now) || scheduledDate.isAtSameMomentAs(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      final AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
            'prayer_alarm_channel',
            'Prayer Alarms',
            channelDescription: 'Notifications for prayer times',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/launcher_icon',
            sound: RawResourceAndroidNotificationSound(
              'cellphone_ringing_6475',
            ),
            playSound: true,
            enableVibration: true,
            vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
            fullScreenIntent: true,
            category: AndroidNotificationCategory.alarm,
            visibility: NotificationVisibility.public,
            actions: [
              AndroidNotificationAction(
                'snooze',
                'Snooze',
                cancelNotification: false,
              ),
              AndroidNotificationAction(
                'cancel',
                'Cancel',
                cancelNotification: true,
              ),
            ],
          );

      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await _notifications.zonedSchedule(
        prayer['id'] as int,
        'Prayer Time!',
        'It\'s time for ${prayer['label']}. Join Rev. Julian in this sacred moment.',
        tz.TZDateTime.from(scheduledDate, tz.local),
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: '${prayer['label']}|${prayer['id']}',
      );
    }
  }

  static Future<void> _scheduleAndroidDeeperPrayerAlarm() async {
    await AndroidAlarmManager.cancel(deeperPrayerAlarmId);

    final now = DateTime.now();
    final midnightTime = DateTime(now.year, now.month, now.day, 0, 0);
    final nextMidnight =
        midnightTime.isBefore(now) || midnightTime.isAtSameMomentAs(now)
        ? midnightTime.add(const Duration(days: 1))
        : midnightTime;

    try {
      await AndroidAlarmManager.oneShotAt(
        nextMidnight,
        deeperPrayerAlarmId,
        deeperPrayerAlarm,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true,
      );
    } catch (e) {
      print('Error scheduling deeper prayer alarm: $e');
      // Fallback to notification-based alarm
      await _scheduleAndroidDeeperPrayerNotification();
    }
  }

  static Future<void> _scheduleAndroidDeeperPrayerNotification() async {
    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day, 0, 0);

    if (scheduledDate.isBefore(now) || scheduledDate.isAtSameMomentAs(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'prayer_alarm_channel',
          'Prayer Alarms',
          channelDescription: 'Notifications for prayer times',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/launcher_icon',
          sound: RawResourceAndroidNotificationSound('cellphone_ringing_6475'),
          playSound: true,
          enableVibration: true,
          vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
          fullScreenIntent: true,
          category: AndroidNotificationCategory.alarm,
          visibility: NotificationVisibility.public,
          actions: [
            AndroidNotificationAction(
              'snooze',
              'Snooze',
              cancelNotification: false,
            ),
            AndroidNotificationAction(
              'cancel',
              'Cancel',
              cancelNotification: true,
            ),
          ],
        );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _notifications.zonedSchedule(
      deeperPrayerAlarmId,
      'Prayer Time!',
      'It\'s time for Deeper Prayer - Midnight Session. Join Rev. Julian in this sacred moment.',
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'Deeper Prayer - Midnight Session|$deeperPrayerAlarmId',
    );
  }

  // ---------------------- iOS + Linux ----------------------
  static Future<void> _scheduleDesktopAlarms() async {
    // Cancel only prayer alarm notifications, not all notifications
    await _notifications.cancel(morningAlarmId);
    await _notifications.cancel(noonAlarmId);
    await _notifications.cancel(eveningAlarmId);

    final prayerTimes = [
      {'hour': 6, 'label': 'Morning Prayer', 'id': morningAlarmId},
      {'hour': 12, 'label': 'Noon Prayer', 'id': noonAlarmId},
      {'hour': 18, 'label': 'Evening Prayer', 'id': eveningAlarmId},
    ];

    for (var prayer in prayerTimes) {
      try {
        await _scheduleDesktopNotification(
          prayer['id'] as int,
          prayer['label'] as String,
          prayer['hour'] as int,
        );
      } catch (e) {
        print('Error scheduling ${prayer['label']}: $e');
      }
    }
  }

  static Future<void> _scheduleDesktopDeeperPrayerAlarm() async {
    // Cancel existing deeper prayer notification
    await _notifications.cancel(deeperPrayerAlarmId);

    try {
      await _scheduleDesktopNotification(
        deeperPrayerAlarmId,
        'Deeper Prayer - Midnight Session',
        0, // Midnight
      );
    } catch (e) {
      print('Error scheduling deeper prayer alarm: $e');
    }
  }

  static Future<void> _scheduleDesktopNotification(
    int id,
    String prayerType,
    int hour,
  ) async {
    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day, hour, 0);

    // Schedule for next occurrence if time has passed
    if (scheduledDate.isBefore(now) || scheduledDate.isAtSameMomentAs(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          sound: 'cellphone-ringing-6475.mp3',
          interruptionLevel: InterruptionLevel.critical,
          categoryIdentifier: 'PRAYER_ALARM',
        );

    final LinuxNotificationDetails linuxPlatformChannelSpecifics =
        LinuxNotificationDetails(
          actions: const <LinuxNotificationAction>[
            LinuxNotificationAction(key: 'open', label: 'Open Prayer'),
            LinuxNotificationAction(key: 'dismiss', label: 'Dismiss'),
          ],
          urgency: LinuxNotificationUrgency.critical,
          timeout: LinuxNotificationTimeout.fromDuration(
            const Duration(minutes: 5),
          ),
        );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      iOS: iOSPlatformChannelSpecifics,
      linux: linuxPlatformChannelSpecifics,
    );

    try {
      await _notifications.zonedSchedule(
        id,
        'Prayer Time!',
        'It\'s time for $prayerType. Join Rev. Julian in this sacred moment.',
        tz.TZDateTime.from(scheduledDate, tz.local),
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: '$prayerType|$id',
      );
    } catch (e) {
      print(
        'Error scheduling notification for $prayerType at ${scheduledDate.toString()}: $e',
      );
      rethrow;
    }
  }

  // ---------------------- Cancel ----------------------
  static Future<void> _cancelRegularPrayerAlarms() async {
    if (Platform.isAndroid) {
      await AndroidAlarmManager.cancel(morningAlarmId);
      await AndroidAlarmManager.cancel(noonAlarmId);
      await AndroidAlarmManager.cancel(eveningAlarmId);
    } else {
      await _notifications.cancel(morningAlarmId);
      await _notifications.cancel(noonAlarmId);
      await _notifications.cancel(eveningAlarmId);
    }
  }

  static Future<void> _cancelDeeperPrayerAlarms() async {
    if (Platform.isAndroid) {
      await AndroidAlarmManager.cancel(deeperPrayerAlarmId);
    } else {
      await _notifications.cancel(deeperPrayerAlarmId);
    }
  }

  // ---------------------- Show immediate ----------------------
  static Future<void> _showPrayerNotification(String title, String body) async {
    if (Platform.isAndroid) {
      final AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
            'prayer_alarm_channel',
            'Prayer Alarms',
            channelDescription: 'Notifications for prayer times',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/launcher_icon',
            sound: RawResourceAndroidNotificationSound(
              'cellphone_ringing_6475',
            ),
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
    } else {
      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            sound: 'cellphone-ringing-6475.mp3',
            interruptionLevel: InterruptionLevel.critical,
          );

      const LinuxNotificationDetails linuxPlatformChannelSpecifics =
          LinuxNotificationDetails(
            actions: <LinuxNotificationAction>[
              LinuxNotificationAction(key: 'open', label: 'Open'),
            ],
          );

      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        iOS: iOSPlatformChannelSpecifics,
        linux: linuxPlatformChannelSpecifics,
      );

      await _notifications.show(0, title, body, platformChannelSpecifics);
    }
  }

  static Future<void> _playAlarmSound() async {
    try {
      await _audioPlayer.play(
        AssetSource('ringtons/cellphone-ringing-6475.mp3'),
        mode: PlayerMode.mediaPlayer,
      );

      await Future.delayed(const Duration(seconds: 30));
      await _audioPlayer.stop();
    } catch (e) {
      print('Error playing alarm sound: $e');
    }
  }

  static Future<void> triggerPrayerAlarm(
    String prayerType, [
    int? alarmId,
  ]) async {
    // Determine alarm ID if not provided
    alarmId ??= _getAlarmIdFromType(prayerType);

    // Check if alarm should ring (smart repeat logic)
    if (!await _shouldRingAlarm(alarmId)) {
      print('Alarm skipped: already missed $maxMissedAlarms times today');
      return;
    }

    // Start alarm sound and notification simultaneously
    await Future.wait([
      _playAlarmSoundWithTimeout(),
      _showPrayerNotificationWithActions(prayerType, alarmId),
    ]);

    // Auto-increment miss count after alarm duration if no interaction
    Timer(Duration(seconds: alarmDurationSeconds), () async {
      if (_audioPlayer.state == PlayerState.playing) {
        await _audioPlayer.stop();
        await _incrementMissCount(alarmId!);
        print('Alarm auto-stopped after $alarmDurationSeconds seconds');
      }
    });
  }

  static int _getAlarmIdFromType(String prayerType) {
    if (prayerType.contains('Morning')) return morningAlarmId;
    if (prayerType.contains('Noon')) return noonAlarmId;
    if (prayerType.contains('Evening')) return eveningAlarmId;
    if (prayerType.contains('Deeper')) return deeperPrayerAlarmId;
    return morningAlarmId; // Default
  }

  static Future<void> _playAlarmSoundWithTimeout() async {
    try {
      await _audioPlayer.play(
        AssetSource('ringtons/cellphone-ringing-6475.mp3'),
        mode: PlayerMode.mediaPlayer,
      );

      // Auto-stop after timeout
      Timer(Duration(seconds: alarmDurationSeconds), () async {
        if (_audioPlayer.state == PlayerState.playing) {
          await _audioPlayer.stop();
        }
      });
    } catch (e) {
      print('Error playing alarm sound: $e');
    }
  }

  static Future<void> _showPrayerNotificationWithActions(
    String prayerType,
    int alarmId,
  ) async {
    if (Platform.isAndroid) {
      final AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
            'prayer_alarm_channel',
            'Prayer Alarms',
            channelDescription: 'Notifications for prayer times',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/launcher_icon',
            sound: RawResourceAndroidNotificationSound(
              'cellphone_ringing_6475',
            ),
            playSound: true,
            enableVibration: true,
            vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
            fullScreenIntent: true,
            category: AndroidNotificationCategory.alarm,
            visibility: NotificationVisibility.public,
            actions: [
              AndroidNotificationAction(
                'snooze',
                'Snooze',
                cancelNotification: false,
              ),
              AndroidNotificationAction(
                'cancel',
                'Cancel',
                cancelNotification: true,
              ),
            ],
            ongoing: true, // Keep notification until user interacts
            autoCancel: false,
          );

      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await _notifications.show(
        alarmId,
        'Prayer Time!',
        'It\'s time for $prayerType. Join Rev. Julian in this sacred moment.',
        platformChannelSpecifics,
        payload: '$prayerType|$alarmId',
      );
    } else {
      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            sound: 'cellphone-ringing-6475.mp3',
            interruptionLevel: InterruptionLevel.critical,
            categoryIdentifier: 'PRAYER_ALARM',
          );

      final LinuxNotificationDetails linuxPlatformChannelSpecifics =
          LinuxNotificationDetails(
            actions: const <LinuxNotificationAction>[
              LinuxNotificationAction(key: 'snooze', label: 'Snooze'),
              LinuxNotificationAction(key: 'cancel', label: 'Cancel'),
            ],
            urgency: LinuxNotificationUrgency.critical,
            timeout: LinuxNotificationTimeout.fromDuration(
              const Duration(minutes: 5),
            ),
          );

      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        iOS: iOSPlatformChannelSpecifics,
        linux: linuxPlatformChannelSpecifics,
      );

      await _notifications.show(
        alarmId,
        'Prayer Time!',
        'It\'s time for $prayerType. Join Rev. Julian in this sacred moment.',
        platformChannelSpecifics,
        payload: '$prayerType|$alarmId',
      );
    }
  }

  static Future<void> cancelAllAlarms() async {
    if (Platform.isAndroid) {
      await AndroidAlarmManager.cancel(morningAlarmId);
      await AndroidAlarmManager.cancel(noonAlarmId);
      await AndroidAlarmManager.cancel(eveningAlarmId);
      await AndroidAlarmManager.cancel(deeperPrayerAlarmId);
    } else {
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

    final tomorrow = now.add(const Duration(days: 1));
    return '${DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 6, 0).hour.toString().padLeft(2, '0')}:00';
  }
}

// ---------------------- Top-level callbacks ----------------------
@pragma('vm:entry-point')
void morningPrayerAlarm() async {
  try {
    await AlarmService.triggerPrayerAlarm(
      'Morning Prayer',
      AlarmService.morningAlarmId,
    );

    // Reschedule for next day
    final nextMorning = DateTime.now()
        .add(const Duration(days: 1))
        .copyWith(
          hour: 6,
          minute: 0,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        );

    await AndroidAlarmManager.oneShotAt(
      nextMorning,
      AlarmService.morningAlarmId,
      morningPrayerAlarm,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
  } catch (e) {
    print('Error in morning prayer alarm: $e');
  }
}

@pragma('vm:entry-point')
void noonPrayerAlarm() async {
  try {
    await AlarmService.triggerPrayerAlarm(
      'Noon Prayer',
      AlarmService.noonAlarmId,
    );

    // Reschedule for next day
    final nextNoon = DateTime.now()
        .add(const Duration(days: 1))
        .copyWith(
          hour: 12,
          minute: 0,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        );

    await AndroidAlarmManager.oneShotAt(
      nextNoon,
      AlarmService.noonAlarmId,
      noonPrayerAlarm,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
  } catch (e) {
    print('Error in noon prayer alarm: $e');
  }
}

@pragma('vm:entry-point')
void eveningPrayerAlarm() async {
  try {
    await AlarmService.triggerPrayerAlarm(
      'Evening Prayer',
      AlarmService.eveningAlarmId,
    );

    // Reschedule for next day
    final nextEvening = DateTime.now()
        .add(const Duration(days: 1))
        .copyWith(
          hour: 18,
          minute: 0,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        );

    await AndroidAlarmManager.oneShotAt(
      nextEvening,
      AlarmService.eveningAlarmId,
      eveningPrayerAlarm,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
  } catch (e) {
    print('Error in evening prayer alarm: $e');
  }
}

@pragma('vm:entry-point')
void deeperPrayerAlarm() async {
  try {
    await AlarmService.triggerPrayerAlarm(
      'Deeper Prayer - Midnight Session',
      AlarmService.deeperPrayerAlarmId,
    );

    // Reschedule for next day
    final nextMidnight = DateTime.now()
        .add(const Duration(days: 1))
        .copyWith(
          hour: 0,
          minute: 0,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        );

    await AndroidAlarmManager.oneShotAt(
      nextMidnight,
      AlarmService.deeperPrayerAlarmId,
      deeperPrayerAlarm,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
  } catch (e) {
    print('Error in deeper prayer alarm: $e');
  }
}
