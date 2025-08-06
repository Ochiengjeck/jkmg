import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jkmg/provider/api_providers.dart';

import '../utils/constants.dart';
import '../utils/helpers.dart';
import 'bible_study/bible_study_corner.dart';
import 'prayer/prayer_plan_screen.dart';
import 'package:jkmg/screens/events/event_list_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _notificationCount = 3; // Example notification count
  int _currentPage = 0;

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
  ];

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentuser = ref.watch(currentUserProvider);
    final todaybiblestudy = ref.watch(todaysBibleStudyProvider).value;
    final todayStudyAsync = ref.watch(todaysBibleStudyProvider);
    final eventsAsync = ref.watch(eventsProvider({'per_page': 15}));
    final resourcesAsync = ref.watch(resourcesProvider({'per_page': 15}));
    final testimoniesAsync = ref.watch(testimoniesProvider({'per_page': 15}));
    final feedbackTypesAsync = ref.watch(feedbackTypesProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(context),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          _buildLandingPage(context),
          _buildPlaceholderPage(context, _menuPages[1]),
          PrayerPlanScreen(),
          BibleStudyCornerScreen(),
          _buildPlaceholderPage(context, _menuPages[4]),
          _buildPlaceholderPage(context, _menuPages[5]),
          _buildPlaceholderPage(context, _menuPages[6]),
          //_buildPlaceholderPage(context, _menuPages[7]), // events page
          EventListScreen(),
          _buildPlaceholderPage(context, _menuPages[8]),
          _buildPlaceholderPage(context, _menuPages[9]),
          _buildPlaceholderPage(context, _menuPages[10]),
          _buildPlaceholderPage(context, _menuPages[11]),
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
            width: MediaQuery.of(context).size.width - 140,
            child: Text(
              _menuPages[_currentPage]['title'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,

              style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                color: const Color(0xFFB8860B),
                fontSize: 24,
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
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1A1A1A)
          : Colors.white,
      child: Column(
        children: [
          _buildDrawerHeader(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerSection(
                  context,
                  title: 'Main Features',
                  items: [
                    _DrawerItem(
                      icon: Icons.home,
                      title: 'Home',
                      onTap: () => navigateToPage(0),
                    ),
                    // _DrawerItem(
                    //   icon: Icons.info,
                    //   title: 'About',
                    //   onTap: () => navigateToPage(1),
                    // ),
                    _DrawerItem(
                      icon: Icons.access_time,
                      title: 'Rhema Prayer Plan',
                      onTap: () => navigateToPage(2),
                    ),
                    _DrawerItem(
                      icon: Icons.book,
                      title: 'Bible Study Corner',
                      onTap: () => navigateToPage(3),
                    ),
                    _DrawerItem(
                      icon: Icons.favorite,
                      title: 'Salvation Corner',
                      onTap: () => navigateToPage(4),
                    ),
                  ],
                ),
                _buildDrawerSection(
                  context,
                  title: 'Services & Resources',
                  items: [
                    _DrawerItem(
                      icon: Icons.support,
                      title: 'Counseling & Care',
                      onTap: () => navigateToPage(5),
                    ),
                    _DrawerItem(
                      icon: Icons.library_books,
                      title: 'JKMG Resources',
                      onTap: () => navigateToPage(6),
                    ),
                    _DrawerItem(
                      icon: Icons.event,
                      title: 'Events & Announcements',
                      onTap: () => navigateToPage(7),
                    ),
                    _DrawerItem(
                      icon: Icons.volunteer_activism,
                      title: 'Partnership & Giving',
                      onTap: () => navigateToPage(8),
                    ),
                  ],
                ),
                _buildDrawerSection(
                  context,
                  title: 'Community',
                  items: [
                    _DrawerItem(
                      icon: Icons.public,
                      title: 'Kingdom Commonwealth',
                      onTap: () => navigateToPage(9),
                    ),
                    _DrawerItem(
                      icon: Icons.contact_mail,
                      title: 'Contact Us',
                      onTap: () => navigateToPage(10),
                    ),
                  ],
                ),
                const Divider(),
                _buildDrawerSection(
                  context,
                  title: 'Account & Settings',
                  items: [
                    _DrawerItem(
                      icon: Icons.person,
                      title: 'Profile',
                      onTap: () => navigateToPage(11),
                    ),
                    _DrawerItem(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      onTap: () => _showNotifications(context),
                    ),
                    _DrawerItem(
                      icon: Icons.settings,
                      title: 'Settings',
                      onTap: () => navigateToPage(11),
                    ),
                    _DrawerItem(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      onTap: () => navigateToPage(11),
                    ),
                    _DrawerItem(
                      icon: Icons.star,
                      title: 'Best Practices',
                      onTap: () => navigateToPage(11),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      height: 200,
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
                  const Color(0xFFFFD700),
                  const Color(0xFFD4AF37),
                  const Color(0xFFB8860B),
                ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Image.asset(
                  'assets/icon/icon.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'JKMG Ministry',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFFFFD700)
                      : Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Transforming lives through God\'s Word',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerSection(
    BuildContext context, {
    required String title,
    required List<_DrawerItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFFFFD700)
                  : const Color(0xFFB8860B),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        ...items.map((item) => _buildDrawerTile(context, item)),
      ],
    );
  }

  Widget _buildDrawerTile(BuildContext context, _DrawerItem item) {
    return ListTile(
      leading: Icon(
        item.icon,
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFFD4AF37)
            : const Color(0xFFB8860B),
        size: 22,
      ),
      title: Text(
        item.title,
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // Close drawer
        item.onTap();
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildLandingPage(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(context),
              const SizedBox(height: 24),
              _buildQuickActions(context),
              const SizedBox(height: 24),
              _buildFeaturedSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: Theme.of(context).brightness == Brightness.dark
              ? [const Color(0xFF1A1A1A), const Color(0xFF2A2A2A)]
              : [
                  const Color(0xFFFFF8DC).withOpacity(0.3),
                  const Color(0xFFFFD700).withOpacity(0.1),
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFB8860B).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to JKMG',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: const Color(0xFFB8860B),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Transforming lives through God\'s Word and prayer',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => navigateToPage(1), // Navigate to About
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Learn More'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
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
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: const Color(0xFFB8860B),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                context,
                icon: Icons.access_time,
                title: 'Prayer Plan',
                onTap: () => navigateToPage(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                context,
                icon: Icons.book,
                title: 'Bible Study',
                onTap: () => navigateToPage(3),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFB8860B).withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: const Color(0xFFB8860B)),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(0xFFB8860B),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Featured',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: const Color(0xFFB8860B),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildMenuCard(
              context,
              title: 'Salvation Corner',
              icon: Icons.favorite,
              color: Colors.red.shade400,
              onTap: () => navigateToPage(4),
            ),
            _buildMenuCard(
              context,
              title: 'Counseling & Care',
              icon: Icons.support,
              color: Colors.blue.shade400,
              onTap: () => navigateToPage(5),
            ),
            _buildMenuCard(
              context,
              title: 'Events',
              icon: Icons.event,
              color: Colors.green.shade400,
              onTap: () => navigateToPage(7),
            ),
            _buildMenuCard(
              context,
              title: 'Partnership',
              icon: Icons.volunteer_activism,
              color: Colors.purple.shade400,
              onTap: () => navigateToPage(8),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuCard(
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
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
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
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4AF37),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Swipe to explore more',
                style: TextStyle(
                  fontSize: 16,
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
}

class _DrawerItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  _DrawerItem({required this.icon, required this.title, required this.onTap});
}
