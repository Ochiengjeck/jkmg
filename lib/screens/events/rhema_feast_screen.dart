import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../models/event.dart';
import '../../provider/api_providers.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/event_card.dart';
import 'event_detail_screen.dart';

class RhemaFeastScreen extends ConsumerStatefulWidget {
  const RhemaFeastScreen({super.key});

  @override
  ConsumerState<RhemaFeastScreen> createState() => _RhemaFeastScreenState();
}

class _RhemaFeastScreenState extends ConsumerState<RhemaFeastScreen>
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
        title: const Text('Rhema Feast'),
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
            _buildEventDetails(),
            const SizedBox(height: 24),
            _buildUpcomingRhemaFeastEvents(),
            const SizedBox(height: 24),
            _buildMyRhemaFeastRegistrations(),
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
                      image: AssetImage('assets/images/rhema_feast.png'),
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
                        'I WILL BUILD MY CHURCH',
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
                        'A landmark annual spiritual gathering for believers globally',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      // Dynamic event info
                      Consumer(
                        builder: (context, ref, child) {
                          final eventsAsync = ref.watch(allEventsProvider);
                          return eventsAsync.when(
                            data: (response) {
                              final rhemaFeastEvents = response.data
                                  .where((event) => event.type.value == 'rhema_feast')
                                  .toList();
                              
                              if (rhemaFeastEvents.isNotEmpty) {
                                final nextEvent = rhemaFeastEvents.first;
                                final startDate = DateTime.parse(nextEvent.startDate);
                                final formattedDate = DateFormat('MMM d, y').format(startDate);
                                
                                return _buildEventInfoChip('$formattedDate • ${nextEvent.location}');
                              }
                              
                              return _buildEventInfoChip('Next Event Date • To Be Announced');
                            },
                            loading: () => _buildEventInfoChip('Loading event details...'),
                            error: (_, __) => _buildEventInfoChip('Event Details • Check Back Soon'),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      // Feature highlights in single row
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildFeatureChip('Word'),
                            const SizedBox(width: 8),
                            _buildFeatureChip('Worship'),
                            const SizedBox(width: 8),
                            _buildFeatureChip('Prayer'),
                            const SizedBox(width: 8),
                            _buildFeatureChip('Fellowship'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

  Widget _buildEventInfoChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppTheme.primaryGold.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: AppTheme.primaryGold,
          fontWeight: FontWeight.w600,
        ),
      ),
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
                  title: 'About Rhema Feast',
                  subtitle: 'A landmark annual spiritual gathering',
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
                    'Rhema Feast is a landmark annual spiritual gathering that began in 2015. As part of an apostolic movement led by visionary leader Rev. Julian Kyula, its mission is to deliver the unadulterated, authentic Word of God to nations and generations.\n\nOver the course of four days, believers from across the globe will come together to \'feast\' on God\'s Word—engaging in powerful worship, fervent prayer, meaningful fellowship, and, new this year, marketplace and business coaching.',
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

  Widget _buildEventDetails() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Event Details',
                subtitle: 'Four core pillars of spiritual experience',
              ),
              const SizedBox(height: 12),
              _buildPillarCard(Icons.menu_book, 'Word', 'Unadulterated, authentic Word of God'),
              const SizedBox(height: 12),
              _buildPillarCard(Icons.music_note, 'Worship', 'Powerful worship and praise'),
              const SizedBox(height: 12),
              _buildPillarCard(Icons.favorite, 'Prayer', 'Fervent prayer and intercession'),
              const SizedBox(height: 12),
              _buildPillarCard(Icons.people, 'Fellowship', 'Unified fellowship and community'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPillarCard(IconData icon, String title, String description) {
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

  Widget _buildUpcomingRhemaFeastEvents() {
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
                title: 'Upcoming Rhema Feast Events',
                subtitle: 'Join our powerful gatherings',
              ),
              const SizedBox(height: 12),
              allEventsAsync.when(
                data: (response) {
                  final rhemaFeastEvents = response.data
                      .where((event) => event.type.value == 'rhema_feast')
                      .toList();
                  
                  if (rhemaFeastEvents.isEmpty) {
                    return _buildEmptyEventsState();
                  }
                  
                  return Column(
                    children: rhemaFeastEvents.map((event) {
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

  Widget _buildMyRhemaFeastRegistrations() {
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
                title: 'My Rhema Feast Registrations',
                subtitle: 'Your registered Rhema Feast events',
              ),
              const SizedBox(height: 12),
              myRegistrationsAsync.when(
                data: (response) {
                  final rhemaFeastRegistrations = response.data
                      .where((reg) => reg.event?.type.value == 'rhema_feast')
                      .toList();
                  
                  if (rhemaFeastRegistrations.isEmpty) {
                    return _buildEmptyRegistrationsState();
                  }
                  
                  return Column(
                    children: rhemaFeastRegistrations.map((registration) {
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
            'No Rhema Feast Events Scheduled',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryGold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'New Rhema Feast events will appear here when scheduled.\nStay tuned for announcements!',
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
            'No Rhema Feast Registrations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryGold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Register for upcoming Rhema Feast events to see them here.\nDon\'t miss out on these powerful gatherings!',
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
            'Unable to load Rhema Feast information.\nPlease check your connection and try again.',
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