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
  DateTime? _selectedDate;
  DateTime _displayedMonth = DateTime.now();
  bool _showCalendar = false;

  @override
  void initState() {
    super.initState();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _toggleCalendar() {
    setState(() {
      _showCalendar = !_showCalendar;
    });
  }

  void _selectDate(DateTime date, List<dynamic> availableStudies) {
    final hasStudy = availableStudies.any((study) => _isSameDay(DateTime.parse(study.date), date));
    if (hasStudy) {
      setState(() {
        _selectedDate = date;
        _showCalendar = false;
      });
    }
  }

  void _changeMonth(int delta) {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + delta);
    });
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
    final todayStudyAsync = ref.watch(todaysBibleStudyProvider);
    final studiesAsync = ref.watch(
      bibleStudiesProvider(const {
        'per_page': 15,
        'start_date': null,
        'end_date': null,
        'search': null,
      }),
    );
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Bible Study Template',
          subtitle: 'Today\'s study and explore past studies',
        ),
        const SizedBox(height: 12),
        _buildTodaysStudySection(context, todayStudyAsync),
        const SizedBox(height: 24),
        _buildPastStudiesSection(context, studiesAsync),
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

  Widget _buildTemplateField(String label, String content, [bool isFuture = false]) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isFuture 
                  ? Colors.grey.shade400
                  : AppTheme.primaryGold,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isFuture 
                  ? Colors.grey.withOpacity(0.05)
                  : AppTheme.accentGold.withOpacity(0.05),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isFuture 
                    ? Colors.grey.withOpacity(0.2)
                    : AppTheme.primaryGold.withOpacity(0.1),
              ),
            ),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 12,
                color: isFuture 
                    ? Colors.grey.shade400
                    : Colors.grey.shade700,
                height: 1.3,
              ),
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
        const SectionHeader(
          title: 'Past Studies',
          subtitle: 'Explore previous Bible studies with calendar navigation',
        ),
        const SizedBox(height: 12),
        studiesAsync.when(
          data: (pastStudies) => _buildCalendarDropdown(context, pastStudies.data),
          loading: () => _buildCalendarDropdown(context, []),
          error: (_, __) => _buildCalendarDropdown(context, []),
        ),
        const SizedBox(height: 16),
        studiesAsync.when(
          data: (pastStudies) => _buildStudiesGrid(context, pastStudies.data),
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

  Widget _buildCalendarDropdown(BuildContext context, List<dynamic> availableStudies) {
    final availableDatesCount = availableStudies.length;
    final hasStudies = availableStudies.isNotEmpty;
    
    return Column(
      children: [
        // Header with selected date and toggle button
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.accentGold.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primaryGold.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: hasStudies 
                      ? AppTheme.primaryGold.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.calendar_month,
                  color: hasStudies ? AppTheme.primaryGold : Colors.grey,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Study Date',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: hasStudies ? AppTheme.deepGold : Colors.grey.shade500,
                      ),
                    ),
                    Text(
                      _selectedDate != null 
                          ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                          : hasStudies 
                              ? '$availableDatesCount studies available'
                              : 'No studies available',
                      style: TextStyle(
                        fontSize: 11,
                        color: hasStudies 
                            ? Colors.grey.shade600
                            : Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: hasStudies ? _toggleCalendar : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: hasStudies 
                        ? AppTheme.primaryGold.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: hasStudies 
                          ? AppTheme.primaryGold.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _showCalendar ? 'Close' : 'Calendar',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: hasStudies 
                              ? AppTheme.primaryGold
                              : Colors.grey.shade400,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        _showCalendar ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: hasStudies 
                            ? AppTheme.primaryGold
                            : Colors.grey.shade400,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Custom Calendar View
        if (_showCalendar && hasStudies)
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.charcoalBlack, AppTheme.softBlack],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primaryGold.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryGold.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: _buildCustomCalendar(availableStudies),
          ),
      ],
    );
  }

  Widget _buildStudiesGrid(BuildContext context, List<dynamic> studies) {
    if (_selectedDate == null) {
      return CustomCard(
        child: Column(
          children: [
            Icon(Icons.calendar_today, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              'Select a date above',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Choose a date to view that day\'s Bible study',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
          ],
        ),
      );
    }

    // Find study for selected date
    dynamic selectedStudy;
    try {
      selectedStudy = studies.firstWhere(
        (study) => _isSameDay(DateTime.parse(study.date), _selectedDate!),
      );
    } catch (e) {
      selectedStudy = null;
    }

    if (selectedStudy == null) {
      final formattedDate = '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';
      return CustomCard(
        child: Column(
          children: [
            Icon(Icons.book_outlined, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              'No study found',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'No Bible study available for $formattedDate',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return _buildSelectedStudyTemplate(context, selectedStudy);
  }

  Widget _buildSelectedStudyTemplate(BuildContext context, dynamic study) {
    final studyDate = DateTime.parse(study.date);
    final dayName = _getDayName(studyDate.weekday);
    final formattedDate = '${studyDate.day}/${studyDate.month}/${studyDate.year}';
    final isToday = _isSameDay(studyDate, DateTime.now());
    final isFuture = studyDate.isAfter(DateTime.now());
    
    return CustomCard(
      child: Opacity(
        opacity: isFuture ? 0.7 : 1.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isToday 
                        ? AppTheme.primaryGold
                        : isFuture 
                            ? Colors.grey.withOpacity(0.3)
                            : AppTheme.primaryGold.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    color: isToday 
                        ? AppTheme.richBlack
                        : isFuture 
                            ? Colors.grey
                            : AppTheme.primaryGold,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '$dayName ($formattedDate) Study Template',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isFuture 
                          ? Colors.grey.shade500
                          : AppTheme.deepGold,
                    ),
                  ),
                ),
                if (isToday)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGold.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Today',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.primaryGold,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                if (isFuture)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Coming Soon',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Template Structure
            _buildTemplateField('Topic:', study.topic, isFuture),
            const SizedBox(height: 12),
            _buildTemplateField('Scripture:', study.scripture, isFuture),
            const SizedBox(height: 12),
            _buildTemplateField('Devotional:', study.devotional, isFuture),
            const SizedBox(height: 12),
            
            if (study.discussionJson['questions'] != null && study.discussionJson['questions'].isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          'Discussion:',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isFuture 
                                ? Colors.grey.shade400
                                : AppTheme.primaryGold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: study.discussionJson['questions'].map<Widget>(
                            (question) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isFuture 
                                    ? Colors.grey.withOpacity(0.05)
                                    : AppTheme.accentGold.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: isFuture 
                                      ? Colors.grey.withOpacity(0.2)
                                      : AppTheme.primaryGold.withOpacity(0.1),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    margin: const EdgeInsets.only(top: 4),
                                    decoration: BoxDecoration(
                                      color: isFuture 
                                          ? Colors.grey.shade400
                                          : AppTheme.primaryGold,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      isFuture ? 'Questions for reflection/group study' : question,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isFuture 
                                            ? Colors.grey.shade400
                                            : Colors.grey.shade700,
                                        height: 1.3,
                                        fontStyle: isFuture ? FontStyle.italic : FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomCalendar(List<dynamic> availableStudies) {
    final monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    return Column(
      children: [
        // Month navigation header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primaryGold, AppTheme.darkGold],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryGold.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => _changeMonth(-1),
                icon: const Icon(Icons.chevron_left, color: AppTheme.richBlack, size: 28),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              Text(
                '${monthNames[_displayedMonth.month - 1]} ${_displayedMonth.year}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.richBlack,
                  letterSpacing: 0.5,
                ),
              ),
              IconButton(
                onPressed: () => _changeMonth(1),
                icon: const Icon(Icons.chevron_right, color: AppTheme.richBlack, size: 28),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        // Weekday headers
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.richBlack.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.primaryGold.withOpacity(0.1)),
          ),
          child: Row(
            children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                .map((day) => Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          day,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryGold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        
        // Calendar grid
        ..._buildCalendarWeeks(availableStudies),
        
        // Legend
        const SizedBox(height: 16),
        _buildCalendarLegend(),
      ],
    );
  }

  List<Widget> _buildCalendarWeeks(List<dynamic> availableStudies) {
    final firstDayOfMonth = DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final lastDayOfMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7;
    
    final weeks = <Widget>[];
    var currentDate = firstDayOfMonth.subtract(Duration(days: firstWeekday));
    
    while (currentDate.isBefore(lastDayOfMonth) || currentDate.month == _displayedMonth.month) {
      final weekDays = <Widget>[];
      
      for (int i = 0; i < 7; i++) {
        weekDays.add(Expanded(child: _buildCalendarDay(currentDate, availableStudies)));
        currentDate = currentDate.add(const Duration(days: 1));
      }
      
      weeks.add(Row(children: weekDays));
      
      if (currentDate.month != _displayedMonth.month && currentDate.isAfter(lastDayOfMonth)) {
        break;
      }
    }
    
    return weeks;
  }

  Widget _buildCalendarDay(DateTime date, List<dynamic> availableStudies) {
    final isCurrentMonth = date.month == _displayedMonth.month;
    final isToday = _isSameDay(date, DateTime.now());
    final isFuture = date.isAfter(DateTime.now()) && !isToday;
    final isSelected = _selectedDate != null && _isSameDay(date, _selectedDate!);
    final hasStudy = availableStudies.any((study) => _isSameDay(DateTime.parse(study.date), date));
    
    Color backgroundColor = Colors.transparent;
    Color textColor = Colors.grey.shade600;
    Color borderColor = Colors.transparent;
    IconData? icon;
    Color iconColor = Colors.transparent;
    List<BoxShadow> boxShadows = [];
    
    if (isCurrentMonth) {
      if (isToday) {
        backgroundColor = AppTheme.primaryGold;
        textColor = AppTheme.richBlack;
        borderColor = AppTheme.primaryGold;
        icon = hasStudy ? Icons.book : Icons.today;
        iconColor = AppTheme.richBlack;
        boxShadows = [
          BoxShadow(
            color: AppTheme.primaryGold.withOpacity(0.5),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ];
      } else if (isFuture) {
        backgroundColor = AppTheme.softBlack.withOpacity(0.3);
        textColor = Colors.grey.shade500;
        borderColor = Colors.grey.withOpacity(0.2);
        if (hasStudy) {
          icon = Icons.schedule;
          iconColor = Colors.grey.shade500;
        }
      } else if (hasStudy) {
        backgroundColor = AppTheme.darkGold.withOpacity(0.2);
        textColor = AppTheme.primaryGold;
        borderColor = AppTheme.primaryGold.withOpacity(0.5);
        icon = Icons.menu_book;
        iconColor = AppTheme.primaryGold;
        boxShadows = [
          BoxShadow(
            color: AppTheme.primaryGold.withOpacity(0.2),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ];
      } else {
        backgroundColor = AppTheme.charcoalBlack.withOpacity(0.3);
        textColor = Colors.grey.shade400;
        borderColor = Colors.grey.withOpacity(0.2);
      }
      
      if (isSelected && !isToday) {
        borderColor = AppTheme.primaryGold;
        backgroundColor = AppTheme.primaryGold.withOpacity(0.4);
        textColor = AppTheme.richBlack;
        boxShadows = [
          BoxShadow(
            color: AppTheme.primaryGold.withOpacity(0.4),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ];
      }
    } else {
      textColor = Colors.grey.shade600;
      backgroundColor = Colors.transparent;
    }
    
    return GestureDetector(
      onTap: isCurrentMonth && hasStudy && !isFuture ? () => _selectDate(date, availableStudies) : null,
      child: Container(
        margin: const EdgeInsets.all(2),
        height: 40,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
          boxShadow: boxShadows,
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isToday ? FontWeight.w700 : FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            if (icon != null)
              Positioned(
                top: 2,
                right: 2,
                child: Icon(
                  icon,
                  size: 8,
                  color: iconColor,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarLegend() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.richBlack.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.primaryGold.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Legend:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryGold,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildLegendItem(
                color: AppTheme.primaryGold,
                icon: Icons.today,
                label: 'Today',
                textColor: AppTheme.richBlack,
              ),
              _buildLegendItem(
                color: AppTheme.darkGold.withOpacity(0.2),
                icon: Icons.menu_book,
                label: 'Has Study',
                textColor: AppTheme.primaryGold,
              ),
              _buildLegendItem(
                color: AppTheme.charcoalBlack.withOpacity(0.3),
                icon: null,
                label: 'No Study',
                textColor: Colors.grey.shade400,
              ),
              _buildLegendItem(
                color: AppTheme.softBlack.withOpacity(0.3),
                icon: Icons.schedule,
                label: 'Future',
                textColor: Colors.grey.shade500,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required Color textColor,
    IconData? icon,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: color == AppTheme.charcoalBlack.withOpacity(0.3)
                  ? AppTheme.primaryGold.withOpacity(0.3)
                  : color == AppTheme.softBlack.withOpacity(0.3)
                      ? Colors.grey.withOpacity(0.5)
                      : color,
              width: 1,
            ),
            boxShadow: color == AppTheme.primaryGold 
                ? [
                    BoxShadow(
                      color: AppTheme.primaryGold.withOpacity(0.3),
                      blurRadius: 2,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: icon != null
              ? Icon(icon, size: 10, color: textColor)
              : null,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
  }
}
