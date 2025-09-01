import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/api_providers.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../services/alarm_service.dart';
import '../../services/preference_service.dart';
import 'deeper_prayer.dart';
import 'prayer_schedule.dart';
import 'request_prayer.dart';

enum PrayerPlanType { 
  introduction, 
  prayerSchedule, 
  requestPrayer, 
  deeperPrayer, 
  testNotifications 
}

class PrayerPlanScreen extends ConsumerStatefulWidget {
  const PrayerPlanScreen({super.key});

  @override
  ConsumerState<PrayerPlanScreen> createState() => _PrayerPlanScreenState();
}

class _PrayerPlanScreenState extends ConsumerState<PrayerPlanScreen> {
  PrayerPlanType? selectedPrayerType;
  bool _hasActiveCommitment = false;
  
  static const String _commitmentEndKey = 'prayer_commitment_end';
  
  @override
  void initState() {
    super.initState();
    _checkActiveCommitment();
  }
  
  Future<void> _checkActiveCommitment() async {
    final prefs = await PreferenceService.getInstance();
    final commitmentEndString = prefs.getString(_commitmentEndKey);
    
    if (commitmentEndString != null) {
      final commitmentEnd = DateTime.parse(commitmentEndString);
      final now = DateTime.now();
      
      if (commitmentEnd.isAfter(now)) {
        setState(() {
          _hasActiveCommitment = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                _buildPrayerDropdown(context),
                const SizedBox(height: 24),
                if (selectedPrayerType != null) _buildSelectedSection(context, deeperInfoAsync, ref),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Choose Your Prayer Focus',
          subtitle: 'Select what you\'d like to explore in your prayer journey',
        ),
        const SizedBox(height: 12),
        CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<PrayerPlanType>(
                value: selectedPrayerType,
                hint: Text(
                  'Select a prayer option',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black54,
                  ),
                ),
                decoration: InputDecoration(
                  labelText: 'Prayer Plan Options',
                  labelStyle: const TextStyle(color: AppTheme.primaryGold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppTheme.primaryGold),
                  ),
                ),
                items: [
                  const DropdownMenuItem(
                    value: PrayerPlanType.prayerSchedule,
                    child: Text('Daily Prayer Schedule'),
                  ),
                  DropdownMenuItem(
                    value: PrayerPlanType.requestPrayer,
                    enabled: !_hasActiveCommitment,
                    child: Text(
                      _hasActiveCommitment ? 'Request Prayer (Disabled)' : 'Request Prayer',
                      style: TextStyle(
                        color: _hasActiveCommitment ? Colors.grey : null,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const DropdownMenuItem(
                    value: PrayerPlanType.deeperPrayer,
                    child: Text('Deeper Prayer'),
                  ),
                  // DropdownMenuItem(
                  //   value: PrayerPlanType.testNotifications,
                  //   child: Text('Test Notifications'),
                  // ),
                ],
                onChanged: (value) {
                  // Prevent selection of disabled items during active commitment
                  if (_hasActiveCommitment && value == PrayerPlanType.requestPrayer) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Request Prayer is disabled during your active prayer commitment'),
                        backgroundColor: AppTheme.primaryGold,
                      ),
                    );
                    return;
                  }
                  setState(() {
                    selectedPrayerType = value;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedSection(BuildContext context, AsyncValue deeperInfoAsync, WidgetRef ref) {
    switch (selectedPrayerType!) {
      case PrayerPlanType.introduction:
        return const SizedBox.shrink(); // This case shouldn't occur anymore
      case PrayerPlanType.prayerSchedule:
        return _buildPrayerScheduleSection(context, deeperInfoAsync);
      case PrayerPlanType.requestPrayer:
        return _buildRequestPrayerSection(context, ref);
      case PrayerPlanType.deeperPrayer:
        return _buildDeeperPrayerSection(context, deeperInfoAsync, ref);
      case PrayerPlanType.testNotifications:
        return _buildTestNotificationSection(context);
    }
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
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
          // Clean image section without overlays
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              border: Border.all(
                color: AppTheme.primaryGold.withOpacity(0.3),
                width: 1,
              ),
              image: const DecorationImage(
                image: AssetImage('assets/images/prayer plan.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          // Separate text content section with modern design
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.charcoalBlack,
                  AppTheme.richBlack,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              border: Border.all(
                color: AppTheme.primaryGold.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Description
                const Text(
                  'Daily Prayer Schedule',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Stay aligned in prayer every 6 hours, led by Rev. Julian',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Feature highlights in single row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildFeatureChip('Daily Prayer'),
                      const SizedBox(width: 8),
                      _buildFeatureChip('Spiritual Growth'),
                      const SizedBox(width: 8),
                      _buildFeatureChip('Divine Connection'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppTheme.primaryGold.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppTheme.primaryGold.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          color: AppTheme.primaryGold,
          fontWeight: FontWeight.w600,
        ),
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
            _checkActiveCommitment(); // Refresh commitment status
          },
        ),
      ],
    );
  }

  Widget _buildTestNotificationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Test Prayer Notifications',
          subtitle: 'Test your prayer notification system to ensure it\'s working properly',
        ),
        const SizedBox(height: 12),
        CustomCard(
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
                      Icons.notification_important,
                      color: AppTheme.primaryGold,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Notification Test',
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
                'Test your notification system to ensure prayer reminders are working correctly. This will trigger a sample prayer notification with sound and vibration.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _testPrayerNotification(context, 'Morning Prayer'),
                      icon: const Icon(Icons.wb_sunny),
                      label: const Text('Test Morning'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGold,
                        foregroundColor: AppTheme.richBlack,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _testPrayerNotification(context, 'Noon Prayer'),
                      icon: const Icon(Icons.wb_sunny_outlined),
                      label: const Text('Test Noon'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.darkGold,
                        foregroundColor: AppTheme.richBlack,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _testPrayerNotification(context, 'Evening Prayer'),
                      icon: const Icon(Icons.nightlight_round),
                      label: const Text('Test Evening'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.deepGold,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _testPrayerNotification(context, 'Deeper Prayer - Midnight Session'),
                      icon: const Icon(Icons.nights_stay),
                      label: const Text('Test Midnight'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.charcoalBlack,
                        foregroundColor: AppTheme.primaryGold,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _testPrayerNotification(BuildContext context, String prayerType) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGold),
              ),
              SizedBox(width: 16),
              Text('Triggering test notification...'),
            ],
          ),
        ),
      );

      // Trigger the test notification
      await AlarmService.triggerPrayerAlarm(prayerType);

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Test notification sent for $prayerType!'),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      // Close loading dialog if still open
      if (context.mounted) {
        Navigator.of(context).pop();
        
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Failed to send test notification: ${e.toString()}'),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
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
