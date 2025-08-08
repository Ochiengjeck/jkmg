import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/api_providers.dart';
import 'deeper_prayer.dart';
import 'prayer_schedule.dart';
import 'request_prayer.dart';

class PrayerPlanScreen extends ConsumerWidget {
  const PrayerPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleAsync = ref.watch(prayerScheduleProvider);
    final deeperInfoAsync = ref.watch(deeperPrayerInfoProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(prayerScheduleProvider);
            ref.invalidate(deeperPrayerInfoProvider);
          },
          color: const Color(0xFFB8860B),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                deeperInfoAsync.when(
                  data: (deeperInfo) => DeeperPrayer(
                    deeperPrayerInfo: deeperInfo,
                    isLoading: false,
                    onDeeperPrayerRecorded: () {
                      ref.invalidate(deeperPrayerInfoProvider);
                      ref.invalidate(prayerScheduleProvider);
                    },
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFB8860B),
                      ),
                    ),
                  ),
                  error: (e, _) => Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 32),
                        Text(
                          'Error loading deeper prayer info: $e',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(color: Colors.red),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () =>
                              ref.invalidate(deeperPrayerInfoProvider),
                          child: const Text(
                            'Retry',
                            style: TextStyle(
                              color: Color(0xFFB8860B),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                scheduleAsync.when(
                  data: (schedule) => PrayerSchedule(
                    prayerSchedule: deeperInfoAsync.value,
                    isLoading: false,
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFB8860B),
                      ),
                    ),
                  ),
                  error: (e, _) => Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 32),
                        Text(
                          'Error loading schedule: $e',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(color: Colors.red),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () =>
                              ref.invalidate(prayerScheduleProvider),
                          child: const Text(
                            'Retry',
                            style: TextStyle(
                              color: Color(0xFFB8860B),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                RequestPrayer(
                  onPrayerRequestSubmitted: () {
                    ref.invalidate(prayerScheduleProvider);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
