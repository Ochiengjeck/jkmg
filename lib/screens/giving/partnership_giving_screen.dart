import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../models/models.dart';
import '../../services/preference_service.dart';

class PartnershipGivingScreen extends ConsumerStatefulWidget {
  const PartnershipGivingScreen({super.key});

  @override
  ConsumerState<PartnershipGivingScreen> createState() =>
      _PartnershipGivingScreenState();
}

class _PartnershipGivingScreenState
    extends ConsumerState<PartnershipGivingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
            _buildIntroSection(),
            const SizedBox(height: 24),
            _buildPartnershipOptions(),
            const SizedBox(height: 24),
            _buildGivingSection(),
            const SizedBox(height: 24),
            _buildImpactSection(),
            const SizedBox(height: 32),
            _buildPartnerDashboardAccess(),
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
                        image: AssetImage('assets/images/partners.png'),
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
                  'Partnership & Giving',
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
                  'Partner with God\'s Kingdom Work',
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
                    'Monthly Partners • One-Time Gifts • Ministry Focus',
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

  Widget _buildIntroSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.accentGold.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryGold.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.format_quote, color: AppTheme.primaryGold, size: 24),
              SizedBox(width: 8),
              Text(
                'Partnership Scripture',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.deepGold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '"Not because I desire a gift: but I desire fruit that may abound to your account." - Philippians 4:17',
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: AppTheme.deepGold,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'To partner with the transformative work God is doing through Rev. Julian Kyula and JKMG—whether through financial support or in-kind contributions—please find our giving and contact details below. Thank you, and may God bless you abundantly.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartnershipOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Partnership Levels',
          subtitle: 'Choose a partnership level that aligns with your heart',
        ),
        const SizedBox(height: 12),
        _buildPartnershipCard(
          'Monthly Partner',
          'Become a Monthly Partner',
          'Join our monthly partnership community for consistent Kingdom support',
          Icons.calendar_today,
          AppTheme.primaryGold,
          [
            'Monthly ministry updates',
            'Prayer requests and testimonies', 
            'Priority prayer support',
            'Access to partner events',
          ],
        ),
        const SizedBox(height: 12),
        _buildPartnershipCard(
          'One-Time Donation',
          'Give One-Time Donation',
          'Support specific causes and ministries with a one-time gift',
          Icons.favorite,
          AppTheme.deepGold,
          [
            'Support Rhema Feast',
            'Fund media ministry',
            'Support youth ministry',
            'Global missions outreach',
          ],
        ),
        const SizedBox(height: 12),
        _buildPartnershipCard(
          'Support a Cause',
          'Choose Ministry Focus',
          'Direct your giving toward specific ministry areas',
          Icons.business_center,
          AppTheme.darkGold,
          [
            'RF (Rhema Feast) events',
            'Media content creation',
            'Youth programs',
            'Global expansion',
          ],
        ),
      ],
    );
  }

  Widget _buildPartnershipCard(
    String title,
    String buttonText,
    String description,
    IconData icon,
    Color color,
    List<String> benefits,
  ) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...benefits.map(
            (benefit) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Icon(Icons.check_circle, size: 16, color: color),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      benefit,
                      style: const TextStyle(fontSize: 11, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showGivingForm(title),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
              ),
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGivingSection() {
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
                  Icons.payment,
                  color: AppTheme.primaryGold,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Secure Giving Options',
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
            'Choose your preferred method for secure online giving. All payment methods are encrypted and secure.',
            style: TextStyle(fontSize: 12, color: Colors.white70, height: 1.4),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildPaymentMethodButton(
                  'M-Pesa',
                  Icons.phone_android,
                  'Mobile money',
                  'mpesa',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildPaymentMethodButton(
                  'Bank',
                  Icons.account_balance,
                  'Bank transfer',
                  'bank',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildPaymentMethodButton(
                  'SendWave',
                  Icons.send,
                  'International',
                  'sendwave',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildPaymentMethodButton(
                  'PayPal',
                  Icons.payment,
                  'Secure online',
                  'paypal',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodButton(String title, IconData icon, String subtitle, String method) {
    return GestureDetector(
      onTap: () => _showGivingForm(method),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.softBlack,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.primaryGold.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryGold, size: 24),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
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
      ),
    );
  }

  Widget _buildImpactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Partnership Impact',
          subtitle: 'See how your partnership transforms lives globally',
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.charcoalBlack,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Icon(Icons.format_quote, color: AppTheme.primaryGold, size: 32),
              const SizedBox(height: 12),
              const Text(
                '"Through JKMG partnership, we\'ve seen incredible transformation in our community. The impact goes beyond financial support—it\'s about Kingdom advancement and generational change."',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                '— Rev. Julian Kyula, JKMG Founder',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildImpactCard('50K+', 'Lives Touched', Icons.people),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildImpactCard('25+', 'Countries', Icons.public),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildImpactCard('1000+', 'Partners', Icons.handshake),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildImpactCard('\$2M+', 'Raised', Icons.trending_up),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImpactCard(String number, String label, IconData icon) {
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
              fontSize: 16,
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

  Widget _buildPartnerDashboardAccess() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : () => _showGivingForm('instant'),
            icon: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.richBlack,
                    ),
                  )
                : const Icon(Icons.favorite),
            label: Text(_isLoading ? 'Processing...' : 'Give Now'),
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
            onPressed: _isLoading ? null : _accessPartnerDashboard,
            icon: const Icon(Icons.dashboard),
            label: const Text('Partner Dashboard'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryGold,
              side: const BorderSide(color: AppTheme.primaryGold),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'View giving history, update payment details, and download giving statements in your partner dashboard.',
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

  void _showGivingForm(String type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GivingFormScreen(givingType: type),
      ),
    );
  }

  void _accessPartnerDashboard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PartnerDashboardScreen(),
      ),
    );
  }
}

// Placeholder screens for navigation - these would be implemented separately
class GivingFormScreen extends StatelessWidget {
  final String givingType;

  const GivingFormScreen({super.key, required this.givingType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Your Giving')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.favorite, size: 64, color: AppTheme.primaryGold),
              const SizedBox(height: 16),
              Text(
                'Giving Form for $givingType',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'This form will integrate with secure payment gateways including M-Pesa, Bank Transfer, SendWave, and PayPal.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGold,
                  foregroundColor: AppTheme.richBlack,
                ),
                child: const Text('Coming Soon'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PartnerDashboardScreen extends StatelessWidget {
  const PartnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Partner Dashboard')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.dashboard, size: 64, color: AppTheme.primaryGold),
              const SizedBox(height: 16),
              const Text(
                'Partner Dashboard',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'View giving history, update payment details, and download giving statements. Access exclusive partner messages and devotionals.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGold,
                  foregroundColor: AppTheme.richBlack,
                ),
                child: const Text('Coming Soon'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
