import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/api_providers.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';
import 'deeper_prayer.dart';
import 'prayer_schedule.dart';
import 'request_prayer.dart';

class PrayerPlanScreen extends ConsumerWidget {
  const PrayerPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deeperInfoAsync = ref.watch(deeperPrayerInfoProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(deeperPrayerInfoProvider);
          },
          color: AppTheme.primaryGold,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroSection(context),
                const SizedBox(height: 32),
                _buildIntroductionSection(context),
                const SizedBox(height: 24),
                _buildPrayerScheduleSection(context, deeperInfoAsync),
                const SizedBox(height: 24),
                _buildRequestPrayerSection(context, ref),
                const SizedBox(height: 24),
                _buildDeeperPrayerSection(context, deeperInfoAsync, ref),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.richBlack, AppTheme.charcoalBlack],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGold.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primaryGold,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryGold.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(
              Icons.favorite,
              size: 40,
              color: AppTheme.richBlack,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Rhema Prayer Plan',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppTheme.primaryGold,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'A daily prayer schedule designed to keep you aligned in prayer every 6 hours, led by Rev. Julian',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryGold.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Daily Prayer • Spiritual Growth • Divine Connection',
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.primaryGold,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroductionSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.accentGold.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryGold.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: AppTheme.primaryGold,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'About Rhema Prayer Plan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.deepGold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'The JKMG App introduces an innovative Prayer Plan feature designed to integrate spiritual discipline seamlessly into your daily routine. Functioning as an alarm notification system, this feature ensures consistent prayer engagement by providing timely reminders and guided prayer sessions led by Rev. Julian Kyula.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerScheduleSection(BuildContext context, AsyncValue deeperInfoAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Prayer Schedule',
          subtitle: 'Prayer reminders every 6 hours at 6:00 AM, 12:00 PM, and 6:00 PM',
        ),
        const SizedBox(height: 12),
        deeperInfoAsync.when(
          data: (deeperInfo) => PrayerSchedule(
            prayerSchedule: deeperInfo,
            isLoading: false,
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.primaryGold,
              ),
            ),
          ),
          error: (e, _) => CustomCard(
            child: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading schedule',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  e.toString(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGold,
                    foregroundColor: AppTheme.richBlack,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRequestPrayerSection(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Request Prayer',
          subtitle: 'Select specific prayer focus for 7-day commitment with daily prayers and fasting',
        ),
        const SizedBox(height: 12),
        RequestPrayer(
          onPrayerRequestSubmitted: () {
            ref.invalidate(deeperPrayerInfoProvider);
          },
        ),
      ],
    );
  }

  Widget _buildDeeperPrayerSection(BuildContext context, AsyncValue deeperInfoAsync, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Deeper in Prayer',
          subtitle: 'Powerful midnight prayer sessions from 12:00 AM to 1:00 AM for spiritual growth',
        ),
        const SizedBox(height: 12),
        deeperInfoAsync.when(
          data: (deeperInfo) => DeeperPrayer(
            deeperPrayerInfo: deeperInfo,
            isLoading: false,
            onDeeperPrayerRecorded: () {
              ref.invalidate(deeperPrayerInfoProvider);
            },
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.primaryGold,
              ),
            ),
          ),
          error: (e, _) => CustomCard(
            child: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading deeper prayer info',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  e.toString(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => ref.invalidate(deeperPrayerInfoProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGold,
                    foregroundColor: AppTheme.richBlack,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
