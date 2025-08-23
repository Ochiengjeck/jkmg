import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jkmg/models/event.dart';
import 'package:jkmg/models/registration_model.dart';
import 'package:jkmg/provider/api_providers.dart';
import 'package:jkmg/utils/app_theme.dart';
import 'event_registration_screen.dart';

class EventDetailScreen extends ConsumerStatefulWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _heroAnimationController;
  late AnimationController _contentAnimationController;
  late Animation<double> _heroFadeAnimation;
  late Animation<double> _heroSlideAnimation;
  late Animation<double> _contentFadeAnimation;

  @override
  void initState() {
    super.initState();
    _heroAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _heroFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _heroAnimationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
      ),
    );

    _heroSlideAnimation = Tween<double>(begin: -50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _heroAnimationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _contentFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _heroAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _contentAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _heroAnimationController.dispose();
    _contentAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventDetailsAsync = ref.watch(eventDetailsProvider(widget.event.id));
    final registrationAsync = ref.watch(
      isRegisteredForEventProvider(widget.event.id),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.richBlack.withOpacity(0.7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.richBlack.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: () => _showShareDialog(),
            ),
          ),
        ],
      ),
      body: eventDetailsAsync.when(
        data: (event) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeroSection(event)),
            SliverToBoxAdapter(
              child: AnimatedBuilder(
                animation: _contentFadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _contentFadeAnimation,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppTheme.richBlack,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildEventInfo(event),
                          _buildEventDescription(event),
                          _buildEventDetails(event),
                          _buildRegistrationSection(event, registrationAsync),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        loading: () => Scaffold(
          backgroundColor: AppTheme.richBlack,
          body: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGold),
            ),
          ),
        ),
        error: (error, stackTrace) => Scaffold(
          backgroundColor: AppTheme.richBlack,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.richBlack.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Error Loading Event',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Unable to load event details. Please check your connection.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.invalidate(eventDetailsProvider(widget.event.id));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGold,
                        foregroundColor: AppTheme.richBlack,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Try Again',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(Event event) {
    final DateTime startDate = DateTime.parse(event.startDate);
    final String formattedDate = DateFormat('EEEE, MMM d, y').format(startDate);
    final String formattedTime = DateFormat('h:mm a').format(startDate);

    return AnimatedBuilder(
      animation: _heroAnimationController,
      builder: (context, child) {
        return Container(
          height: 400,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(_getEventPlaceholderImage(event.type.value)),
              fit: BoxFit.fill,
            ),
          ),
          child: Stack(
            children: [
              // Gradient overlay for better text readability
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.6),
                        AppTheme.richBlack.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ),
              // Background Pattern
              Positioned.fill(
                child: CustomPaint(painter: _EventDetailPatternPainter()),
              ),
              // Content
              Positioned.fill(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 100, 24, 32),
                  child: FadeTransition(
                    opacity: _heroFadeAnimation,
                    child: Transform.translate(
                      offset: Offset(0, _heroSlideAnimation.value),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Event Category Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              _getEventCategoryLabel(event.type.value),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Event Title
                          Text(
                            event.displayTitle,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Date and Time
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      formattedTime,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Location
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  event.displayLocation,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEventInfo(Event event) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: _buildInfoCard(
              'Registrations',
              '${event.registrationCount}',
              Icons.people,
              AppTheme.primaryGold,
            ),
          ),
          const SizedBox(width: 16),
          if (event.volunteerCount > 0)
            Expanded(
              child: _buildInfoCard(
                'Volunteers',
                '${event.volunteerCount}',
                Icons.volunteer_activism,
                Colors.green,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventDescription(Event event) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.richBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
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
                  Icons.description,
                  color: AppTheme.primaryGold,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'About This Event',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            event.displayDescription,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventDetails(Event event) {
    final DateTime startDate = DateTime.parse(event.startDate);
    final DateTime endDate = DateTime.parse(event.endDate);
    final String duration = _calculateDuration(startDate, endDate);

    return Container(
      margin: const EdgeInsets.all(24),
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
              const Text(
                'Event Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Duration', duration, Icons.schedule),
          _buildDetailRow(
            'Category',
            _getEventCategoryLabel(event.type.value),
            Icons.category,
          ),
          _buildDetailRow('Event Type', event.type.label, Icons.event),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryGold.withOpacity(0.7)),
          const SizedBox(width: 16),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationSection(
    Event event,
    AsyncValue<EventRegistration?> registrationAsync,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: registrationAsync.when(
        data: (registration) => registration != null
            ? _buildRegisteredWidget(context, registration)
            : _buildRegisterButton(context),
        loading: () => Container(
          padding: const EdgeInsets.all(32),
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGold),
            ),
          ),
        ),
        error: (error, stackTrace) => _buildRegisterButton(context),
      ),
    );
  }

  Color _getEventColor(String eventType) {
    switch (eventType) {
      case 'rhema_feast':
        return const Color(0xFF8B4513);
      case 'rxp':
        return const Color(0xFF4A0080);
      case 'outreach':
        return const Color(0xFF1B5E20);
      case 'business_forum':
        return const Color(0xFF0D47A1);
      default:
        return AppTheme.primaryGold;
    }
  }

  String _getEventCategoryLabel(String eventType) {
    switch (eventType) {
      case 'rhema_feast':
        return 'RHEMA FEAST';
      case 'rxp':
        return 'RHEMA EXPERIENCE';
      case 'outreach':
        return 'EVANGELICAL OUTREACH';
      case 'business_forum':
        return 'BUSINESS FORUM';
      default:
        return 'EVENT';
    }
  }

  String _getEventPlaceholderImage(String eventType) {
    switch (eventType) {
      case 'rhema_feast':
        return 'assets/images/RhemaFeastPlaceholder.png';
      case 'rxp':
        return 'assets/images/RxpPlaceholder.png';
      case 'outreach':
        return 'assets/images/Outreachplaceholder.png';
      case 'business_forum':
        return 'assets/images/BusinessForumPlaceholder.png';
      default:
        return 'assets/images/events.png'; // fallback to generic events image
    }
  }

  String _calculateDuration(DateTime start, DateTime end) {
    final difference = end.difference(start);
    if (difference.inDays > 0) {
      return '${difference.inDays + 1} day${difference.inDays > 0 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''}';
    } else {
      return '${difference.inMinutes} minutes';
    }
  }

  void _showShareDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.richBlack,
        title: const Text('Share Event', style: TextStyle(color: Colors.white)),
        content: Text(
          'Share "${widget.event.title}" with friends and family!',
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Add share functionality here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGold,
              foregroundColor: AppTheme.richBlack,
            ),
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => EventRegistrationScreen(event: widget.event),
            ),
          );

          // If registration was successful, refresh the current event data
          if (result == true && mounted) {
            // Force refresh the event detail and registration status
            ref.invalidate(eventDetailsProvider(widget.event.id));
            ref.invalidate(isRegisteredForEventProvider(widget.event.id));
            ref.invalidate(allEventsProvider);
            ref.invalidate(myRegistrationsProvider);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryGold,
          foregroundColor: AppTheme.richBlack,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.event_available),
        label: const Text(
          'Register for Event',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildRegisteredWidget(
    BuildContext context,
    EventRegistration registration,
  ) {
    return Column(
      children: [
        // Registration Status Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4CAF50).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Color(0xFF4CAF50),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'You\'re Registered!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Registered on ${_formatRegistrationDate(registration.registeredAt)}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildRegistrationDetails(registration),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Unregister Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _showUnregisterDialog(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.event_busy),
            label: const Text(
              'Cancel Registration',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationDetails(EventRegistration registration) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Attendance Mode:',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
              Text(
                registration.attendance.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (registration.volunteer) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.volunteer_activism,
                  color: Colors.white.withOpacity(0.9),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Volunteering for this event',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatRegistrationDate(DateTime dateTime) {
    return DateFormat('MMM d, y').format(dateTime);
  }

  void _showUnregisterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.richBlack,
        title: const Text(
          'Cancel Registration',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Unregister functionality is coming soon! You will be able to cancel your event registration in the next update.',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Got it',
              style: TextStyle(color: AppTheme.primaryGold),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventDetailPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Create elegant flowing patterns
    for (int i = 0; i < 8; i++) {
      final path = Path();
      final startY = i * size.height / 8;
      final amplitude = 40.0 + (i % 3) * 20;

      path.moveTo((-amplitude), startY);
      path.quadraticBezierTo(
        size.width * 0.25,
        startY + (i % 2 == 0 ? -amplitude : amplitude),
        size.width * 0.5,
        startY,
      );
      path.quadraticBezierTo(
        size.width * 0.75,
        startY + (i % 2 == 0 ? amplitude : -amplitude),
        size.width + amplitude,
        startY,
      );

      canvas.drawPath(path, paint..strokeWidth = 1 + (i % 3));
    }

    // Add elegant geometric shapes
    final circlePaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 15; i++) {
      final x = (i % 5) * size.width / 5 + size.width / 10;
      final y = (i ~/ 5) * size.height / 3 + size.height / 6;
      final radius = 8.0 + (i % 4) * 4;

      canvas.drawCircle(Offset(x, y), radius, circlePaint);

      // Add inner circles
      canvas.drawCircle(
        Offset(x, y),
        radius * 0.4,
        paint..color = Colors.white.withOpacity(0.15),
      );
    }

    // Add diagonal lines
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..strokeWidth = 1;

    for (int i = 0; i < 10; i++) {
      final startX = i * size.width / 10;
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + size.height * 0.3, size.height),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
