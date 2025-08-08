import 'package:flutter/material.dart';
import '../../models/prayer.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

class PrayerSchedule extends StatelessWidget {
  final DeeperPrayerInfo? prayerSchedule;
  final bool isLoading;

  const PrayerSchedule({
    super.key,
    required this.prayerSchedule,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGold),
        ),
      );
    }

    if (prayerSchedule == null) {
      return CustomCard(
        child: Column(
          children: [
            Icon(
              Icons.schedule,
              size: 48,
              color: Colors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'No prayer schedule available',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    final activePrayer = prayerSchedule!.todayParticipation;
    final completedPrayers = prayerSchedule!.recentParticipations;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildScheduleInfo(context),
        const SizedBox(height: 16),
        _buildPrayerTimes(context),
        const SizedBox(height: 16),
        if (activePrayer != null) ...
          _buildActivePrayerSection(context, activePrayer),
        if (completedPrayers?.isNotEmpty == true) ...
          _buildCompletedPrayersSection(context, completedPrayers!),
        if (activePrayer == null && (completedPrayers?.isEmpty != false))
          _buildEmptyState(context),
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
      {'time': '6:00 AM', 'icon': Icons.wb_sunny, 'label': 'Morning Prayer'},
      {'time': '12:00 PM', 'icon': Icons.wb_sunny_outlined, 'label': 'Noon Prayer'},
      {'time': '6:00 PM', 'icon': Icons.wb_twilight, 'label': 'Evening Prayer'},
    ];

    return Row(
      children: prayerTimes.map((prayer) {
        final index = prayerTimes.indexOf(prayer);
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              right: index < prayerTimes.length - 1 ? 8 : 0,
            ),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.accentGold.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.primaryGold.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Icon(
                  prayer['icon'] as IconData,
                  color: AppTheme.primaryGold,
                  size: 20,
                ),
                const SizedBox(height: 6),
                Text(
                  prayer['time'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.deepGold,
                  ),
                ),
                Text(
                  prayer['label'] as String,
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  List<Widget> _buildActivePrayerSection(BuildContext context, DeeperPrayerParticipation activePrayer) {
    return [
      const SizedBox(height: 20),
      Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppTheme.successGreen.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.play_circle_filled,
              color: AppTheme.successGreen,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Active Prayer Session',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.successGreen,
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      _buildPrayerCard(context, activePrayer, true),
    ];
  }

  List<Widget> _buildCompletedPrayersSection(BuildContext context, List<DeeperPrayerParticipation> completedPrayers) {
    return [
      const SizedBox(height: 20),
      Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.check_circle,
              color: Colors.grey.shade600,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Recent Prayer History',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      ...completedPrayers.take(3).map(
        (prayer) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: _buildPrayerCard(context, prayer, false),
        ),
      ),
    ];
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
            onPressed: () {
              // TODO: Navigate to prayer setup or info screen
            },
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
            child: Icon(
              statusIcon,
              color: statusColor,
              size: 20,
            ),
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
