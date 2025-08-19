import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jkmg/provider/api_providers.dart';
import 'package:jkmg/models/prayer.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';
import 'package:audioplayers/audioplayers.dart';

class DeeperPrayer extends StatefulWidget {
  final DeeperPrayerInfo? deeperPrayerInfo;
  final bool isLoading;
  final VoidCallback onDeeperPrayerRecorded;

  const DeeperPrayer({
    super.key,
    required this.deeperPrayerInfo,
    required this.isLoading,
    required this.onDeeperPrayerRecorded,
  });

  @override
  State<DeeperPrayer> createState() => _DeeperPrayerState();
}

class _DeeperPrayerState extends State<DeeperPrayer> {
  int? _selectedDuration;
  bool _isSubmitting = false;
  bool _isPlaying = false;
  final List<int> _availableDurations = [30, 60];
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isMidnightHour() {
    final now = DateTime.now();
    return now.hour >= 0 && now.hour < 1; // Midnight to 1 AM
  }

  Future<void> _playPrayer() async {
    if (_selectedDuration == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a duration')));
      return;
    }

    if (!_isMidnightHour()) {
      return; // Button should be disabled during non-midnight hours
    }

    setState(() {
      _isPlaying = true;
      _isSubmitting = true;
    });

    try {
      // Simulate playing audio based on selected duration
      // In a real implementation, you would play the actual audio file
      await Future.delayed(Duration(seconds: 3)); // Simulate audio loading

      // Record the prayer participation
      await ProviderScope.containerOf(context).read(
        participateInDeeperPrayerProvider({
          'duration': _selectedDuration!,
          'notes': null,
        }).future,
      );

      setState(() {
        _isSubmitting = false;
        _isPlaying = false;
        _selectedDuration = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Prayer completed and recorded successfully'),
        ),
      );

      widget.onDeeperPrayerRecorded();
    } catch (e) {
      setState(() {
        _isSubmitting = false;
        _isPlaying = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error playing prayer: $e')));
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todayParticipation = widget.deeperPrayerInfo?.todayParticipation;
    final totalCompleted =
        widget.deeperPrayerInfo?.recentParticipations.length ?? 0;
    final isTodayCompleted = todayParticipation?.completed == true;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildIntroText(context),
          const SizedBox(height: 16),
          _buildStatsSection(context, totalCompleted, todayParticipation),
          if (isTodayCompleted)
            ..._buildCompletedState(context)
          else
            ..._buildActiveState(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryGold.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.nightlight_round,
            color: AppTheme.primaryGold,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Deeper in Prayer',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.deepGold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIntroText(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.richBlack.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'As the name suggests, this feature is designed to facilitate a powerful midnight prayer session from 12:00 AM to 1:00 AM (local time), for users seeking spiritual growth and a deeper encounter with God.',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey,
          height: 1.4,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildStatsSection(
    BuildContext context,
    int totalCompleted,
    DeeperPrayerParticipation? todayParticipation,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Sessions',
            totalCompleted.toString(),
            Icons.check_circle_outline,
            AppTheme.successGreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Today\'s Status',
            todayParticipation?.completed == true ? 'Completed' : 'Pending',
            todayParticipation?.completed == true
                ? Icons.check_circle
                : Icons.schedule,
            todayParticipation?.completed == true
                ? AppTheme.successGreen
                : AppTheme.primaryGold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCompletedState(BuildContext context) {
    return [
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.successGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.successGreen.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: AppTheme.successGreen,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'You have already completed today\'s deeper prayer session. Thank you for your faithful participation!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.successGreen,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildActiveState(BuildContext context) {
    final isMidnight = _isMidnightHour();

    return [
      const SizedBox(height: 16),
      Text(
        'Midnight Prayer Session',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppTheme.deepGold,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 12),
      DropdownButtonFormField<int>(
        decoration: InputDecoration(
          labelText: 'Prayer Duration (minutes)',
          labelStyle: const TextStyle(color: AppTheme.primaryGold),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.primaryGold),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppTheme.primaryGold.withOpacity(0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.primaryGold, width: 2),
          ),
          prefixIcon: const Icon(Icons.timer, color: AppTheme.primaryGold),
        ),
        value: _selectedDuration,
        items: _availableDurations
            .map(
              (duration) => DropdownMenuItem(
                value: duration,
                child: Text('$duration minutes'),
              ),
            )
            .toList(),
        onChanged: (widget.isLoading || _isSubmitting)
            ? null
            : (value) => setState(() => _selectedDuration = value),
      ),
      if (!isMidnight) ...[
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.access_time, color: Colors.orange, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Last night\'s prayer is in your inbox. Prayer is only available from midnight to 1:00 AM.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      const SizedBox(height: 20),
      SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton.icon(
          onPressed: (widget.isLoading || _isSubmitting || !isMidnight)
              ? null
              : _playPrayer,
          icon: _isPlaying
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: AppTheme.richBlack,
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.play_arrow),
          label: Text(
            _isPlaying
                ? 'Playing Prayer...'
                : isMidnight
                ? 'Pray Now'
                : 'Prayer Unavailable',
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: isMidnight ? AppTheme.primaryGold : Colors.grey,
            foregroundColor: isMidnight ? AppTheme.richBlack : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    ];
  }
}
