import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jkmg/provider/api_providers.dart';
import 'package:jkmg/widgets/event_card.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';
import 'event_detail_screen.dart';
import 'rhema_feast_screen.dart';
import 'rxp_screen.dart';
import 'evangelical_outreach_screen.dart';
import 'business_forum_screen.dart';

class EventListScreen extends ConsumerStatefulWidget {
  const EventListScreen({super.key});

  @override
  ConsumerState<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends ConsumerState<EventListScreen>
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(),
            const SizedBox(height: 24),
            _buildIntroSection(),
            const SizedBox(height: 32),
            _buildEventCategories(),
            const SizedBox(height: 32),
            _buildAllEventsSection(),
            const SizedBox(height: 24),
            _buildMyRegistrationsSection(),
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
                      image: AssetImage('assets/images/events.png'),
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
                      colors: [AppTheme.charcoalBlack, AppTheme.richBlack],
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
                        'Expression & Announcements',
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
                        'Join various expressions and gatherings offered by JKMG',
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
                            _buildFeatureChip('Rhema Feast'),
                            const SizedBox(width: 8),
                            _buildFeatureChip('RXP'),
                            const SizedBox(width: 8),
                            _buildFeatureChip('Outreach'),
                            const SizedBox(width: 8),
                            _buildFeatureChip('Business Forum'),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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

  Widget _buildIntroSection() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.accentGold.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primaryGold.withOpacity(0.1),
                ),
              ),
              child: const Text(
                'Here you\'ll find up-to-date information on the various expressions and gatherings offered by JKMG—ranging from ministry-focused events to marketplace initiatives.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEventCategories() {
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
                title: 'Event Categories',
                subtitle:
                    'Explore different types of gatherings and initiatives',
              ),
              const SizedBox(height: 16),
              allEventsAsync.when(
                data: (response) {
                  final events = response.data;
                  final rhemaFeastCount = events
                      .where((e) => e.type.value == 'rhema_feast')
                      .length;
                  final rxpCount = events
                      .where((e) => e.type.value == 'rxp')
                      .length;
                  final outreachCount = events
                      .where((e) => e.type.value == 'outreach')
                      .length;
                  final businessCount = events
                      .where((e) => e.type.value == 'business_forum')
                      .length;

                  return Column(
                    children: [
                      _buildCategoryCard(
                        Icons.celebration,
                        'Rhema Feast',
                        'Annual mega gathering featuring prophetic word, worship, and impartation',
                        AppTheme.primaryGold,
                        0,
                        rhemaFeastCount,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RhemaFeastScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildCategoryCard(
                        Icons.schedule,
                        'RXP (Rhema Experience)',
                        'Transformative weekly interdenominational worship experience',
                        AppTheme.deepGold,
                        1,
                        rxpCount,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RXPScreen()),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildCategoryCard(
                        Icons.share,
                        'JKMG Evangelical Outreach',
                        'See how God is using JKMG to evangelize and transform lives',
                        AppTheme.darkGold,
                        2,
                        outreachCount,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EvangelicalOutreachScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildCategoryCard(
                        Icons.business,
                        'JKMG Business Forum',
                        'Kingdom-Based  entrepreneurs building professional networks',
                        AppTheme.successGreen,
                        3,
                        businessCount,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BusinessForumScreen(),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                loading: () => Column(
                  children: [
                    _buildCategoryCard(
                      Icons.celebration,
                      'Rhema Feast',
                      'Annual mega gathering featuring prophetic word, worship, and impartation',
                      AppTheme.primaryGold,
                      0,
                      0,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RhemaFeastScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCategoryCard(
                      Icons.schedule,
                      'RXP (Rhema Experience)',
                      'Transformative weekly interdenominational worship experience',
                      AppTheme.deepGold,
                      1,
                      0,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RXPScreen()),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCategoryCard(
                      Icons.share,
                      'JKMG Evangelical Outreach',
                      'See how God is using JKMG to evangelize and transform lives',
                      AppTheme.darkGold,
                      2,
                      0,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EvangelicalOutreachScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCategoryCard(
                      Icons.business,
                      'JKMG Business Forum',
                      'Kingdom-Based  entrepreneurs building professional networks',
                      AppTheme.successGreen,
                      3,
                      0,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BusinessForumScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
                error: (_, __) => Column(
                  children: [
                    _buildCategoryCard(
                      Icons.celebration,
                      'Rhema Feast',
                      'Annual mega gathering featuring prophetic word, worship, and impartation',
                      AppTheme.primaryGold,
                      0,
                      0,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RhemaFeastScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCategoryCard(
                      Icons.schedule,
                      'RXP (Rhema Experience)',
                      'Transformative weekly interdenominational worship experience',
                      AppTheme.deepGold,
                      1,
                      0,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RXPScreen()),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCategoryCard(
                      Icons.share,
                      'JKMG Evangelical Outreach',
                      'See how God is using JKMG to evangelize and transform lives',
                      AppTheme.darkGold,
                      2,
                      0,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EvangelicalOutreachScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCategoryCard(
                      Icons.business,
                      'JKMG Business Forum',
                      'Kingdom-Based  entrepreneurs building professional networks',
                      AppTheme.successGreen,
                      3,
                      0,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BusinessForumScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryCard(
    IconData icon,
    String title,
    String description,
    Color color,
    int index,
    int eventCount,
    VoidCallback onTap,
  ) {
    return SlideTransition(
      position:
          Tween<Offset>(
            begin: Offset(0, 0.1 + (index * 0.05)),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: _fadeController,
              curve: Interval(index * 0.1, 1.0, curve: Curves.easeOutCubic),
            ),
          ),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _fadeController,
            curve: Interval(index * 0.1, 1.0),
          ),
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.3)),
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
                Column(
                  children: [
                    if (eventCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$eventCount',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ),
                    const SizedBox(height: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: color.withOpacity(0.7),
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAllEventsSection() {
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
                title: 'All Events',
                subtitle: 'Browse all upcoming and active events',
              ),
              const SizedBox(height: 16),
              allEventsAsync.when(
                data: (response) {
                  final events = response.data;
                  if (events.isEmpty) {
                    return _buildEmptyState(
                      'No Events Available',
                      'New events will appear here when they\'re scheduled.\nCheck back soon for upcoming gatherings!',
                      Icons.event_busy_outlined,
                    );
                  }
                  var eventWidgets = events.take(3).map((event) {
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
                  }).toList();
                  if (events.length > 3) {
                    eventWidgets.add(
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: TextButton(
                          onPressed: () {
                            // TODO: Navigate to full events list
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Full events list coming soon!'),
                                backgroundColor: AppTheme.primaryGold,
                              ),
                            );
                          },
                          child: Text(
                            'View All ${events.length} Events',
                            style: const TextStyle(
                              color: AppTheme.primaryGold,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return Column(children: eventWidgets);
                },
                loading: () => _buildLoadingState('Loading Events...'),
                error: (err, _) => _buildErrorState(
                  'Connection Error',
                  'Unable to load events.\nPull down to refresh.',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMyRegistrationsSection() {
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
                title: 'My Registrations',
                subtitle: 'Events you have registered for',
              ),
              const SizedBox(height: 16),
              myRegistrationsAsync.when(
                data: (response) {
                  final registrations = response.data;
                  if (registrations.isEmpty) {
                    return _buildEmptyState(
                      'No Registrations Yet',
                      'Start exploring events and register for\nthose that interest you!',
                      Icons.event_available_outlined,
                    );
                  }

                  final events = registrations
                      .where((r) => r.event != null)
                      .map((r) => r.event!)
                      .toList();

                  if (events.isEmpty) {
                    return _buildEmptyState(
                      'Registration Issues',
                      'Some registered events couldn\'t be loaded.\nPlease try refreshing or contact support.',
                      Icons.warning_outlined,
                      color: Colors.orange,
                    );
                  }

                  var eventWidgets = events.take(3).map((event) {
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
                  }).toList();
                  if (events.length > 3) {
                    eventWidgets.add(
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: TextButton(
                          onPressed: () {
                            // TODO: Navigate to full registrations list
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Full registrations list coming soon!',
                                ),
                                backgroundColor: AppTheme.primaryGold,
                              ),
                            );
                          },
                          child: Text(
                            'View All ${events.length} Registrations',
                            style: const TextStyle(
                              color: AppTheme.primaryGold,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return Column(children: eventWidgets);
                },
                loading: () => _buildLoadingState('Loading Registrations...'),
                error: (err, _) => _buildErrorState(
                  'Load Error',
                  'Failed to load your registrations.\nPull down to try again.',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(
    String title,
    String message,
    IconData icon, {
    Color? color,
  }) {
    final stateColor = color ?? AppTheme.primaryGold;
    return Container(
      height: 220,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [stateColor.withOpacity(0.1), stateColor.withOpacity(0.05)],
        ),
        border: Border.all(color: stateColor.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: stateColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(icon, size: 48, color: stateColor.withOpacity(0.7)),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: stateColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            maxLines: 2,
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

  Widget _buildLoadingState(String message) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGold),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              color: AppTheme.primaryGold,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String title, String message) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.red.withOpacity(0.1), Colors.red.withOpacity(0.05)],
        ),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
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

class _EventPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryGold.withOpacity(0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path();

    for (int i = 0; i < 5; i++) {
      final y = (i + 1) * size.height / 6;
      path.moveTo(0, y);

      for (double x = 0; x <= size.width; x += 20) {
        final offsetY =
            y + (20 * (i % 2 == 0 ? 1 : -1)) * (0.5 + 0.5 * (x / size.width));
        if (x == 0) {
          path.moveTo(x, offsetY);
        } else {
          path.lineTo(x, offsetY);
        }
      }
    }

    canvas.drawPath(path, paint);

    for (int i = 0; i < 8; i++) {
      final center = Offset(
        (i % 4) * size.width / 4 + size.width / 8,
        (i ~/ 4) * size.height / 2 + size.height / 4,
      );

      canvas.drawCircle(
        center,
        15 + (i % 3) * 5,
        paint..color = AppTheme.primaryGold.withOpacity(0.03),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
