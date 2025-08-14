import 'package:flutter/material.dart';
import '../../models/prayer.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import '../../services/alarm_service.dart';

class PrayerSchedule extends StatefulWidget {
  final DeeperPrayerInfo? prayerSchedule;
  final bool isLoading;

  const PrayerSchedule({
    super.key,
    required this.prayerSchedule,
    required this.isLoading,
  });

  @override
  State<PrayerSchedule> createState() => _PrayerScheduleState();
}

class _PrayerScheduleState extends State<PrayerSchedule> {
  final alarmtone = AudioPlayer();
  String? _nextAlarmTime;
  bool _alarmsScheduled = false;
  bool _prayerAlarmsEnabled = true;
  bool _deeperPrayerAlarmsEnabled = true;

  @override
  void initState() {
    super.initState();
    _initializeAlarms();
  }

  @override
  void dispose() {
    alarmtone.dispose();
    super.dispose();
  }

  Future<void> _initializeAlarms() async {
    // Load alarm preferences
    final prayerAlarmsEnabled = await AlarmService.arePrayerAlarmsEnabled();
    final deeperPrayerAlarmsEnabled = await AlarmService.areDeeperPrayerAlarmsEnabled();
    
    await AlarmService.schedulePrayerAlarms();
    setState(() {
      _nextAlarmTime = AlarmService.getNextAlarmTime();
      _alarmsScheduled = true;
      _prayerAlarmsEnabled = prayerAlarmsEnabled;
      _deeperPrayerAlarmsEnabled = deeperPrayerAlarmsEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGold),
        ),
      );
    }

    if (widget.prayerSchedule == null) {
      return CustomCard(
        child: Column(
          children: [
            Icon(Icons.schedule, size: 48, color: Colors.grey.withOpacity(0.5)),
            const SizedBox(height: 16),
            const Text(
              'No prayer schedule available',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildScheduleInfo(context),
        const SizedBox(height: 16),
        _buildPrayerTimes(context),
        const SizedBox(height: 16),
        _buildTestAlarmButton(context),
        const SizedBox(height: 16),
        _buildAlarmSettings(context),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildScheduleInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryGold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryGold.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.notifications_active,
            color: AppTheme.primaryGold,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Prayer Notifications',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.deepGold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'You\'ll receive notifications every 6 hours to join Rev. Julian in prayer',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerTimes(BuildContext context) {
    final prayerTimes = [
      {
        'time': '6:00 AM',
        'hour': 6,
        'icon': Icons.wb_sunny,
        'label': 'Morning Prayer',
      },
      {
        'time': '12:00 PM',
        'hour': 12,
        'icon': Icons.wb_sunny_outlined,
        'label': 'Noon Prayer',
      },
      {
        'time': '6:00 PM',
        'hour': 18,
        'icon': Icons.wb_twilight,
        'label': 'Evening Prayer',
      },
    ];

    final currentHour = DateTime.now().hour;

    return Row(
      children: prayerTimes.map((prayer) {
        final index = prayerTimes.indexOf(prayer);
        final prayerHour = prayer['hour'] as int;
        final isActive = _isPrayerTimeActive(prayerHour, currentHour);

        return Expanded(
          child: GestureDetector(
            onTap: () => _onPrayerTimeClicked(context, prayer, isActive),
            child: Container(
              margin: EdgeInsets.only(
                right: index < prayerTimes.length - 1 ? 8 : 0,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isActive
                    ? AppTheme.primaryGold.withOpacity(0.2)
                    : AppTheme.accentGold.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isActive
                      ? AppTheme.primaryGold
                      : AppTheme.primaryGold.withOpacity(0.2),
                  width: isActive ? 2 : 1,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryGold.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: Column(
                children: [
                  Icon(
                    prayer['icon'] as IconData,
                    color: isActive
                        ? AppTheme.primaryGold
                        : AppTheme.primaryGold.withOpacity(0.6),
                    size: isActive ? 24 : 20,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    prayer['time'] as String,
                    style: TextStyle(
                      fontSize: isActive ? 13 : 12,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                      color: isActive
                          ? AppTheme.deepGold
                          : AppTheme.deepGold.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    prayer['label'] as String,
                    style: TextStyle(
                      fontSize: 9,
                      color: isActive
                          ? AppTheme.primaryGold
                          : Colors.grey.shade600,
                      fontWeight: isActive
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (isActive) ...[
                    const SizedBox(height: 4),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryGold,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return CustomCard(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryGold.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.schedule,
              size: 32,
              color: AppTheme.primaryGold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Prayer Sessions Yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.deepGold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your prayer sessions will appear here once you start participating in the Rhema Prayer Plan',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showGetStartedDialog(context),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Get Started'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGold,
              foregroundColor: AppTheme.richBlack,
            ),
          ),
        ],
      ),
    );
  }

  bool _isPrayerTimeActive(int prayerHour, int currentHour) {
    // Prayer is active from the scheduled hour to the next scheduled hour
    if (prayerHour == 6) {
      return currentHour >= 6 && currentHour < 12;
    } else if (prayerHour == 12) {
      return currentHour >= 12 && currentHour < 18;
    } else if (prayerHour == 18) {
      return currentHour >= 18 || currentHour < 6;
    }
    return false;
  }

  void _onPrayerTimeClicked(
    BuildContext context,
    Map<String, dynamic> prayer,
    bool isActive,
  ) {
    if (isActive) {
      _playPrayerAudio(context, prayer);
    } else {
      _showInactivePrayerDialog(context, prayer);
    }
  }

  void _playPrayerAudio(BuildContext context, Map<String, dynamic> prayer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.play_circle_filled,
                  color: AppTheme.primaryGold,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${prayer['label']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryGold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Playing prayer audio...',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.volume_up,
                      color: AppTheme.primaryGold,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Audio is now playing...',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryGold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await alarmtone.stop();
                Navigator.pop(context);
              },
              child: const Text('Stop', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await alarmtone.play(
                    AssetSource('ringtons/cellphone-ringing-6475.mp3'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Prayer sound started playing...'),
                      backgroundColor: AppTheme.primaryGold,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error playing sound: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGold,
                foregroundColor: AppTheme.richBlack,
              ),
              child: const Text('Play Sound'),
            ),
          ],
        );
      },
    );
  }

  void _showInactivePrayerDialog(
    BuildContext context,
    Map<String, dynamic> prayer,
  ) {
    showDialog(
      context: context,

      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.access_time,
                  color: Colors.orange,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Prayer Time Inactive',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'The ${prayer['label']} is currently inactive.',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.notifications_active,
                      color: AppTheme.primaryGold,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Find this prayer in your notifications when it\'s time!',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryGold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGold,
                foregroundColor: AppTheme.richBlack,
              ),
              child: const Text('Got it'),
            ),
          ],
        );
      },
    );
  }

  void _showGetStartedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.lightbulb_outline,
                  color: AppTheme.primaryGold,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Get Started Guide',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryGold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome to the Rhema Prayer Plan! Here\'s how to get started:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              _buildGuideStep(
                '1',
                'Scroll to Deeper Prayer Section',
                'Scroll down to the "Deeper in Prayer" section at the bottom of this page to explore comprehensive prayer resources.',
                Icons.arrow_downward,
              ),
              const SizedBox(height: 12),
              _buildGuideStep(
                '2',
                'Submit Prayer Participation',
                'Submit today\'s prayer participation to join our global prayer community and track your spiritual journey.',
                Icons.favorite,
              ),
              const SizedBox(height: 12),
              _buildGuideStep(
                '3',
                'Follow Daily Schedule',
                'Return here daily to follow your personalized 6-hour prayer schedule guided by Rev. Julian.',
                Icons.schedule,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primaryGold.withOpacity(0.3),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: AppTheme.primaryGold,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Start your transformative prayer journey today!',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryGold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Later', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.arrow_downward, color: Colors.white),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Scroll down to find the "Deeper in Prayer" section!',
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: AppTheme.primaryGold,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    duration: const Duration(seconds: 4),
                  ),
                );
              },
              icon: const Icon(Icons.rocket_launch, size: 16),
              label: const Text('Let\'s Go!'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGold,
                foregroundColor: AppTheme.richBlack,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _testAlarm() async {
    await AlarmService.triggerPrayerAlarm('Test Prayer');
  }

  Widget _buildAlarmSettings(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryGold.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryGold.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.settings, color: AppTheme.primaryGold, size: 24),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Alarm Settings',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryGold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Regular Prayer Alarms Toggle
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _prayerAlarmsEnabled 
                  ? AppTheme.successGreen.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _prayerAlarmsEnabled 
                    ? AppTheme.successGreen.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: _prayerAlarmsEnabled ? AppTheme.successGreen : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Regular Prayer Alarms',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '6AM, 12PM, 6PM daily alarms',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _prayerAlarmsEnabled,
                  onChanged: _alarmsScheduled ? (value) async {
                    if (value) {
                      await AlarmService.enablePrayerAlarms();
                    } else {
                      await AlarmService.disablePrayerAlarms();
                    }
                    await _initializeAlarms();
                  } : null,
                  activeColor: AppTheme.primaryGold,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Deeper Prayer Alarms Toggle
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _deeperPrayerAlarmsEnabled 
                  ? AppTheme.accentGold.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _deeperPrayerAlarmsEnabled 
                    ? AppTheme.accentGold.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.nightlight_round,
                  color: _deeperPrayerAlarmsEnabled ? AppTheme.accentGold : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Deeper Prayer Alarms',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Midnight prayer session (12:00 AM)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _deeperPrayerAlarmsEnabled,
                  onChanged: _alarmsScheduled ? (value) async {
                    if (value) {
                      await AlarmService.enableDeeperPrayerAlarms();
                    } else {
                      await AlarmService.disableDeeperPrayerAlarms();
                    }
                    await _initializeAlarms();
                  } : null,
                  activeColor: AppTheme.accentGold,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Disable All Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _alarmsScheduled ? () async {
                await AlarmService.cancelAllAlarms();
                await AlarmService.disablePrayerAlarms();
                await AlarmService.disableDeeperPrayerAlarms();
                await _initializeAlarms();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All prayer alarms have been disabled'),
                    backgroundColor: Colors.red,
                  ),
                );
              } : null,
              icon: const Icon(Icons.notifications_off, size: 20),
              label: const Text('Disable All Alarms'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                disabledBackgroundColor: Colors.grey.shade300,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestAlarmButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.alarm, color: Colors.blue, size: 24),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'System Alarm Test',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ),
              if (_nextAlarmTime != null && _alarmsScheduled)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Next: $_nextAlarmTime',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryGold,
                    ),
                  ),
                ),
              if (!_alarmsScheduled)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Setting up...',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _alarmsScheduled ? () => _testAlarm() : null,
                  icon: const Icon(Icons.notification_important, size: 20),
                  label: const Text('Test System Alarm'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    disabledBackgroundColor: Colors.grey.shade300,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _alarmsScheduled ? () async {
                  await AlarmService.cancelAllAlarms();
                  await _initializeAlarms();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Alarms reset and rescheduled'),
                      backgroundColor: AppTheme.primaryGold,
                    ),
                  );
                } : null,
                icon: const Icon(Icons.refresh, size: 20),
                label: const Text('Reset'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGuideStep(
    String number,
    String title,
    String description,
    IconData icon,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppTheme.primaryGold,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: AppTheme.richBlack,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: AppTheme.primaryGold, size: 16),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryGold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrayerCard(
    BuildContext context,
    DeeperPrayerParticipation prayer,
    bool isActive,
  ) {
    final statusColor = isActive ? AppTheme.primaryGold : AppTheme.successGreen;
    final statusIcon = isActive ? Icons.schedule : Icons.check_circle;
    final statusText = isActive ? 'In Progress' : 'Completed';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(statusIcon, color: statusColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Prayer Session',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Duration: ${prayer.duration} minutes',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Date: ${prayer.date}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
