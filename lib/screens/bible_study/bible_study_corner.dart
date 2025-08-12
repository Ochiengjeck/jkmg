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
                _buildTodaysStudySection(context, todayStudyAsync),
                const SizedBox(height: 24),
                _buildStudyTemplateSection(context),
                const SizedBox(height: 24),
                _buildPastStudiesSection(context, studiesAsync),
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
          // Image section with fade effect
          Container(
            width: double.infinity,
            height: 180,
            child: Stack(
              children: [
                // Main image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/bible study.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // Fade gradient at bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 60,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Theme.of(context).scaffoldBackgroundColor,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.0, 0.8],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Text content section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'Bible Study Corner',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryGold,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Grow in faith through God\'s Word with structured study templates and devotional resources',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGold.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: AppTheme.primaryGold.withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'Daily Study • Memory Verses • Group Discussion',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.primaryGold,
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
          data: (study) => TodaysStudy(study: study),
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

  Widget _buildStudyTemplateSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Bible Study Template',
          subtitle: 'Structured format for personal and group Bible study',
        ),
        const SizedBox(height: 12),
        _buildStudyTemplate(context),
      ],
    );
  }

  Widget _buildStudyTemplate(BuildContext context) {
    return CustomCard(
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
                  Icons.assignment,
                  color: AppTheme.primaryGold,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Study Template Format',
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
          _buildTemplateItem(
            'Memory Verse',
            'Scripture verse for memorization and meditation',
          ),
          const SizedBox(height: 12),
          _buildTemplateItem(
            'Topic of the Day',
            'Main theme for today\'s Bible study',
          ),
          const SizedBox(height: 12),
          _buildTemplateItem(
            'Scripture of the Day',
            'Bible verse or passage for study',
          ),
          const SizedBox(height: 12),
          _buildTemplateItem(
            'Devotional Summary',
            '2-3 paragraph devotional explanation',
          ),
          const SizedBox(height: 12),
          _buildTemplateItem(
            'Group Discussion Questions',
            '2-3 reflective questions for group study',
          ),
        ],
      ),
    );
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
