import 'package:flutter/material.dart';
import '../services/alarm_service.dart';
import '../utils/app_theme.dart';

class AlarmSettingsDialog extends StatefulWidget {
  const AlarmSettingsDialog({super.key});

  @override
  State<AlarmSettingsDialog> createState() => _AlarmSettingsDialogState();
}

class _AlarmSettingsDialogState extends State<AlarmSettingsDialog> {
  int _snoozeMinutes = 5;
  bool _isLoading = true;
  
  final List<int> _snoozeOptions = [1, 2, 5, 10, 15, 20, 30];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final snoozeTime = await AlarmService.getSnoozeTime();
    setState(() {
      _snoozeMinutes = snoozeTime;
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    await AlarmService.setSnoozeTime(_snoozeMinutes);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alarm settings saved successfully'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const AlertDialog(
        content: SizedBox(
          height: 100,
          child: Center(
            child: CircularProgressIndicator(color: AppTheme.primaryGold),
          ),
        ),
      );
    }

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
              Icons.alarm,
              color: AppTheme.primaryGold,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Alarm Settings',
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
            'Snooze Duration',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primaryGold.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Minutes:', style: TextStyle(fontSize: 14)),
                    Text(
                      '$_snoozeMinutes min',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryGold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _snoozeOptions.map((minutes) {
                    final isSelected = minutes == _snoozeMinutes;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _snoozeMinutes = minutes;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryGold
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryGold
                                : AppTheme.primaryGold.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          '${minutes}m',
                          style: TextStyle(
                            color: isSelected
                                ? AppTheme.richBlack
                                : AppTheme.primaryGold,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.successGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.info, color: AppTheme.successGreen, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Alarms will automatically stop ringing after 30 seconds if not acknowledged.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.successGreen,
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
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton.icon(
          onPressed: _saveSettings,
          icon: const Icon(Icons.save, size: 16),
          label: const Text('Save Settings'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryGold,
            foregroundColor: AppTheme.richBlack,
          ),
        ),
      ],
    );
  }
}