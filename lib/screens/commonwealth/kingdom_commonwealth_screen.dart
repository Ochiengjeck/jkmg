import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

class KingdomCommonwealthScreen extends ConsumerStatefulWidget {
  const KingdomCommonwealthScreen({super.key});

  @override
  ConsumerState<KingdomCommonwealthScreen> createState() =>
      _KingdomCommonwealthScreenState();
}

class _KingdomCommonwealthScreenState
    extends ConsumerState<KingdomCommonwealthScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(),
            const SizedBox(height: 24),
            _buildAboutSection(),
            const SizedBox(height: 24),
            _buildKeyFeatures(),
            const SizedBox(height: 24),
            _buildImpactMetrics(),
            const SizedBox(height: 24),
            _buildAccessSection(),
            const SizedBox(height: 32),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

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
          // Clean image section with info button overlay preserved
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
                image: AssetImage('assets/images/commonwealth.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Stack(
              children: [
                // Info button overlay (preserved functionality)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => _showInfoDialog(),
                      icon: const Icon(
                        Icons.info_outline,
                        color: AppTheme.primaryGold,
                      ),
                      tooltip: 'About Kingdom Commonwealth',
                    ),
                  ),
                ),
              ],
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
                  'A Kingdom Economic Movement',
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
                  'Pooling community resources for sustainable Kingdom solutions',
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
                      _buildFeatureChip('Housing'),
                      const SizedBox(width: 8),
                      _buildFeatureChip('Food Systems'),
                      const SizedBox(width: 8),
                      _buildFeatureChip('Education'),
                      const SizedBox(width: 8),
                      _buildFeatureChip('Health & Finance'),
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

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'About Kingdom Commonwealth',
          subtitle: 'A revolutionary approach to kingdom economics',
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
              _buildAboutPoint(
                'What it is',
                'Kingdom Commonwealth is advantageously pooling community resources to plug into essential pillars such as housing, food systems, education, health, and finance',
              ),
              const SizedBox(height: 12),
              _buildAboutPoint(
                'Core Mission',
                'Creating sustainable economic systems that serve Kingdom purposes while empowering believers to thrive financially',
              ),
              const SizedBox(height: 12),
              _buildAboutPoint(
                'Connection to JKMG',
                'A clear emphasis on inheritance for the next generation, aligned with JKMG\'s vision for generational impact and wealth transfer',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutPoint(String title, String description) {
    return Column(
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
            fontSize: 12,
            color: Colors.grey.shade700,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildKeyFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Key Features',
          subtitle: 'What makes Kingdom Commonwealth unique',
        ),
        const SizedBox(height: 12),
        _buildFeatureCard(
          Icons.home,
          'Housing Solutions',
          'Affordable housing programs and community development projects',
          AppTheme.primaryGold,
        ),
        const SizedBox(height: 12),
        _buildFeatureCard(
          Icons.restaurant,
          'Food Systems',
          'Sustainable agriculture and community food security initiatives',
          AppTheme.deepGold,
        ),
        const SizedBox(height: 12),
        _buildFeatureCard(
          Icons.school,
          'Education',
          'Skills development and financial literacy programs',
          AppTheme.darkGold,
        ),
        const SizedBox(height: 12),
        _buildFeatureCard(
          Icons.health_and_safety,
          'Health & Finance',
          'Healthcare access and wealth-building strategies',
          AppTheme.successGreen,
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return CustomCard(
      child: Row(
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
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
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
          ),
        ],
      ),
    );
  }

  Widget _buildImpactMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Community Impact',
          subtitle: 'Making a difference through Kingdom economics',
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                '1,200+',
                'Community\nMembers',
                Icons.people,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard('45', 'Active\nProjects', Icons.work),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard('12', 'Countries\nServed', Icons.public),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                '\$2.3M',
                'Community\nWealth',
                Icons.trending_up,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(String number, String label, IconData icon) {
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
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAccessSection() {
    return Container(
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
                  Icons.phone_android,
                  color: AppTheme.primaryGold,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Access Kingdom Commonwealth',
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
            'Join the movement through our dedicated mobile application and website platform. Experience the full range of Kingdom Commonwealth features and connect with a global community.',
            style: TextStyle(fontSize: 12, color: Colors.white70, height: 1.4),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildPlatformButton(
                  'Mobile App',
                  Icons.smartphone,
                  'Download from app store',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPlatformButton(
                  'Website',
                  Icons.language,
                  'Access web platform',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformButton(String title, IconData icon, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.softBlack,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryGold.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primaryGold, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(fontSize: 9, color: Colors.grey.shade400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _launchWebsite,
            icon: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.richBlack,
                    ),
                  )
                : const Icon(Icons.language),
            label: Text(_isLoading ? 'Loading...' : 'Visit Website'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGold,
              foregroundColor: AppTheme.richBlack,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: _isLoading ? null : _launchMobileApp,
            icon: const Icon(Icons.download),
            label: const Text('Download Mobile App'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryGold,
              side: const BorderSide(color: AppTheme.primaryGold),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'For more details, kindly visit the website or download the app below',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Future<void> _launchWebsite() async {
    setState(() => _isLoading = true);

    const url = 'https://www.kingdomcommonwealth.com/';
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackBar('Could not open website');
      }
    } catch (e) {
      _showErrorSnackBar('Error opening website: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _launchMobileApp() async {
    setState(() => _isLoading = true);

    const androidUrl =
        'https://play.google.com/store/apps/details?id=com.kingdomcommonwealth.app';
    try {
      final uri = Uri.parse(androidUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackBar('Could not open app store');
      }
    } catch (e) {
      _showErrorSnackBar('Error opening app store: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kingdom Commonwealth'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Kingdom Commonwealth is a revolutionary economic movement that pools community resources to create sustainable solutions in:',
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: 12),
              Text('• Housing & Real Estate'),
              Text('• Food Systems & Agriculture'),
              Text('• Education & Skills Development'),
              Text('• Healthcare Access'),
              Text('• Financial Services & Wealth Building'),
              SizedBox(height: 12),
              Text(
                'This platform represents the future of Kingdom economics, where believers work together to build generational wealth and create lasting impact.',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
          ),
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
