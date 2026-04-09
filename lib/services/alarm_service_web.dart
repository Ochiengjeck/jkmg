// Web stub for AlarmService - notifications/alarms not supported on web
class AlarmService {
  static const int morningAlarmId = 1;
  static const int noonAlarmId = 2;
  static const int eveningAlarmId = 3;
  static const int deeperPrayerAlarmId = 4;

  static const int morningSnoozeId = 101;
  static const int noonSnoozeId = 102;
  static const int eveningSnoozeId = 103;
  static const int deeperPrayerSnoozeId = 104;

  static const int defaultSnoozeMinutes = 5;
  static const int maxMissedAlarms = 2;
  static const int alarmDurationSeconds = 30;

  static Future<void> initialize() async {}
  static Future<void> schedulePrayerAlarms() async {}
  static Future<void> enablePrayerAlarms() async {}
  static Future<void> disablePrayerAlarms() async {}
  static Future<void> enableDeeperPrayerAlarms() async {}
  static Future<void> disableDeeperPrayerAlarms() async {}
  static Future<bool> arePrayerAlarmsEnabled() async => false;
  static Future<bool> areDeeperPrayerAlarmsEnabled() async => false;
  static Future<void> setSnoozeTime(int minutes) async {}
  static Future<int> getSnoozeTime() async => defaultSnoozeMinutes;
  static Future<void> cancelAllAlarms() async {}
  static Future<void> triggerPrayerAlarm(String prayerType, [int? alarmId]) async {}

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
