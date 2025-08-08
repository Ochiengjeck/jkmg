import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

class AboutScreen extends ConsumerStatefulWidget {
  const AboutScreen({super.key});

  @override
  ConsumerState<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends ConsumerState<AboutScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroSection(),
              const SizedBox(height: 24),
              _buildAboutJKMG(),
              const SizedBox(height: 24),
              _buildVisionMissionSection(),
              const SizedBox(height: 24),
              _buildCoreGoalsSection(),
              const SizedBox(height: 24),
              _buildAboutJulianSection(),
              const SizedBox(height: 24),
              _buildAppFeatureSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
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
            color: AppTheme.primaryGold.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primaryGold, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryGold.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                'assets/icon/icon.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'JULIAN KYULA MINISTRY GLOBAL',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppTheme.primaryGold,
              letterSpacing: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'JKMG',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.primaryGold.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.primaryGold.withOpacity(0.3)),
            ),
            child: const Text(
              'Transforming Lives • Building Nations • Advancing Kingdom',
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.primaryGold,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutJKMG() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'About JKMG',
          subtitle: 'Our foundation and calling',
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.accentGold.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.primaryGold.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Julian Kyula Global Ministries (JKMG) is a faith-driven movement dedicated to transforming lives and nations through the power of God\'s Word, apostolic insight, and marketplace impact.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Founded by Reverend Julian Kyula, this global ministry exists to equip individuals, leaders, and communities to thrive in their divine purpose across the mission field, ministry work, and the marketplace.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Through inspired teaching, prayer, strategic gatherings, and practical outreach, we are raising a generation of kingdom-minded believers who are bold, innovative, and grounded in truth.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: AppTheme.deepGold,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Available on Android and iOS, supporting multilingual access (English, Swahili, French, Spanish)',
                      style: TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: AppTheme.deepGold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVisionMissionSection() {
    return Column(
      children: [
        _buildVisionMissionCard(
          'VISION',
          'To build a world where spiritual leadership, innovation, and enterprise work together to restore dignity, equity, and opportunity to underserved communities globally.',
          Icons.visibility,
          AppTheme.primaryGold,
        ),
        const SizedBox(height: 16),
        _buildVisionMissionCard(
          'MISSION',
          'To empower individuals, transform communities, and influence systems by strategically integrating faith, leadership, and sustainable development through impactful alliances.',
          Icons.rocket_launch,
          AppTheme.deepGold,
        ),
      ],
    );
  }

  Widget _buildVisionMissionCard(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return CustomCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
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
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: color,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoreGoalsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Core Goals',
          subtitle: 'Our strategic objectives',
        ),
        const SizedBox(height: 12),
        _buildGoalItem(
          1,
          'Advance the Gospel',
          'Through modern, relevant ministry approaches',
          Icons.campaign,
        ),
        _buildGoalItem(
          2,
          'Solve Systemic Challenges',
          'Via kingdom-driven enterprise solutions',
          Icons.engineering,
        ),
        _buildGoalItem(
          3,
          'Create Equitable Opportunities',
          'In education, finance, health, and innovation',
          Icons.balance,
        ),
        _buildGoalItem(
          4,
          'Mobilize Strategic Alliances',
          'For high-impact social transformation',
          Icons.handshake,
        ),
      ],
    );
  }

  Widget _buildGoalItem(int number, String title, String description, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.accentGold.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryGold.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.primaryGold,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  color: AppTheme.richBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.deepGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.deepGold, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutJulianSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'About Rev. Julian Kyula',
          subtitle: 'Founder and visionary leader',
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.charcoalBlack, AppTheme.softBlack],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
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
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.primaryGold, width: 2),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: AppTheme.primaryGold,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rev. Julian Kyula',
                          style: TextStyle(
                            color: AppTheme.primaryGold,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Founder & Overseer',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildJulianHighlight(
                'Ministry Leadership',
                'Founder and overseer of Ruach Ministries (est. 2007, originally The Purpose Centre Church)',
              ),
              _buildJulianHighlight(
                'Business Innovation',
                'Launched MODE Group (2010) - multinational fintech corporation operating in 14+ African nations',
              ),
              _buildJulianHighlight(
                'Housing Development',
                'Chairman at Beulah City Ltd - affordable housing solutions for the African middle class',
              ),
              _buildJulianHighlight(
                'Global Impact',
                'Brokered UN agreement for 100,000 affordable houses in Kenya\'s Big 4 Initiative (2019)',
              ),
              _buildJulianHighlight(
                'Family',
                'Married to Amanda Kyula, proud father of three sons',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildJulianHighlight(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6),
            decoration: const BoxDecoration(
              color: AppTheme.primaryGold,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.primaryGold,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppFeatureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'JKMG App Features',
          subtitle: 'Comprehensive digital ministry platform',
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.accentGold.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.primaryGold.withOpacity(0.1)),
          ),
          child: Column(
            children: [
              _buildFeatureRow(
                Icons.access_time,
                'Prayer Engagement',
                'Personalized prayer intervals and guided sessions',
              ),
              _buildFeatureRow(
                Icons.library_books,
                'Spiritual Resources',
                'Access to eBooks, audiobooks, and teachings',
              ),
              _buildFeatureRow(
                Icons.event,
                'Live Events',
                'Rhema Feast, Rhema Experience, and broadcasts',
              ),
              _buildFeatureRow(
                Icons.psychology,
                'Counseling & Care',
                'Mental health support and spiritual guidance',
              ),
              _buildFeatureRow(
                Icons.groups,
                'Community Features',
                'Testimonies, announcements, and partnerships',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureRow(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.deepGold, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}