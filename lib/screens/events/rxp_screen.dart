import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../models/event.dart';
import '../../provider/api_providers.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/event_card.dart';
import 'event_detail_screen.dart';

class RXPScreen extends ConsumerStatefulWidget {
  const RXPScreen({super.key});

  @override
  ConsumerState<RXPScreen> createState() => _RXPScreenState();
}

class _RXPScreenState extends ConsumerState<RXPScreen>
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
        title: const Text('RXP (Rhema Experience)'),
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
            _buildServiceDetails(),
            const SizedBox(height: 24),
            _buildUpcomingRXPEvents(),
            const SizedBox(height: 24),
            _buildMyRXPRegistrations(),
            const SizedBox(height: 24),
            _buildFeaturesSection(),
            const SizedBox(height: 24),
            _buildAccessSection(),
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
                    Icons.schedule,
                    size: 40,
                    color: AppTheme.richBlack,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'RXP (Rhema Experience)',
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
                  'Weekly Interdenominational Service',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Consumer(
                  builder: (context, ref, child) {
                    final eventsAsync = ref.watch(allEventsProvider);
                    return eventsAsync.when(
                      data: (response) {
                        final rxpEvents = response.data
                            .where((event) => event.type.value == 'rxp')
                            .toList();
                        
                        if (rxpEvents.isNotEmpty) {
                          final nextEvent = rxpEvents.first;
                          final startDate = DateTime.parse(nextEvent.startDate);
                          final formattedDate = DateFormat('MMM d, y').format(startDate);
                          
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGold.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Next: $formattedDate • ${nextEvent.location}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.primaryGold,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }
                        
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGold.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Every Wednesday 5:00-9:00 PM • All Saints Cathedral',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppTheme.primaryGold,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                      loading: () => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGold.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Loading RXP details...',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.primaryGold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      error: (_, __) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGold.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Every Wednesday 5:00-9:00 PM • All Saints Cathedral',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.primaryGold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
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
                  title: 'About RXP',
                  subtitle: 'Transformative weekly worship experience',
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
                    '"RXP" stands for Rhema Xperience—an interdenominational weekly service held at All Saints Cathedral in Nairobi, led by Rev. Julian Kyula.\n\nRooted in the Greek word Rhema, meaning \'the spoken word of God,\' the service is designed to usher believers into a deep encounter with the power of God\'s Word. "Ruach," a Hebrew term meaning wind, breath, or spirit, reflects the presence and move of the Holy Spirit.',
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

  Widget _buildServiceDetails() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Service Details',
                subtitle: 'What to expect at RXP',
              ),
              const SizedBox(height: 12),
              _buildDetailCard(Icons.access_time, 'Schedule', 'Every Wednesday from 5:00 PM to 9:00 PM'),
              const SizedBox(height: 12),
              _buildDetailCard(Icons.location_on, 'Venue', 'All Saints Cathedral, Nairobi'),
              const SizedBox(height: 12),
              _buildDetailCard(Icons.people, 'Community', 'Interdenominational worship experience'),
              const SizedBox(height: 12),
              _buildDetailCard(Icons.mic, 'Leadership', 'Led by Rev. Julian Kyula'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailCard(IconData icon, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryGold.withOpacity(0.1),
            AppTheme.accentGold.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryGold.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryGold.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.primaryGold, size: 24),
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

  Widget _buildFeaturesSection() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Features',
                subtitle: 'Enhanced worship experience',
              ),
              const SizedBox(height: 12),
              _buildFeatureCard(
                Icons.live_tv,
                'Live Stream',
                'Watch live via embedded YouTube channel',
                Colors.red,
              ),
              const SizedBox(height: 12),
              _buildFeatureCard(
                Icons.chat,
                'Live Chat',
                'Engage with the community during service',
                Colors.blue,
              ),
              const SizedBox(height: 12),
              _buildFeatureCard(
                Icons.library_music,
                'Archive',
                'Access past RXP sessions and devotionals',
                Colors.green,
              ),
              const SizedBox(height: 12),
              _buildFeatureCard(
                Icons.notifications,
                'Reminders',
                'Get notified when service is starting',
                Colors.orange,
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

  Widget _buildAccessSection() {
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
                        Icons.play_circle,
                        color: AppTheme.primaryGold,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Join RXP Experience',
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
                  'Experience powerful worship, prophetic teaching, and spiritual transformation every Wednesday evening.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Implement live stream
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Live stream feature coming soon!'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                        icon: const Icon(Icons.live_tv),
                        label: const Text('Watch Live'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Implement directions
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Directions feature coming soon!'),
                              backgroundColor: AppTheme.primaryGold,
                            ),
                          );
                        },
                        icon: const Icon(Icons.directions),
                        label: const Text('Directions'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryGold,
                          side: const BorderSide(color: AppTheme.primaryGold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUpcomingRXPEvents() {
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
                title: 'Upcoming RXP Services',
                subtitle: 'Join our weekly Rhema Experience',
              ),
              const SizedBox(height: 12),
              allEventsAsync.when(
                data: (response) {
                  final rxpEvents = response.data
                      .where((event) => event.type.value == 'rxp')
                      .toList();
                  
                  if (rxpEvents.isEmpty) {
                    return _buildEmptyEventsState();
                  }
                  
                  return Column(
                    children: rxpEvents.map((event) {
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

  Widget _buildMyRXPRegistrations() {
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
                title: 'My RXP Registrations',
                subtitle: 'Your registered RXP services',
              ),
              const SizedBox(height: 12),
              myRegistrationsAsync.when(
                data: (response) {
                  final rxpRegistrations = response.data
                      .where((reg) => reg.event?.type.value == 'rxp')
                      .toList();
                  
                  if (rxpRegistrations.isEmpty) {
                    return _buildEmptyRegistrationsState();
                  }
                  
                  return Column(
                    children: rxpRegistrations.map((registration) {
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
            'No RXP Events Scheduled',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryGold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'New RXP services will appear here when scheduled.\nRemember: Weekly services every Wednesday!',
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
            'No RXP Registrations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryGold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Register for upcoming RXP services to see them here.\nJoin us every Wednesday for powerful worship!',
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
            'Unable to load RXP information.\nPlease check your connection and try again.',
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