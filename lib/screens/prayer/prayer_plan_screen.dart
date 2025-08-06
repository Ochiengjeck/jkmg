import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/api_providers.dart';
import 'deeper_prayer.dart';
import 'prayer_schedule.dart';
import 'request_prayer.dart'; // Hypothetical API service

class PrayerPlanScreen extends ConsumerStatefulWidget {
  const PrayerPlanScreen({super.key});

  @override
  ConsumerState<PrayerPlanScreen> createState() => _PrayerPlanScreenState();
}

class _PrayerPlanScreenState extends ConsumerState<PrayerPlanScreen> {
  bool _isLoading = false;
  Map<String, dynamic>? _prayerSchedule;
  Map<String, dynamic>? _deeperPrayerInfo;

  @override
  void initState() {
    super.initState();
    // _fetchPrayerData();
  }

  // Future<void> _fetchPrayerData() async {
  //   setState(() => _isLoading = true);
  //   try {
  //     final schedule = await ApiService.getPrayerSchedule();
  //     final deeperInfo = await ApiService.getDeeperPrayerInfo();
  //     setState(() {
  //       _prayerSchedule = schedule;
  //       _deeperPrayerInfo = deeperInfo;
  //       _isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() => _isLoading = false);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error fetching prayer data: $e')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final name = ref.watch(prayerScheduleProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                PrayerSchedule(
                  prayerSchedule: _prayerSchedule,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 24),
                DeeperPrayer(
                  deeperPrayerInfo: _deeperPrayerInfo,
                  isLoading: _isLoading,
                  onDeeperPrayerRecorded: () {},
                ),
                const SizedBox(height: 24),
                RequestPrayer(onPrayerRequestSubmitted: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rhema Prayer Plan',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: const Color(0xFFB8860B),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Join us in daily prayer to transform lives',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white70
                : Colors.black87,
          ),
        ),
      ],
    );
  }
}
