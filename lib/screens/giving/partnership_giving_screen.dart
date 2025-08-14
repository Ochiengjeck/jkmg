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
                image: AssetImage('assets/images/partners.png'),
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
                  'Partner with God\'s Kingdom Work',
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
                  'Join us in advancing the Kingdom through generous partnership',
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
                      _buildFeatureChip('Monthly Partners'),
                      const SizedBox(width: 8),
                      _buildFeatureChip('One-Time Gifts'),
                      const SizedBox(width: 8),
                      _buildFeatureChip('Ministry Focus'),
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

  Widget _buildPaymentMethodButton(
    String title,
    IconData icon,
    String subtitle,
    String method,
  ) {
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
              const Icon(
                Icons.format_quote,
                color: AppTheme.primaryGold,
                size: 32,
              ),
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
            Expanded(child: _buildImpactCard('25+', 'Countries', Icons.public)),
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
      MaterialPageRoute(builder: (context) => const PartnerDashboardScreen()),
    );
  }
}

// Comprehensive Giving Form Screen with Payment Methods
class GivingFormScreen extends StatefulWidget {
  final String givingType;

  const GivingFormScreen({super.key, required this.givingType});

  @override
  State<GivingFormScreen> createState() => _GivingFormScreenState();
}

class _GivingFormScreenState extends State<GivingFormScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _transactionIdController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedPaymentMethod = 'mpesa';
  String _selectedCurrency = 'KES';
  bool _isSubmitting = false;
  int _currentStep = 0;

  final Map<String, Map<String, String>> _paymentMethods = {
    'mpesa': {
      'title': 'M-Pesa',
      'icon': '📱',
      'paybill': '809200',
      'account': 'JKM GLOBAL',
      'instructions':
          'Go to M-Pesa > Lipa na M-Pesa > Pay Bill\nEnter Business Number: 809200\nAccount Number: JKM GLOBAL\nEnter Amount and confirm',
    },
    'sendwave': {
      'title': 'SendWave',
      'icon': '🌊',
      'number': '0700650503',
      'name': 'JULIAN KYULA',
      'instructions':
          'Send money via SendWave to:\n+254 700 650 503\nRecipient: JULIAN KYULA\nSelect Kenya as destination country',
    },
    'bank_kes': {
      'title': 'Bank Transfer (KES)',
      'icon': '🏦',
      'bank': 'ABSA BANK',
      'account_name': 'Coming soon',
      'account_number': 'Coming soon',
      'branch': 'Coming soon',
      'sort_code': '0390',
      'instructions':
          'Bank: ABSA BANK\nAccount Name: Coming soon\nAccount Number: Coming soon\nBranch: Coming soon',
    },
    'bank_usd': {
      'title': 'Bank Transfer (USD)',
      'icon': '💵',
      'bank': 'ABSA BANK',
      'account_name': 'Coming soon',
      'account_number': '2045646710',
      'branch': 'Coming soon',
      'swift': 'Coming soon',
      'instructions':
          'Bank: ABSA BANK\nAccount Name: Coming soon\nUSD Account: 2045646710\nSWIFT: Coming soon\nBranch: Coming soon',
    },
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Set payment method and skip to step 1 if specific method selected
    switch (widget.givingType.toLowerCase()) {
      case 'mpesa':
        _selectedPaymentMethod = 'mpesa';
        _selectedCurrency = 'KES';
        _currentStep = 0; // Still show selection but with mpesa pre-selected
        break;
      case 'sendwave':
        _selectedPaymentMethod = 'sendwave';
        _selectedCurrency = 'USD'; // SendWave typically for international
        _currentStep = 0;
        break;
      case 'bank':
        _selectedPaymentMethod = 'bank_kes';
        _selectedCurrency = 'KES';
        _currentStep = 0;
        break;
      case 'paypal':
        // PayPal would be handled here when implemented
        _selectedPaymentMethod = 'mpesa'; // fallback
        _selectedCurrency = 'KES';
        break;
      default:
        _selectedPaymentMethod = 'mpesa';
        _selectedCurrency = 'KES';
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _transactionIdController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.richBlack,
      appBar: AppBar(
        backgroundColor: AppTheme.charcoalBlack,
        title: const Text(
          'Complete Your Giving',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: AppTheme.primaryGold),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(child: _buildStepContent()),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppTheme.charcoalBlack,
      child: Row(
        children: [
          _buildStepIndicator(0, 'Select', Icons.payment),
          Expanded(child: _buildStepLine(0)),
          _buildStepIndicator(1, 'Pay', Icons.send),
          Expanded(child: _buildStepLine(1)),
          _buildStepIndicator(2, 'Confirm', Icons.check),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, IconData icon) {
    final isActive = _currentStep >= step;
    final isCurrent = _currentStep == step;

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? AppTheme.primaryGold : Colors.grey.shade300,
            shape: BoxShape.circle,
            border: isCurrent
                ? Border.all(color: AppTheme.primaryGold, width: 3)
                : null,
          ),
          child: Icon(
            icon,
            color: isActive ? AppTheme.richBlack : Colors.grey.shade600,
            size: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? AppTheme.primaryGold : Colors.grey,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(int step) {
    final isActive = _currentStep > step;
    return Container(
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: isActive ? AppTheme.primaryGold : Colors.grey.shade300,
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildPaymentSelectionStep();
      case 1:
        return _buildPaymentInstructionsStep();
      case 2:
        return _buildConfirmationStep();
      default:
        return _buildPaymentSelectionStep();
    }
  }

  Widget _buildPaymentSelectionStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose Payment Method',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.givingType.toLowerCase() == 'mpesa' ||
                    widget.givingType.toLowerCase() == 'sendwave' ||
                    widget.givingType.toLowerCase() == 'bank'
                ? 'You selected ${_paymentMethods[_selectedPaymentMethod]!['title']} - adjust your details below'
                : 'Select your preferred payment method to give ${widget.givingType}',
            style: TextStyle(
              fontSize: 14,
              color:
                  widget.givingType.toLowerCase() == 'mpesa' ||
                      widget.givingType.toLowerCase() == 'sendwave' ||
                      widget.givingType.toLowerCase() == 'bank'
                  ? AppTheme.primaryGold
                  : Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 24),

          Form(
            key: _formKey,
            child: Column(
              children: [
                // Amount Input
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    labelStyle: const TextStyle(color: AppTheme.primaryGold),
                    prefixText: _selectedCurrency == 'KES' ? 'KES ' : 'USD \$',
                    prefixStyle: const TextStyle(
                      color: AppTheme.primaryGold,
                      fontWeight: FontWeight.w600,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppTheme.primaryGold),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppTheme.primaryGold,
                        width: 2,
                      ),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Currency Selection
                Row(
                  children: [
                    Expanded(
                      child: _buildCurrencyButton('KES', 'Kenyan Shilling'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: _buildCurrencyButton('USD', 'US Dollar')),
                  ],
                ),
                const SizedBox(height: 24),

                // Payment Methods
                ...(_selectedCurrency == 'KES'
                        ? ['mpesa', 'sendwave', 'bank_kes']
                        : ['sendwave', 'bank_usd'])
                    .map((method) => _buildPaymentMethodCard(method)),

                const SizedBox(height: 32),

                // Show quick proceed button if method was pre-selected
                if (_isMethodPreSelected(_selectedPaymentMethod)) ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _nextStep,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primaryGold,
                            side: const BorderSide(color: AppTheme.primaryGold),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Review Options'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(
                                () => _currentStep = 1,
                              ); // Skip directly to instructions
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryGold,
                            foregroundColor: AppTheme.richBlack,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            'Proceed with ${_paymentMethods[_selectedPaymentMethod]!['title']}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _currentStep < 2 ? _nextStep : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGold,
                        foregroundColor: AppTheme.richBlack,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyButton(String currency, String name) {
    final isSelected = _selectedCurrency == currency;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedCurrency = currency;
        // Reset payment method when currency changes
        _selectedPaymentMethod = currency == 'KES' ? 'mpesa' : 'sendwave';
      }),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryGold.withOpacity(0.2)
              : AppTheme.charcoalBlack,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryGold : Colors.grey.shade700,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              currency,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppTheme.primaryGold : Colors.white,
              ),
            ),
            Text(
              name,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? AppTheme.primaryGold : Colors.grey.shade400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(String method) {
    final isSelected = _selectedPaymentMethod == method;
    final methodData = _paymentMethods[method]!;
    final isPreSelected = _isMethodPreSelected(method);

    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = method),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryGold.withOpacity(0.1)
              : AppTheme.charcoalBlack,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryGold : Colors.grey.shade700,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryGold.withOpacity(0.2)
                    : Colors.grey.shade800,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  methodData['icon']!,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    methodData['title']!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppTheme.primaryGold : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    method.contains('bank')
                        ? 'Bank Transfer'
                        : method == 'mpesa'
                        ? 'Mobile Money'
                        : 'International Transfer',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                if (isSelected)
                  const Icon(Icons.check_circle, color: AppTheme.primaryGold),
                if (isPreSelected && !isSelected)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGold.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Suggested',
                      style: TextStyle(
                        fontSize: 8,
                        color: AppTheme.primaryGold,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentInstructionsStep() {
    final methodData = _paymentMethods[_selectedPaymentMethod]!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(methodData['icon']!, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      methodData['title']!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Follow the steps below to complete your payment',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primaryGold.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.info_outline, color: AppTheme.primaryGold),
                    SizedBox(width: 8),
                    Text(
                      'Payment Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryGold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Amount: ${_selectedCurrency == 'KES' ? 'KES' : 'USD'} ${_amountController.text}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryGold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Purpose: ${widget.givingType.toUpperCase()} Giving',
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.charcoalBlack,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade700),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Payment Instructions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  methodData['instructions']!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),

                // Copyable account details
                _buildCopyableDetails(),
              ],
            ),
          ),
          const SizedBox(height: 32),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _previousStep,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryGold,
                    side: const BorderSide(color: AppTheme.primaryGold),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGold,
                    foregroundColor: AppTheme.richBlack,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'I\'ve Made Payment',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCopyableDetails() {
    final methodData = _paymentMethods[_selectedPaymentMethod]!;

    return Column(
      children: [
        if (_selectedPaymentMethod == 'mpesa') ...[
          _buildCopyableField('Paybill Number', methodData['paybill']!),
          _buildCopyableField('Account Number', methodData['account']!),
        ] else if (_selectedPaymentMethod == 'sendwave') ...[
          _buildCopyableField('Phone Number', methodData['number']!),
          _buildCopyableField('Recipient Name', methodData['name']!),
        ] else if (_selectedPaymentMethod.contains('bank')) ...[
          _buildCopyableField('Bank Name', methodData['bank']!),
          _buildCopyableField('Account Name', methodData['account_name']!),
          _buildCopyableField('Account Number', methodData['account_number']!),
          _buildCopyableField('Branch', methodData['branch']!),
          if (methodData.containsKey('swift'))
            _buildCopyableField('SWIFT Code', methodData['swift']!),
        ],
      ],
    );
  }

  Widget _buildCopyableField(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.richBlack.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$label copied to clipboard'),
                  backgroundColor: AppTheme.primaryGold,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryGold.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.copy,
                color: AppTheme.primaryGold,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Confirm Payment',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please provide your payment details to complete the process',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Your Full Name',
                    labelStyle: TextStyle(color: AppTheme.primaryGold),
                    prefixIcon: Icon(Icons.person, color: AppTheme.primaryGold),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter your name' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    labelStyle: TextStyle(color: AppTheme.primaryGold),
                    prefixIcon: Icon(Icons.email, color: AppTheme.primaryGold),
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value?.isEmpty ?? true)
                      return 'Please enter your email';
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value!)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(color: AppTheme.primaryGold),
                    prefixIcon: Icon(Icons.phone, color: AppTheme.primaryGold),
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.phone,
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter your phone number'
                      : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _transactionIdController,
                  decoration: InputDecoration(
                    labelText: _getTransactionIdLabel(),
                    labelStyle: const TextStyle(color: AppTheme.primaryGold),
                    prefixIcon: const Icon(
                      Icons.receipt,
                      color: AppTheme.primaryGold,
                    ),
                    helperText: _getTransactionIdHelper(),
                    helperStyle: const TextStyle(color: Colors.grey),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter the transaction ID'
                      : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Additional Notes (Optional)',
                    labelStyle: TextStyle(color: AppTheme.primaryGold),
                    prefixIcon: Icon(Icons.note, color: AppTheme.primaryGold),
                    alignLabelWithHint: true,
                  ),
                  style: const TextStyle(color: Colors.white),
                  maxLines: 3,
                ),
                const SizedBox(height: 32),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryGold,
                          side: const BorderSide(color: AppTheme.primaryGold),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Back'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGold,
                          foregroundColor: AppTheme.richBlack,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppTheme.richBlack,
                                ),
                              )
                            : const Text(
                                'Submit Payment',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTransactionIdLabel() {
    switch (_selectedPaymentMethod) {
      case 'mpesa':
        return 'M-Pesa Transaction ID';
      case 'sendwave':
        return 'SendWave Transaction ID';
      case 'bank_kes':
      case 'bank_usd':
        return 'Bank Transaction Reference';
      default:
        return 'Transaction ID';
    }
  }

  String _getTransactionIdHelper() {
    switch (_selectedPaymentMethod) {
      case 'mpesa':
        return 'e.g., QGH7X8K9M2';
      case 'sendwave':
        return 'e.g., SW123456789';
      case 'bank_kes':
      case 'bank_usd':
        return 'Reference number from bank';
      default:
        return 'Transaction reference number';
    }
  }

  bool _isMethodPreSelected(String method) {
    switch (widget.givingType.toLowerCase()) {
      case 'mpesa':
        return method == 'mpesa';
      case 'sendwave':
        return method == 'sendwave';
      case 'bank':
        return method == 'bank_kes' || method == 'bank_usd';
      default:
        return false;
    }
  }

  void _nextStep() {
    if (_currentStep == 0 && !_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      if (_currentStep < 2) {
        _currentStep++;
      }
    });
  }

  void _previousStep() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
      }
    });
  }

  Future<void> _submitPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Save locally for now
      final prefs = await PreferenceService.getInstance();
      await prefs.setString('last_donation', DateTime.now().toIso8601String());

      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error processing payment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.richBlack,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: AppTheme.successGreen,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Payment Submitted!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Thank you for your generous giving! We\'ll verify your payment and send you a confirmation.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to giving screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGold,
                  foregroundColor: AppTheme.richBlack,
                ),
                child: const Text('Done'),
              ),
            ),
          ],
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
              const Icon(
                Icons.dashboard,
                size: 64,
                color: AppTheme.primaryGold,
              ),
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
