import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/event.dart';
import '../../provider/api_providers.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/event_card.dart';
import 'event_detail_screen.dart';

class BusinessForumScreen extends ConsumerStatefulWidget {
  const BusinessForumScreen({super.key});

  @override
  ConsumerState<BusinessForumScreen> createState() => _BusinessForumScreenState();
}

class _BusinessForumScreenState extends ConsumerState<BusinessForumScreen>
    with TickerProviderStateMixin {
  late AnimationController _heroController;
  late AnimationController _fadeController;
  late Animation<double> _heroAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _heroAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    _heroController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _heroController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.richBlack,
      appBar: AppBar(
        title: const Text('7D JKMG Business Forum'),
        centerTitle: true,
        backgroundColor: AppTheme.richBlack,
        foregroundColor: AppTheme.primaryGold,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(),
            const SizedBox(height: 24),
            _buildAboutSection(),
            const SizedBox(height: 24),
            _buildUpcomingBusinessEvents(),
            const SizedBox(height: 24),
            _buildMyBusinessRegistrations(),
            const SizedBox(height: 24),
            _buildForumFeatures(),
            const SizedBox(height: 24),
            _buildNetworkingSection(),
            const SizedBox(height: 24),
            _buildJoinSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return AnimatedBuilder(
      animation: _heroAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _heroAnimation.value,
          child: Container(
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
                    Icons.business,
                    size: 40,
                    color: AppTheme.richBlack,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '7D JKMG Business Forum',
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
                  'Faith-Driven Entrepreneurship',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
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
                    'Networking • Innovation • Kingdom Impact',
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
        );
      },
    );
  }

  Widget _buildAboutSection() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  title: 'About the Forum',
                  subtitle: 'Where faith meets business excellence',
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGold.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.primaryGold.withOpacity(0.1)),
                  ),
                  child: const Text(
                    'JKMG Business Forum is a structured gathering where business owners, SMEs, entrepreneurs, investors, and industry professionals come together to exchange ideas, discuss opportunities, share expertise, and build professional networks.\n\nThe main goal is to build faith-driven entrepreneurs, promote collaboration, inspire innovation, and create opportunities for growth amongst the Christian business community.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildForumFeatures() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Forum Features',
                subtitle: 'What the forum includes',
              ),
              const SizedBox(height: 12),
              _buildFeatureCard(
                Icons.mic,
                'Panel Discussions',
                'Keynote speeches from experts like Rev Julian Kyula',
                AppTheme.primaryGold,
              ),
              const SizedBox(height: 12),
              _buildFeatureCard(
                Icons.handshake,
                'Networking Sessions',
                'Connect with potential partners, clients, or investors',
                AppTheme.deepGold,
              ),
              const SizedBox(height: 12),
              _buildFeatureCard(
                Icons.build,
                'Skills Development',
                'Workshops and breakout sessions for problem-solving',
                AppTheme.darkGold,
              ),
              const SizedBox(height: 12),
              _buildFeatureCard(
                Icons.trending_up,
                'Growth Opportunities',
                'Create opportunities for business expansion',
                AppTheme.successGreen,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkingSection() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Networking Opportunities',
                subtitle: 'Connect with like-minded professionals',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildNetworkingCard('500+', 'Business\nOwners', Icons.business_center)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildNetworkingCard('150+', 'Investors', Icons.attach_money)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildNetworkingCard('200+', 'Entrepreneurs', Icons.lightbulb)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildNetworkingCard('75+', 'Industry\nExperts', Icons.star)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNetworkingCard(String number, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryGold.withOpacity(0.1), AppTheme.accentGold.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryGold.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.deepGold, size: 28),
          const SizedBox(height: 8),
          Text(
            number,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppTheme.deepGold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade300,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildJoinSection() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.charcoalBlack,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
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
                        Icons.group_add,
                        color: AppTheme.primaryGold,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Join the Business Forum',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Connect with faith-driven entrepreneurs and business leaders. Build meaningful relationships while growing your business with Kingdom principles.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement forum registration
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Forum registration coming soon!'),
                          backgroundColor: AppTheme.primaryGold,
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Join Forum'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGold,
                      foregroundColor: AppTheme.richBlack,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUpcomingBusinessEvents() {
    final allEventsAsync = ref.watch(allEventsProvider);
    
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Upcoming Business Events',
                subtitle: 'Join our faith-driven business gatherings',
              ),
              const SizedBox(height: 12),
              allEventsAsync.when(
                data: (response) {
                  final businessEvents = response.data
                      .where((event) => event.type.value == 'business_forum')
                      .toList();
                  
                  if (businessEvents.isEmpty) {
                    return _buildEmptyEventsState();
                  }
                  
                  return Column(
                    children: businessEvents.map((event) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: EventCard(
                          event: event,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EventDetailScreen(event: event),
                              ),
                            );
                            if (mounted) {
                              ref.invalidate(allEventsProvider);
                              ref.invalidate(myRegistrationsProvider);
                            }
                          },
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => _buildLoadingState(),
                error: (error, _) => _buildErrorState(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMyBusinessRegistrations() {
    final myRegistrationsAsync = ref.watch(myRegistrationsProvider);
    
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'My Business Forum Registrations',
                subtitle: 'Your registered business events',
              ),
              const SizedBox(height: 12),
              myRegistrationsAsync.when(
                data: (response) {
                  final businessRegistrations = response.data
                      .where((reg) => reg.event?.type.value == 'business_forum')
                      .toList();
                  
                  if (businessRegistrations.isEmpty) {
                    return _buildEmptyRegistrationsState();
                  }
                  
                  return Column(
                    children: businessRegistrations.map((registration) {
                      final event = registration.event!;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: EventCard(
                          event: event,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EventDetailScreen(event: event),
                              ),
                            );
                            if (mounted) {
                              ref.invalidate(allEventsProvider);
                              ref.invalidate(myRegistrationsProvider);
                            }
                          },
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => _buildLoadingState(),
                error: (error, _) => _buildErrorState(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyEventsState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryGold.withOpacity(0.1),
            AppTheme.primaryGold.withOpacity(0.05),
          ],
        ),
        border: Border.all(color: AppTheme.primaryGold.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryGold.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.event_note,
              size: 48,
              color: AppTheme.primaryGold.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Business Events Scheduled',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryGold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'New business forum events will appear here when scheduled.\nConnect with faith-driven entrepreneurs!',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyRegistrationsState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryGold.withOpacity(0.1),
            AppTheme.primaryGold.withOpacity(0.05),
          ],
        ),
        border: Border.all(color: AppTheme.primaryGold.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryGold.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.event_available,
              size: 48,
              color: AppTheme.primaryGold.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Business Forum Registrations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryGold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Register for upcoming business forum events to see them here.\nBuild networks with Kingdom entrepreneurs!',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: const Column(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGold),
          ),
          SizedBox(height: 16),
          Text(
            'Loading...',
            style: TextStyle(
              color: AppTheme.primaryGold,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.red.withOpacity(0.1),
            Colors.red.withOpacity(0.05),
          ],
        ),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Error Loading Data',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Unable to load business forum information.\nPlease check your connection and try again.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}