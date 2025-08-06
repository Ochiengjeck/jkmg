import 'package:flutter/material.dart';

class PrayerSchedule extends StatelessWidget {
  final Map<String, dynamic>? prayerSchedule;
  final bool isLoading;

  const PrayerSchedule({
    super.key,
    required this.prayerSchedule,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final activePrayers = prayerSchedule?['active_prayers'] ?? [];
    final completedPrayers = prayerSchedule?['completed_prayers'] ?? [];
    final prayerTimes = prayerSchedule?['prayer_times'] ?? [];
    final userTimezone = prayerSchedule?['user_timezone'] ?? 'Unknown';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Prayer Schedule',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFFB8860B),
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Text(
          'Prayer Times ($userTimezone): ${prayerTimes.join(", ")}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black87,
              ),
        ),
        const SizedBox(height: 16),
        if (activePrayers.isNotEmpty) ...[
          Text(
            'Active Prayers',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: const Color(0xFFB8860B),
                ),
          ),
          const SizedBox(height: 8),
          ...activePrayers.map<Widget>((prayer) => _buildPrayerCard(context, prayer, true)),
        ],
        const SizedBox(height: 16),
        if (completedPrayers.isNotEmpty) ...[
          Text(
            'Completed Prayers',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: const Color(0xFFB8860B),
                ),
          ),
          const SizedBox(height: 8),
          ...completedPrayers.map<Widget>((prayer) => _buildPrayerCard(context, prayer, false)),
        ],
      ],
    );
  }

  Widget _buildPrayerCard(BuildContext context, Map<String, dynamic> prayer, bool isActive) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: const Color(0xFFB8860B).withOpacity(0.3)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          prayer['category']['label'],
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(0xFFB8860B),
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'From: ${prayer['start_date']} to ${prayer['end_date']}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black87,
                  ),
            ),
            Text(
              isActive ? 'Days Remaining: ${prayer['days_remaining']}' : 'Completed',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isActive ? Colors.green : Colors.grey,
                  ),
            ),
          ],
        ),
        trailing: Icon(
          isActive ? Icons.access_time : Icons.check_circle,
          color: isActive ? const Color(0xFFB8860B) : Colors.green,
        ),
      ),
    );
  }
}