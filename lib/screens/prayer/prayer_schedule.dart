import 'package:flutter/material.dart';
import '../../models/prayer.dart';

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
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB8860B)),
        ),
      );
    }

    if (prayerSchedule == null) {
      return const Center(
        child: Text(
          'No prayer schedule available',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    final activePrayer = prayerSchedule!.todayParticipation;
    final completedPrayers = prayerSchedule!.recentParticipations ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Prayer Schedule',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: const Color(0xFFB8860B),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Stay committed to your spiritual journey',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          if (activePrayer != null) ...[
            Text(
              'Active Prayer',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFFB8860B),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildPrayerCard(context, activePrayer, true),
            const SizedBox(height: 24),
          ],
          if (completedPrayers.isNotEmpty) ...[
            Text(
              'Completed Prayers',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFFB8860B),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ...completedPrayers.map(
              (prayer) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildPrayerCard(context, prayer, false),
              ),
            ),
          ],
          if (activePrayer == null && completedPrayers.isEmpty)
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  Icon(
                    Icons.hourglass_empty,
                    size: 48,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No prayers scheduled yet',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to prayer creation screen
                    },
                    child: const Text(
                      'Start a New Prayer',
                      style: TextStyle(
                        color: Color(0xFFB8860B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
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
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: const Color(0xFFB8860B).withOpacity(0.2)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          // prayer.category?.label ?? 'Prayer',
          'prayer',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: const Color(0xFFB8860B),
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'From: ${prayer.date} to ${prayer.completedAt}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isActive
                  ? 'Duration: ${prayer.duration} minutes'
                  : 'Completed: ${prayer.completedAt ?? 'Unknown'}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isActive ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
        trailing: Icon(
          isActive ? Icons.access_time : Icons.check_circle,
          color: isActive ? const Color(0xFFB8860B) : Colors.green,
          size: 28,
        ),
        onTap: () {
          // TODO: Navigate to prayer details screen
        },
      ),
    );
  }
}
