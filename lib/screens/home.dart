import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jkmg/provider/api_providers.dart';
import 'package:jkmg/models/event.dart';
// import 'package:jkmg/widgets/youtube_video_player.dart';  // Temporarily disabled for Windows build

import '../auth/log_in.dart';
import 'about/about_screen.dart';
import 'bible_study/bible_study_corner.dart';
import 'commonwealth/kingdom_commonwealth_screen.dart';
import 'contact/contact_screen.dart';
import 'counceling/counseling_corner.dart';
import 'giving/partnership_giving_screen.dart';
import 'prayer/prayer_plan_screen.dart';
import 'package:jkmg/screens/events/event_list_screen.dart';
import 'profile/profile_screen.dart';
import 'settings/settings_screen.dart';
import 'help/help_support_screen.dart';

import 'resources/jkmg_resources_screen.dart';
import 'salvation/salvation_corner.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _notificationCount = 3; // Example notification count
  int _currentPage = 0;
  late PageController pageController;
  late PageController heroPageController;
  late Timer autoScrollTimer;
  int currentHeroPage = 0;

  final List<Map<String, dynamic>> _menuPages = [
    {'title': 'Home', 'icon': Icons.home},
    {'title': 'About', 'icon': Icons.info},
    {'title': 'Rhema Prayer Plan', 'icon': Icons.access_time},
    {'title': 'Bible Study Corner', 'icon': Icons.book},
    {'title': 'Salvation Corner', 'icon': Icons.favorite},
    {'title': 'Counseling & Care', 'icon': Icons.support},
    {'title': 'JKMG Resources', 'icon': Icons.library_books},
    {'title': 'Events & Announcements', 'icon': Icons.event},
    {'title': 'Partnership & Giving', 'icon': Icons.volunteer_activism},
    {'title': 'Kingdom Commonwealth', 'icon': Icons.public},
    {'title': 'Coming Soon', 'icon': Icons.hourglass_top},
    {'title': 'Contact Us', 'icon': Icons.contact_mail},
    {'title': 'Profile', 'icon': Icons.person},
    {'title': 'Settings', 'icon': Icons.settings},
    {'title': 'Help & Support', 'icon': Icons.help_outline},
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    heroPageController = PageController();
    _startAutoScroll();
  }

  @override
  void dispose() {
    pageController.dispose();
    heroPageController.dispose();
    autoScrollTimer.cancel();
    super.dispose();
  }

  void _startAutoScroll() {
    autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted && heroPageController.hasClients) {
        currentHeroPage = (currentHeroPage + 1) % _getHeroSlides().length;
        heroPageController.animateToPage(
          currentHeroPage,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _pauseAutoScroll() {
    if (autoScrollTimer.isActive) {
      autoScrollTimer.cancel();
      // Restart after 10 seconds of inactivity
      Timer(const Duration(seconds: 10), () {
        if (mounted && !autoScrollTimer.isActive) {
          _startAutoScroll();
        }
      });
    }
  }

  void navigateToPage(int pageIndex) {
    setState(() {
      _currentPage = pageIndex;
    });
    pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(context, ref),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          _buildLandingPage(context),
          AboutScreen(),
          PrayerPlanScreen(),
          BibleStudyCornerScreen(),
          SalvationCornerScreen(),
          CounselingCornerScreen(),
          JKMGResourcesScreen(),
          EventListScreen(),
          PartnershipGivingScreen(),
          KingdomCommonwealthScreen(),
          _buildPlaceholderPage(context, _menuPages[10]),
          ContactScreen(),
          ProfileScreen(),
          SettingsScreen(),
          HelpSupportScreen(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width - 200,
            child: Text(
              _menuPages[_currentPage]['title'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,

              style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                color: const Color(0xFFB8860B),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFFFFD700)
              : const Color(0xFFB8860B),
        ),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.notifications_outlined,
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFFFFD700)
                    : const Color(0xFFB8860B),
              ),
              onPressed: () => _showNotifications(context),
            ),
            if (_notificationCount > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Text(
                    '$_notificationCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        IconButton(
          icon: Icon(
            Icons.logout_outlined,
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFFFFD700)
                : const Color(0xFFB8860B),
          ),
          onPressed: () => _showLogoutDialog(context, ref),
          tooltip: 'Logout',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context, WidgetRef ref) {
    final _user = ref.watch(currentUserProvider).value;
    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: Theme.of(context).brightness == Brightness.dark
                ? [
                    const Color(0xFF0A0A0A),
                    const Color(0xFF1A1A1A),
                    const Color(0xFF0F0F0F),
                  ]
                : [
                    const Color(0xFFFAFAFA),
                    const Color(0xFFFFFFFF),
                    const Color(0xFFF5F5F5),
                  ],
          ),
        ),
        child: Column(
          children: [
            _buildDrawerHeader(context, _user),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildDrawerSection(
                          context,
                          title: 'Main Features',
                          icon: Icons.dashboard_rounded,
                          items: [
                            _DrawerItem(
                              icon: Icons.home_rounded,
                              title: 'Home',
                              onTap: () => navigateToPage(0),
                            ),
                            _DrawerItem(
                              icon: Icons.schedule_rounded,
                              title: 'Rhema Prayer Plan',
                              onTap: () => navigateToPage(2),
                            ),
                            _DrawerItem(
                              icon: Icons.menu_book_rounded,
                              title: 'Bible Study Corner',
                              onTap: () => navigateToPage(3),
                            ),
                            _DrawerItem(
                              icon: Icons.favorite_rounded,
                              title: 'Salvation Corner',
                              onTap: () => navigateToPage(4),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildDrawerSection(
                          context,
                          title: 'Services & Resources',
                          icon: Icons.support_rounded,
                          items: [
                            _DrawerItem(
                              icon: Icons.psychology_rounded,
                              title: 'Counseling & Care',
                              onTap: () => navigateToPage(5),
                            ),
                            _DrawerItem(
                              icon: Icons.library_books_rounded,
                              title: 'JKMG Resources',
                              onTap: () => navigateToPage(6),
                            ),
                            _DrawerItem(
                              icon: Icons.event_rounded,
                              title: 'Events & Announcements',
                              onTap: () => navigateToPage(7),
                              isNew: true,
                            ),
                            _DrawerItem(
                              icon: Icons.volunteer_activism_rounded,
                              title: 'Partnership & Giving',
                              onTap: () => navigateToPage(8),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildDrawerSection(
                          context,
                          title: 'Community',
                          icon: Icons.groups_rounded,
                          items: [
                            _DrawerItem(
                              icon: Icons.public_rounded,
                              title: 'Kingdom Commonwealth',
                              onTap: () => navigateToPage(9),
                            ),
                            _DrawerItem(
                              icon: Icons.contact_support_rounded,
                              title: 'Contact Us',
                              onTap: () => navigateToPage(11),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildDivider(context),
                        const SizedBox(height: 24),
                        _buildDrawerSection(
                          context,
                          title: 'Account & Settings',
                          icon: Icons.settings_rounded,
                          items: [
                            _DrawerItem(
                              icon: Icons.person_rounded,
                              title: 'Profile',
                              onTap: () => navigateToPage(12),
                            ),
                            // _DrawerItem(
                            //   icon: Icons.notifications_rounded,
                            //   title: 'Notifications',
                            //   onTap: () => _showNotifications(context),
                            // ),
                            _DrawerItem(
                              icon: Icons.tune_rounded,
                              title: 'Settings',
                              onTap: () => navigateToPage(13),
                            ),
                            _DrawerItem(
                              icon: Icons.help_outline_rounded,
                              title: 'Help & Support',
                              onTap: () => navigateToPage(14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildDivider(context),
                        const SizedBox(height: 16),
                        _buildDrawerSection(
                          context,
                          title: 'Account',
                          icon: Icons.logout_rounded,
                          items: [
                            _DrawerItem(
                              icon: Icons.logout_rounded,
                              title: 'Logout',
                              onTap: () {
                                Navigator.of(
                                  context,
                                ).pop(); // Close drawer first
                                _showLogoutDialog(context, ref);
                              },
                              isDestructive: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, dynamic user) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 300,
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF2D1810),
                  const Color(0xFF1A1A1A),
                  const Color(0xFF0A0A0A),
                ]
              : [
                  const Color(0xFFFFE066),
                  const Color(0xFFFFD700),
                  const Color(0xFFDAA520),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : const Color(0xFFDAA520))
                .withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Glassmorphism overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(isDark ? 0.05 : 0.2),
                    Colors.white.withOpacity(isDark ? 0.02 : 0.1),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Profile Avatar with  design
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.white.withOpacity(0.15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            'assets/icon/icon.png',
                            width: 44,
                            height: 44,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Ministry Name with  typography
                    Text(
                      'JKMG Ministry',
                      style: TextStyle(
                        color: isDark ? const Color(0xFFFFE066) : Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Subtitle with better contrast
                    Text(
                      'Transforming lives through God\'s Word',
                      style: TextStyle(
                        color: isDark
                            ? Colors.white.withOpacity(0.8)
                            : Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // User info if available
                    if (user?.name != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Welcome, ${user?.name}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.95),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<_DrawerItem> items,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.03)
            : Colors.black.withOpacity(0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.black.withOpacity(0.06),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFFFFE066).withOpacity(0.1)
                        : const Color(0xFFDAA520).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 16,
                    color: isDark
                        ? const Color(0xFFFFE066)
                        : const Color(0xFFDAA520),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFFFFE066)
                        : const Color(0xFFDAA520),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          // Section Items
          ...items.map((item) => _buildDrawerTile(context, item)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildDrawerTile(BuildContext context, _DrawerItem item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.pop(context);
            item.onTap();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Icon with  styling
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: item.isDestructive == true
                        ? Colors.red.shade400.withOpacity(0.1)
                        : isDark
                        ? const Color(0xFFFFE066).withOpacity(0.1)
                        : const Color(0xFFDAA520).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    item.icon,
                    color: item.isDestructive == true
                        ? Colors.red.shade400
                        : isDark
                        ? const Color(0xFFDAA520)
                        : const Color(0xFFB8860B),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                // Title
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      color: item.isDestructive == true
                          ? Colors.red.shade400
                          : isDark
                          ? Colors.white
                          : Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
                ),
                // Badge for new items
                if (item.isNew == true)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B6B),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'NEW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                // Arrow icon
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isDark
                      ? Colors.white.withOpacity(0.4)
                      : Colors.black.withOpacity(0.4),
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.1),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildLandingPage(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSlidingHeroSection(context),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeMessageFromPastor(context),
                  const SizedBox(height: 24),
                  _buildQuickActions(context),
                  const SizedBox(height: 24),
                  _buildMainMenuGrid(context),
                  const SizedBox(height: 24),
                  _buildUpcomingEvents(context),
                  const SizedBox(height: 24),
                  _buildMinistryHighlights(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlidingHeroSection(BuildContext context) {
    final slides = _getHeroSlides();

    return SizedBox(
      height: 400,
      child: Stack(
        children: [
          GestureDetector(
            onPanStart: (_) => _pauseAutoScroll(),
            child: PageView.builder(
              controller: heroPageController,
              itemCount: slides.length,
              onPageChanged: (index) {
                setState(() {
                  currentHeroPage = index;
                });
              },
              itemBuilder: (context, index) {
                return slides[index];
              },
            ),
          ),
          // Page indicators
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                slides.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentHeroPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentHeroPage == index
                        ? const Color(0xFFFFD700)
                        : Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          // Auto-scroll pause button
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: GestureDetector(
                onTap: () {
                  if (autoScrollTimer.isActive) {
                    autoScrollTimer.cancel();
                  } else {
                    _startAutoScroll();
                  }
                  setState(() {});
                },
                child: Icon(
                  autoScrollTimer.isActive ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getHeroSlides() {
    return [
      _buildImageHeroSlide(
        context: context,
        imagePath: 'assets/images/rhemafeast1.jpg',
        title: 'RHEMA FEAST 2025',
        subtitle: 'ARE YOU READY?',
        description: 'I WILL BUILD MY CHURCH',
        actionText: 'SEPTEMBER 1-5, 2025 • UHURU PARK',
        onTap: () => _handleHeroSlideClick('rhema_feast'),
      ),
      _buildImageHeroSlide(
        context: context,
        imagePath: 'assets/images/rhemafeast2.jpg',
        title: 'POWERFUL MINISTRY',
        subtitle: 'MEET THE SPEAKERS',
        description: 'SINACH • JOSHUA • JULIAN • NATHANIEL',
        actionText:
            'Join us for transformative worship\nand prophetic ministry',
        onTap: () => _handleHeroSlideClick('speakers'),
      ),
      _buildImageHeroSlide(
        context: context,
        imagePath: 'assets/images/rhemafeast3.jpg',
        title: 'EXPERIENCE RHEMA',
        subtitle: 'LIVE ENCOUNTER',
        description: 'Prophetic Word • Divine Healing • Impartation',
        actionText: 'Register now and be part\nof this historic gathering',
        onTap: () => _handleHeroSlideClick('registration'),
      ),
      _buildImageHeroSlide(
        context: context,
        imagePath: 'assets/images/Picture1.png',
        title: 'JKMG MINISTRY',
        subtitle: 'TRANSFORMING NATIONS',
        description: 'Through God\'s Word & Apostolic Insight',
        actionText:
            'Discover our vision and mission\nfor global transformation',
        onTap: () => _handleHeroSlideClick('about'),
      ),
      _buildImageHeroSlide(
        context: context,
        imagePath: 'assets/images/download.jpeg',
        title: 'STAY CONNECTED',
        subtitle: 'JOIN OUR COMMUNITY',
        description: 'Daily Inspiration • Prayer Requests • Testimonies',
        actionText: 'Follow us on all platforms\nfor spiritual growth content',
        onTap: () => _handleHeroSlideClick('social'),
      ),
      _buildIntroVideoSlide(context),
    ];
  }

  Widget _buildHeroSlide(
    BuildContext context,
    String imagePath,
    String topText,
    String mainTitle,
    String subtitle,
    String bottomText,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF87CEEB).withOpacity(0.8), // Sky blue
            const Color(0xFFFFE066).withOpacity(0.9), // Golden sunset
            const Color(0xFF1A1A2E).withOpacity(0.9), // Deep navy
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                topText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  mainTitle,
                  style: const TextStyle(
                    color: Color(0xFF1A1A2E),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                bottomText,
                style: const TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntroVideoSlide(BuildContext context) {
    return GestureDetector(
      onTap: () => _showVideoDialog(context),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A1A), Color(0xFF2A2A2A)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.play_arrow,
                size: 50,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'WELCOME TO JKMG',
              style: TextStyle(
                color: Color(0xFFFFD700),
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Watch Our Introductory Video',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_circle_fill, color: Color(0xFF1A1A1A)),
                  SizedBox(width: 8),
                  Text(
                    'Play Video',
                    style: TextStyle(
                      color: Color(0xFF1A1A1A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.touch_app, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Tap anywhere to play',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeMessageFromPastor(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF1A1A1A), const Color(0xFF2A2A2A)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withOpacity(0.2),
            blurRadius: 20,
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
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withOpacity(0.4),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.record_voice_over,
                  size: 30,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Message',
                      style: TextStyle(
                        color: Color(0xFFFFD700),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'From Rev. Julian Kyula',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Welcome to Julian Kyula Ministry Global (JKMG) - a faith-driven movement dedicated to transforming lives and nations through the power of God\'s Word, apostolic insight, and marketplace impact.',
            style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Play pre-recorded welcome message
                    _playWelcomeMessage(context);
                  },
                  icon: const Icon(Icons.play_circle_fill),
                  label: const Text('Play Message'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    foregroundColor: const Color(0xFF1A1A1A),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => navigateToPage(1), // Navigate to About
                  icon: const Icon(Icons.info_outline),
                  label: const Text('Learn More'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFFFD700),
                    side: const BorderSide(color: Color(0xFFFFD700)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Access',
          style: TextStyle(
            color: const Color(0xFFFFD700),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                context,
                icon: Icons.schedule,
                title: 'Rhema Prayer\nPlan',
                subtitle: 'Daily guidance',
                color: const Color(0xFFFF6B6B),
                onTap: () => navigateToPage(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                context,
                icon: Icons.menu_book,
                title: 'Bible Study\nCorner',
                subtitle: 'Grow deeper',
                color: const Color(0xFF4ECDC4),
                onTap: () => navigateToPage(3),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                context,
                icon: Icons.favorite,
                title: 'Salvation\nCorner',
                subtitle: 'Find Jesus',
                color: const Color(0xFFFFE066),
                onTap: () => navigateToPage(4),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMainMenuGrid(BuildContext context) {
    final menuItems = [
      {
        'title': 'About JKMG',
        'icon': Icons.info_outline,
        'color': const Color(0xFF6C5CE7),
        'page': 1,
      },
      {
        'title': 'Counseling\n& Care',
        'icon': Icons.psychology,
        'color': const Color(0xFF00CEC9),
        'page': 5,
      },
      {
        'title': 'JKMG\nResources',
        'icon': Icons.library_books,
        'color': const Color(0xFF00B894),
        'page': 6,
      },
      {
        'title': 'Events &\nAnnouncements',
        'icon': Icons.event,
        'color': const Color(0xFFE17055),
        'page': 7,
      },
      {
        'title': 'Partnership\n& Giving',
        'icon': Icons.volunteer_activism,
        'color': const Color(0xFFFD79A8),
        'page': 8,
      },
      {
        'title': 'Kingdom\nCommonwealth',
        'icon': Icons.account_balance,
        'color': const Color(0xFF0984E3),
        'page': 9,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Explore JKMG',
              style: TextStyle(
                color: const Color(0xFFFFD700),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // Show all features
                _scaffoldKey.currentState?.openDrawer();
              },
              child: const Text(
                'View All',
                style: TextStyle(color: Color(0xFFFFD700)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            final item = menuItems[index];
            return _buildMainMenuCard(
              context,
              title: item['title'] as String,
              icon: item['icon'] as IconData,
              color: item['color'] as Color,
              onTap: () => navigateToPage(item['page'] as int),
            );
          },
        ),
      ],
    );
  }

  Widget _buildUpcomingEvents(BuildContext context) {
    final allEventsAsync = ref.watch(allEventsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming Events',
              style: TextStyle(
                color: const Color(0xFFFFD700),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => navigateToPage(7),
              child: const Text(
                'View All',
                style: TextStyle(color: Color(0xFFFFD700)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 165,
          child: allEventsAsync.when(
            data: (response) {
              final upcomingEvents = response.data
                  .where((event) => event.isUpcoming || event.isActive)
                  .take(5)
                  .toList();

              if (upcomingEvents.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_busy,
                        size: 48,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No upcoming events',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: upcomingEvents.length,
                itemBuilder: (context, index) {
                  final event = upcomingEvents[index];
                  return _buildDatabaseEventCard(context, event);
                },
              );
            },
            loading: () => ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(3, (index) => _buildEventSkeletonCard()),
            ),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Failed to load events',
                    style: TextStyle(color: Colors.red.shade400, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMinistryHighlights(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ministry Highlights',
          style: TextStyle(
            color: const Color(0xFFFFD700),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildHighlightCard(
                '50K+',
                'Lives Transformed',
                Icons.people,
                const Color(0xFF00CEC9),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildHighlightCard(
                '25+',
                'Countries Reached',
                Icons.public,
                const Color(0xFF6C5CE7),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildHighlightCard(
                '1000+',
                'Prayer Partners',
                Icons.handshake,
                const Color(0xFFE17055),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.3)),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.format_quote,
                color: Color(0xFFFFD700),
                size: 32,
              ),
              const SizedBox(height: 8),
              const Text(
                '"God is raising a generation that will transform nations through Kingdom principles. JKMG stands as a lighthouse, guiding believers into their apostolic destiny and marketplace influence."',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                '— Rev. Julian Kyula, JKMG Founder',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper method to play welcome message (placeholder for now)
  void _playWelcomeMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Welcome Message'),
        content: const Text(
          'Playing welcome message from Rev. Julian Kyula...\n\nThis feature will integrate with audio player for pre-recorded messages.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 9, color: Colors.grey.shade400),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainMenuCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(
    BuildContext context,
    String title,
    String date,
    String location,
    String imagePath,
    Color accentColor,
  ) {
    return Container(
      width: 200,
      height: 165, // Fixed height to match parent container
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accentColor.withOpacity(0.3),
                  accentColor.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Center(
              child: Icon(Icons.event, color: accentColor, size: 32),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  location,
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightCard(
    String number,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            number,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  void _handleHeroSlideClick(String slideType) {
    switch (slideType) {
      case 'rhema_feast':
      case 'speakers':
      case 'registration':
        navigateToPage(7); // Navigate to events
        break;
      case 'about':
        navigateToPage(1); // Navigate to about
        break;
      case 'social':
        _showSocialMediaDialog();
        break;
      default:
        break;
    }
  }

  void _showSocialMediaDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connect with JKMG'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.share, size: 64, color: Color(0xFFFFD700)),
            SizedBox(height: 16),
            Text(
              'Follow us on social media for daily inspiration, prayer requests, and testimonies.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              '• Facebook: Julian Kyula Ministry Global\n• Instagram: @jkmg_official\n• YouTube: JKMG TV\n• Twitter: @jkmg_global',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildImageHeroSlide({
    required BuildContext context,
    required String imagePath,
    required String title,
    required String subtitle,
    required String description,
    required String actionText,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD700).withOpacity(0.4),
              blurRadius: 30,
              offset: const Offset(0, 15),
              spreadRadius: 5,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Full background image
              Positioned.fill(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF87CEEB).withOpacity(0.8),
                            const Color(0xFFFFE066).withOpacity(0.9),
                            const Color(0xFF1A1A2E).withOpacity(0.9),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.white,
                          size: 64,
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Enhanced gradient overlay for better text readability
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFFFFD700).withOpacity(0.1),
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withOpacity(0.4),
                        Colors.black.withOpacity(0.8),
                        const Color(0xFF0A0A0A).withOpacity(0.95),
                      ],
                      stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
                    ),
                  ),
                ),
              ),
              // Premium floating explore button
              Positioned(
                top: 20,
                right: 20,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.9, end: 1.1),
                  duration: const Duration(milliseconds: 1500),
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFFFD700),
                              const Color(0xFFFFE066),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.6),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFD700).withOpacity(0.6),
                              blurRadius: 12,
                              spreadRadius: 3,
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.touch_app,
                              color: Color(0xFF1A1A2E),
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'EXPLORE',
                              style: TextStyle(
                                color: Color(0xFF1A1A2E),
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Elegant corner accent
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.topLeft,
                      radius: 1.0,
                      colors: [
                        const Color(0xFFFFD700).withOpacity(0.6),
                        const Color(0xFFFFD700).withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                    ),
                  ),
                ),
              ),
              // Content positioned at bottom with improved spacing
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        const Color(0xFF0A0A0A).withOpacity(0.85),
                        const Color(0xFF0A0A0A).withOpacity(0.95),
                        const Color(0xFF1A1A1A),
                      ],
                      stops: const [0.0, 0.3, 0.7, 1.0],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    border: Border(
                      left: BorderSide(
                        color: const Color(0xFFFFD700).withOpacity(0.3),
                        width: 2,
                      ),
                      right: BorderSide(
                        color: const Color(0xFFFFD700).withOpacity(0.3),
                        width: 2,
                      ),
                      bottom: BorderSide(
                        color: const Color(0xFFFFD700).withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Subtle background pattern
                      Positioned.fill(
                        child: CustomPaint(painter: _HeroPatternPainter()),
                      ),
                      // Content with enhanced styling
                      Padding(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Elegant subtitle badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.2),
                                    Colors.white.withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                subtitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 2.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Premium 3D title
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFFFFD700),
                                    const Color(0xFFFFE066),
                                    const Color(0xFFDAA520),
                                    const Color(0xFFB8860B),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(35),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFFFD700,
                                    ).withOpacity(0.7),
                                    blurRadius: 20,
                                    spreadRadius: 4,
                                    offset: const Offset(0, 6),
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                title,
                                style: const TextStyle(
                                  color: Color(0xFF1A1A2E),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1.5, 1.5),
                                      blurRadius: 3,
                                      color: Color(0xFFB8860B),
                                    ),
                                    Shadow(
                                      offset: Offset(-0.5, -0.5),
                                      blurRadius: 1,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 14),
                            // Enhanced description with better styling
                            Text(
                              description,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.95),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.8,
                                height: 1.5,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(0, 2),
                                    blurRadius: 4,
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            // Premium action text with enhanced styling
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFFFFD700).withOpacity(0.25),
                                    const Color(0xFFFFE066).withOpacity(0.15),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: const Color(
                                    0xFFFFD700,
                                  ).withOpacity(0.6),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFFFD700,
                                    ).withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    color: const Color(0xFFFFD700),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      actionText,
                                      style: const TextStyle(
                                        color: Color(0xFFFFD700),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.8,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(0, 1),
                                            blurRadius: 2,
                                            color: Colors.black54,
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVideoDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 40,
            maxHeight: MediaQuery.of(context).size.height - 100,
          ),
          child: Stack(
            children: [
              // Video Player
              // YouTubeVideoPlayer(
              //   videoUrl: 'https://youtu.be/N-NJyLkJYPw?t=1935',
              //   title: 'Welcome to JKMG Ministry',
              //   description: 'Join Rev. Julian Kyula as he shares the vision and mission of Julian Kyula Ministry Global (JKMG). Discover how we are transforming lives and nations through the power of God\'s Word, apostolic insight, and marketplace impact. This introductory video will give you a comprehensive overview of our ministry, our core values, and the divine mandate we carry to build God\'s Kingdom across the globe.',
              // ),

              // Close Button
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatabaseEventCard(BuildContext context, Event event) {
    final formattedDate = _formatEventDate(event.startDate, event.endDate);
    final eventColor = _getEventTypeColor(event.type.value);

    return GestureDetector(
      onTap: () {
        // Navigate to event detail screen or specific event screen
        navigateToPage(7); // Navigate to events list for now
      },
      child: Container(
        width: 200,
        height: 165,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: eventColor.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event banner or gradient header
            Container(
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    eventColor.withOpacity(0.3),
                    eventColor.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  if (event.bannerUrl != null && event.bannerUrl!.isNotEmpty)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.network(
                        event.bannerUrl!,
                        width: double.infinity,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: eventColor.withOpacity(0.1),
                          child: Center(
                            child: Icon(
                              _getEventTypeIcon(event.type.value),
                              color: eventColor,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    Center(
                      child: Icon(
                        _getEventTypeIcon(event.type.value),
                        color: eventColor,
                        size: 32,
                      ),
                    ),
                  // Status badges
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (event.isActive)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'LIVE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (event.hasLivestream && !event.isActive)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.videocam,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Event details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    event.displayTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      color: eventColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    event.displayLocation,
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventSkeletonCard() {
    return Container(
      width: 200,
      height: 165,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 13,
                  width: 140,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 11,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  height: 10,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatEventDate(String startDate, String endDate) {
    try {
      final start = DateTime.parse(startDate);
      final end = DateTime.parse(endDate);

      if (start.day == end.day &&
          start.month == end.month &&
          start.year == end.year) {
        return DateFormat('MMM d, y').format(start);
      } else if (start.month == end.month && start.year == end.year) {
        return '${DateFormat('MMM d').format(start)}-${DateFormat('d, y').format(end)}';
      } else {
        return '${DateFormat('MMM d').format(start)} - ${DateFormat('MMM d, y').format(end)}';
      }
    } catch (e) {
      return 'Date TBD';
    }
  }

  Color _getEventTypeColor(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'rhema_feast':
        return const Color(0xFFFF6B6B);
      case 'rxp':
        return const Color(0xFF4ECDC4);
      case 'business_forum':
        return const Color(0xFF6C5CE7);
      case 'outreach':
        return const Color(0xFF00B894);
      default:
        return const Color(0xFFFFD700);
    }
  }

  IconData _getEventTypeIcon(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'rhema_feast':
        return Icons.celebration;
      case 'rxp':
        return Icons.schedule;
      case 'business_forum':
        return Icons.business;
      case 'outreach':
        return Icons.share;
      default:
        return Icons.event;
    }
  }

  Widget _buildPlaceholderPage(
    BuildContext context,
    Map<String, dynamic> pageData,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: Theme.of(context).brightness == Brightness.dark
              ? [
                  const Color(0xFF000000),
                  const Color(0xFF1A1A1A),
                  const Color(0xFF000000),
                ]
              : [
                  const Color(0xFFFFF8DC),
                  const Color(0xFFFFD700).withOpacity(0.3),
                  const Color(0xFFFFF8DC),
                ],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                pageData['icon'],
                size: 64,
                color: const Color(0xFFD4AF37).withOpacity(0.7),
              ),
              const SizedBox(height: 16),
              Text(
                pageData['title'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4AF37),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Swipe to explore more',
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFFD4AF37).withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.event, color: Color(0xFFB8860B)),
              title: const Text('Prayer Meeting Tonight'),
              subtitle: const Text('Join us at 7:00 PM'),
              trailing: IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () => setState(() => _notificationCount--),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.book, color: Color(0xFFB8860B)),
              title: const Text('New Bible Study Available'),
              subtitle: const Text('Romans Chapter 8'),
              trailing: IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () => setState(() => _notificationCount--),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.volunteer_activism,
                color: Color(0xFFB8860B),
              ),
              title: const Text('Partnership Opportunity'),
              subtitle: const Text('Support our mission'),
              trailing: IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () => setState(() => _notificationCount--),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade400.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: Colors.red.shade400,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Logout',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to logout? You will need to sign in again to access your account.',
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade400
                      : Colors.grey.shade600,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _performLogout(context, ref);
              },
              icon: const Icon(Icons.logout_rounded, size: 16),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performLogout(BuildContext context, WidgetRef ref) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB8860B)),
          ),
        ),
      );

      // Call logout API
      await ref.read(logoutProvider.future);

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to logout: ${e.toString()}'),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}

class _DrawerItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool? isNew;
  final bool? isDestructive;

  _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isNew,
    this.isDestructive,
  });
}

class _HeroPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw diagonal grid pattern
    for (double i = 0; i < size.width + size.height; i += 30) {
      canvas.drawLine(
        Offset(i - size.height, 0),
        Offset(i, size.height),
        paint,
      );
    }

    // Draw subtle dots pattern
    final dotPaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.03)
      ..style = PaintingStyle.fill;

    for (double x = 15; x < size.width; x += 30) {
      for (double y = 15; y < size.height; y += 30) {
        canvas.drawCircle(Offset(x, y), 1, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
