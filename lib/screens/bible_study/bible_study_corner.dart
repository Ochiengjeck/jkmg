import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jkmg/provider/api_providers.dart';

import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';
import 'study_list.dart';
import 'todays_study.dart';
import 'holy_bible_section.dart';

class BibleStudyCornerScreen extends ConsumerStatefulWidget {
  const BibleStudyCornerScreen({super.key});

  @override
  ConsumerState<BibleStudyCornerScreen> createState() =>
      _BibleStudyCornerScreenState();
}

class _BibleStudyCornerScreenState
    extends ConsumerState<BibleStudyCornerScreen> {
  String _searchQuery = '';
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final todayStudyAsync = ref.watch(todaysBibleStudyProvider);
    final studiesAsync = ref.watch(
      bibleStudiesProvider(const {
        'per_page': 15,
        'start_date': null,
        'end_date': null,
        'search': null,
      }),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(todaysBibleStudyProvider);
            ref.invalidate(
              bibleStudiesProvider(const {
                'per_page': 15,
                'start_date': null,
                'end_date': null,
                'search': null,
              }),
            );
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
                _buildHolyBibleSection(context),
                const SizedBox(height: 24),
                _buildStudyTemplateSection(context),
                const SizedBox(height: 24),
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
                image: AssetImage('assets/images/bible study.png'),
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
                  'Deepen Your Faith Journey',
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
                  'Grow in faith through God\'s Word with structured study templates',
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
                      _buildFeatureChip('Daily Study'),
                      const SizedBox(width: 8),
                      _buildFeatureChip('Memory Verses'),
                      const SizedBox(width: 8),
                      _buildFeatureChip('Group Discussion'),
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
                  'About Bible Study Corner',
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
            'Access comprehensive Bible study materials including the Holy Bible in multiple formats, structured study templates with memory verses, daily devotionals, and group discussion questions to deepen your understanding of God\'s Word.',
            style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildHolyBibleSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Holy Bible',
          subtitle:
              'Access the complete Bible in multiple languages and formats',
        ),
        const SizedBox(height: 12),
        const HolyBibleSection(),
      ],
    );
  }

  Widget _buildTodaysStudySection(
    BuildContext context,
    AsyncValue todayStudyAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Today\'s Study',
          subtitle: 'Daily devotional study with scripture and reflection',
        ),
        const SizedBox(height: 12),
        todayStudyAsync.when(
          data: (study) => _buildTodaysStudyContent(study),
          loading: () => const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGold),
            ),
          ),
          error: (e, _) => CustomCard(
            child: Column(
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
                const SizedBox(height: 16),
                Text(
                  'Error loading today\'s study',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  e.toString(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => ref.invalidate(todaysBibleStudyProvider),
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

  Widget _buildTodaysStudyContent(dynamic study) {
    return TodaysStudy(study: study);
  }

  Widget _buildStudyTemplateSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Bible Study Template',
          subtitle: 'Weekly study template format for posting daily materials',
        ),
        const SizedBox(height: 12),
        _buildWeeklyStudyTemplate(context),
      ],
    );
  }

  Widget _buildWeeklyStudyTemplate(BuildContext context) {
    // Get the upcoming Monday to start the week template
    final now = DateTime.now();
    final daysUntilMonday = DateTime.monday - now.weekday;
    final nextMonday = now.add(Duration(days: daysUntilMonday == 0 ? 7 : daysUntilMonday));
    
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  color: AppTheme.primaryGold,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Weekly Study Template Format',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.deepGold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Template Instructions
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.primaryGold.withOpacity(0.2)),
            ),
            child: Text(
              'Post weekly study materials using this template format. Each day should include the study topic, scripture reference, and discussion points.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Weekly Template
          ...List.generate(7, (index) {
            final dayDate = nextMonday.add(Duration(days: index));
            final dayName = _getDayName(dayDate.weekday);
            
            return Column(
              children: [
                _buildDailyTemplate(dayName, dayDate),
                if (index < 6) const SizedBox(height: 12),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDailyTemplate(String dayName, DateTime date) {
    final formattedDate = '${date.day}/${date.month}/${date.year}';
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.accentGold.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.primaryGold.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day Header
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$dayName ($formattedDate) Study Template',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.deepGold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Template Structure
          _buildTemplateField('Topic:', 'Daily study theme/subject'),
          const SizedBox(height: 8),
          _buildTemplateField('Scripture:', 'Bible passage reference'),
          const SizedBox(height: 8),
          _buildTemplateField('Key Verse:', 'Memory verse for the day'),
          const SizedBox(height: 8),
          _buildTemplateField('Devotional:', 'Study content and explanation'),
          const SizedBox(height: 8),
          _buildTemplateField('Discussion:', 'Questions for reflection/group study'),
        ],
      ),
    );
  }

  Widget _buildTemplateField(String label, String placeholder) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryGold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            placeholder,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return 'Unknown';
    }
  }

  Widget _buildTemplateItem(String title, String description) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.accentGold.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.primaryGold.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.deepGold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPastStudiesSection(
    BuildContext context,
    AsyncValue studiesAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        studiesAsync.when(
          data: (pastStudies) => StudyList(
            studies: pastStudies.data,
            searchQuery: _searchQuery,
            startDate: _startDate,
            endDate: _endDate,
            onSearchChanged: _onSearchChanged,
            onDateSelected: _selectDate,
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGold),
            ),
          ),
          error: (e, _) => CustomCard(
            child: Column(
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
                const SizedBox(height: 16),
                Text(
                  'Error loading studies',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  e.toString(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => ref.invalidate(
                    bibleStudiesProvider(const {
                      'per_page': 15,
                      'start_date': null,
                      'end_date': null,
                      'search': null,
                    }),
                  ),
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
