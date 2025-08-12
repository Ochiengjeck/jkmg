import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/counseling.dart';
import '../../provider/api_providers.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';
import 'book_counseling.dart';
import 'counseling_list.dart';

class CounselingCornerScreen extends ConsumerStatefulWidget {
  const CounselingCornerScreen({super.key});

  @override
  ConsumerState<CounselingCornerScreen> createState() =>
      _CounselingCornerScreenState();
}

class _CounselingCornerScreenState
    extends ConsumerState<CounselingCornerScreen> {
  String _searchQuery = '';
  DateTime? _startDate;
  DateTime? _endDate;

  // Direct state management
  bool _isLoading = true;
  List<CounselingSession> _sessions = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    print('🔄 Starting to load sessions directly...');
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final apiService = ref.read(apiServiceProvider);
      final result = await apiService.getMyCounselingSessions(
        status: null,
        startDate: _startDate?.toIso8601String(),
        endDate: _endDate?.toIso8601String(),
        search: _searchQuery.isEmpty ? null : _searchQuery,
        perPage: 15,
      );

      print('✅ Sessions loaded directly: ${result.data.length}');

      if (mounted) {
        setState(() {
          _sessions = result.data;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error loading sessions directly: $e');
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _loadSessions(); // Reload with new search
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
      _loadSessions(); // Reload with new date filter
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroSection(),
                    const SizedBox(height: 24),
                    _buildIntroductionSection(),
                    const SizedBox(height: 24),
                    _buildCounselingOptionsSection(),
                    const SizedBox(height: 24),
                    _buildMySessionsSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildHeroSection() {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(24),
  //     decoration: const BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [AppTheme.richBlack, AppTheme.charcoalBlack],
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //       ),
  //       boxShadow: [
  //         BoxShadow(
  //           color: AppTheme.primaryGold,
  //           blurRadius: 20,
  //           spreadRadius: -10,
  //           offset: Offset(0, 10),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.all(16),
  //           decoration: const BoxDecoration(
  //             color: AppTheme.primaryGold,
  //             shape: BoxShape.circle,
  //           ),
  //           child: const Icon(
  //             Icons.healing,
  //             size: 32,
  //             color: AppTheme.richBlack,
  //           ),
  //         ),
  //         const SizedBox(height: 16),
  //         const Text(
  //           'Counseling & Care',
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //             fontSize: 24,
  //             fontWeight: FontWeight.w800,
  //             color: AppTheme.primaryGold,
  //             letterSpacing: 1.2,
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         const Text(
  //           'Find Healing in Christ',
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: Colors.white70,
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildHeroSection() {
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
                        image: AssetImage('assets/images/counseling & care.png'),
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
                  'Counseling & Care',
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
                  'Find Healing in Christ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGold.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: AppTheme.primaryGold.withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'Professional Care • AI Healing • Emergency Support',
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

  Widget _buildIntroductionSection() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Welcome to Counseling & Care',
            // icon: Icons.favorite,
          ),
          const SizedBox(height: 12),
          Text(
            'Your emotional, spiritual, and overall well-being matter deeply to us as a ministry. Please select the option below that best fits your specific need.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounselingOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Counseling Options',
          // icon: Icons.psychology,
        ),
        const SizedBox(height: 16),
        _buildAccessCounselingCard(),
        const SizedBox(height: 16),
        _buildSelfGuidedHealingCard(),
        const SizedBox(height: 16),
        _buildEmergencyHelpCard(),
        const SizedBox(height: 16),
        _buildFeedbackCard(),
      ],
    );
  }

  Widget _buildAccessCounselingCard() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.chat,
                  color: AppTheme.primaryGold,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Access Counseling',
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
          Text(
            'Click the link below to join our private Telegram group, where you\'ll have direct access to our dedicated and professional care team. You can share your concerns privately and also schedule a one-on-one call for personalized support.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showBookingModal(context),
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: const Text('Book Session'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGold,
                    foregroundColor: AppTheme.richBlack,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _joinTelegramGroup(),
                  icon: const Icon(Icons.telegram, size: 16),
                  label: const Text('Join Telegram'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryGold,
                    side: const BorderSide(color: AppTheme.primaryGold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelfGuidedHealingCard() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.auto_fix_high,
                  color: AppTheme.primaryGold,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Self-Guided Healing',
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
          Text(
            'This section is designed to provide answers to your pressing questions, supported by relevant Bible verses. Powered by our custom AI agent, it offers clarity, guidance, and spiritual direction tailored to your needs.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _launchAIAssistant(),
              icon: const Icon(Icons.psychology, size: 16),
              label: const Text('Start AI Healing Session'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGold,
                foregroundColor: AppTheme.richBlack,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyHelpCard() {
    return CustomCard(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red.shade300, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.emergency,
                    color: Colors.red.shade600,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Emergency Help Flow',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'For users in distress or with urgent needs. Get immediate support and connect with our crisis support team.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showEmergencyHelp(context),
                icon: const Icon(Icons.phone, size: 16),
                label: const Text('Need Urgent Help?'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackCard() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.feedback,
                  color: AppTheme.primaryGold,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Feedback',
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
          Text(
            'Share your experience and feedback regarding your interactions with our counselors and dedicated AI agent.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showFeedbackForm(context),
              icon: const Icon(Icons.rate_review, size: 16),
              label: const Text('Give Feedback'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryGold,
                side: const BorderSide(color: AppTheme.primaryGold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMySessionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'My Counseling Sessions',
          // icon: Icons.history,
        ),
        const SizedBox(height: 16),
        _buildContent(),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFFB8860B)),
            SizedBox(height: 16),
            Text(
              'Loading your counseling sessions...',
              style: TextStyle(color: Color(0xFFB8860B), fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading sessions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadSessions,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB8860B),
              ),
              child: const Text('Retry', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      );
    }

    // Show the sessions list
    return RefreshIndicator(
      onRefresh: _loadSessions,
      child: CounselingList(
        sessions: _sessions,
        searchQuery: _searchQuery,
        startDate: _startDate,
        endDate: _endDate,
        onSearchChanged: _onSearchChanged,
        onDateSelected: _selectDate,
      ),
    );
  }

  void _showBookingModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 22, 21, 21),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Book a Counseling Session',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryGold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: const BookCounselingForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _joinTelegramGroup() {
    // TODO: Implement Telegram group joining functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Telegram group integration coming soon!'),
        backgroundColor: AppTheme.primaryGold,
      ),
    );
  }

  void _launchAIAssistant() {
    // TODO: Launch AI assistant (Pickaxe integration)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('AI healing session will be available soon!'),
        backgroundColor: AppTheme.primaryGold,
      ),
    );
  }

  void _showEmergencyHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.emergency, color: Colors.red.shade600),
            const SizedBox(width: 8),
            const Text('Emergency Help'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'If you are in crisis or having thoughts of self-harm, please reach out immediately:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16),
            Text('• Call JKM Prayer Line'),
            Text('• Connect with live counselor'),
            Text('• Scripture + prayer support'),
            SizedBox(height: 16),
            Text(
              'You are not alone. Help is available.',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryGold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement emergency contact functionality
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
            child: const Text('Get Help Now'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackForm(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final experienceController = TextEditingController();
    final suggestionController = TextEditingController();
    int rating = 5;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (context, scrollController) => Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 42, 41, 41),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Share Your Feedback',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryGold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Rate your experience',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              return IconButton(
                                onPressed: () =>
                                    setModalState(() => rating = index + 1),
                                icon: Icon(
                                  Icons.star,
                                  color: index < rating
                                      ? AppTheme.primaryGold
                                      : Colors.grey.shade300,
                                  size: 32,
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: experienceController,
                            decoration: const InputDecoration(
                              labelText: 'Your Experience',
                              labelStyle: TextStyle(
                                color: AppTheme.primaryGold,
                              ),
                              hintText: 'Tell us about your experience...',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please share your experience';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: suggestionController,
                            decoration: const InputDecoration(
                              labelText: 'Suggestions for Improvement',
                              labelStyle: TextStyle(
                                color: AppTheme.primaryGold,
                              ),
                              hintText: 'How can we improve our service?',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Thank you for your feedback!',
                                      ),
                                      backgroundColor: AppTheme.primaryGold,
                                    ),
                                  );
                                  // TODO: Submit feedback to backend
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryGold,
                                foregroundColor: AppTheme.richBlack,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: const Text('Submit Feedback'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
