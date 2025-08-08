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
      appBar: AppBar(
        title: const Text('Partnership & Giving'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryGold,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryGold,
          labelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(icon: Icon(Icons.handshake), text: 'Partnership'),
            Tab(icon: Icon(Icons.favorite), text: 'Give'),
            Tab(icon: Icon(Icons.dashboard), text: 'My Giving'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [PartnershipTab(), GivingTab(), MyGivingTab()],
      ),
    );
  }
}

class PartnershipTab extends ConsumerWidget {
  const PartnershipTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WelcomeSection(
            title: 'Partner with JKMG',
            subtitle:
                'To partner with the transformative work God is doing through Rev. Julian Kyula and JKMG—whether through financial support or in-kind contributions—please find our giving and contact details below. Thank you, and may God bless you abundantly.',
            icon: Icons.handshake,
          ),
          const SizedBox(height: 24),
          _buildPartnershipLevels(context),
          const SizedBox(height: 24),
          _buildMinistryFocus(context),
          const SizedBox(height: 24),
          _buildTestimonySection(context),
        ],
      ),
    );
  }

  Widget _buildPartnershipLevels(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Partnership Levels',
          subtitle: 'Choose a partnership level that aligns with your heart',
        ),
        const SizedBox(height: 12),
        _buildPartnershipCard(
          context,
          'Kingdom Builder',
          '\$500+ Monthly',
          'Support major ministry initiatives and global expansion',
          Icons.business_center,
          AppTheme.primaryGold,
          [
            'Priority prayer support',
            'Exclusive partnership updates',
            'Annual partner gathering invite',
            'Ministry financial reports',
          ],
        ),
        _buildPartnershipCard(
          context,
          'Faith Partner',
          '\$100+ Monthly',
          'Help fund regular ministry operations and outreach',
          Icons.favorite,
          AppTheme.deepGold,
          [
            'Monthly ministry updates',
            'Prayer requests and testimonies',
            'Special partner events access',
          ],
        ),
        _buildPartnershipCard(
          context,
          'Prayer Supporter',
          '\$25+ Monthly',
          'Join our prayer and financial support network',
          Icons.church,
          AppTheme.darkGold,
          [
            'Weekly prayer updates',
            'Ministry newsletters',
            'Access to online prayer meetings',
          ],
        ),
      ],
    );
  }

  Widget _buildPartnershipCard(
    BuildContext context,
    String title,
    String amount,
    String description,
    IconData icon,
    Color color,
    List<String> benefits,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                const SizedBox(width: 12),
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
                      Text(
                        amount,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Partnership Benefits:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
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
                onPressed: () => _becomePartner(context, title),
                child: Text('Become a $title'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMinistryFocus(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Ministry Focus Areas',
          subtitle: 'Your partnership supports these key ministry areas',
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildFocusCard(
                'Global Events',
                Icons.public,
                'Rhema Feast & RXP',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFocusCard(
                'Media Ministry',
                Icons.video_library,
                'Digital Outreach',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildFocusCard(
                'Youth Ministry',
                Icons.groups,
                'Next Generation',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFocusCard(
                'Missions',
                Icons.flight_takeoff,
                'Global Expansion',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFocusCard(String title, IconData icon, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.accentGold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryGold.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.deepGold, size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          Text(
            subtitle,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonySection(BuildContext context) {
    return Container(
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
            '"Through JKMG partnership, we\'ve seen incredible transformation in our community. The impact goes beyond financial support—it\'s about Kingdom advancement."',
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
            '— Sarah M., Kingdom Builder Partner',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  void _becomePartner(BuildContext context, String level) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PartnershipSignupScreen(partnershipLevel: level),
      ),
    );
  }
}

class GivingTab extends ConsumerStatefulWidget {
  const GivingTab({super.key});

  @override
  ConsumerState<GivingTab> createState() => _GivingTabState();
}

class _GivingTabState extends ConsumerState<GivingTab> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  String _selectedAmount = '';
  String _selectedPaymentMethod = 'mpesa';
  String _selectedCause = 'general';
  bool _isOneTime = true;

  final List<String> _quickAmounts = ['25', '50', '100', '250', '500', '1000'];

  @override
  void dispose() {
    _amountController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WelcomeSection(
              title: 'Give to JKMG',
              subtitle:
                  'Your generous giving helps advance God\'s Kingdom through JKMG ministries worldwide. Every gift makes a difference.',
              icon: Icons.favorite,
            ),
            const SizedBox(height: 24),
            _buildGivingTypeToggle(),
            const SizedBox(height: 20),
            _buildAmountSection(),
            const SizedBox(height: 20),
            _buildCauseSelection(),
            const SizedBox(height: 20),
            _buildPaymentMethodSection(),
            const SizedBox(height: 20),
            _buildDonorInformation(),
            const SizedBox(height: 24),
            _buildGiveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildGivingTypeToggle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Giving Type',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.primaryGold.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isOneTime = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _isOneTime
                          ? AppTheme.primaryGold
                          : Colors.transparent,
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      'One-Time Gift',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _isOneTime
                            ? AppTheme.richBlack
                            : Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isOneTime = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: !_isOneTime
                          ? AppTheme.primaryGold
                          : Colors.transparent,
                      borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Monthly Partnership',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: !_isOneTime
                            ? AppTheme.richBlack
                            : Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Amount (USD)',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        // Wrap(
        //   spacing: 8,
        //   runSpacing: 8,
        //   children: _quickAmounts.map((amount) {
        //     final isSelected = _selectedAmount == amount;
        //     return GestureDetector(
        //       onTap: () {
        //         setState(() {
        //           _selectedAmount = amount;
        //           _amountController.text = amount;
        //         });
        //       },
        //       child: Container(
        //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        //         decoration: BoxDecoration(
        //           color: isSelected ? AppTheme.primaryGold : Colors.transparent,
        //           border: Border.all(
        //             color: isSelected ? AppTheme.primaryGold : Colors.grey.shade400,
        //           ),
        //           borderRadius: BorderRadius.circular(20),
        //         ),
        //         child: Text(
        //           '\$$amount',
        //           style: TextStyle(
        //             fontSize: 12,
        //             fontWeight: FontWeight.w600,
        //             color: isSelected ? AppTheme.richBlack : Colors.grey.shade700,
        //           ),
        //         ),
        //       ),
        //     );
        //   }),
        // ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _amountController,
          decoration: const InputDecoration(
            labelText: 'Custom Amount',
            prefixText: '\$ ',
            hintText: 'Enter amount',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            setState(() {
              _selectedAmount = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an amount';
            }
            final amount = int.tryParse(value);
            if (amount == null || amount <= 0) {
              return 'Please enter a valid amount';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCauseSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Support Area',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedCause,
          decoration: const InputDecoration(
            labelText: 'Where should your gift go?',
          ),
          items: const [
            DropdownMenuItem(value: 'general', child: Text('General Ministry')),
            DropdownMenuItem(value: 'rhema_feast', child: Text('Rhema Feast')),
            DropdownMenuItem(value: 'youth', child: Text('Youth Ministry')),
            DropdownMenuItem(value: 'missions', child: Text('Global Missions')),
            DropdownMenuItem(value: 'media', child: Text('Media Ministry')),
            DropdownMenuItem(
              value: 'counseling',
              child: Text('Counseling & Care'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedCause = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        _buildPaymentOption(
          'mpesa',
          'M-Pesa',
          Icons.phone_android,
          'Mobile money transfer',
        ),
        _buildPaymentOption(
          'card',
          'Credit/Debit Card',
          Icons.credit_card,
          'Visa, Mastercard accepted',
        ),
        _buildPaymentOption(
          'bank',
          'Bank Transfer',
          Icons.account_balance,
          'Direct bank transfer',
        ),
        _buildPaymentOption(
          'sendwave',
          'SendWave',
          Icons.send,
          'International transfer',
        ),
        _buildPaymentOption(
          'paypal',
          'PayPal',
          Icons.payment,
          'Secure online payment',
        ),
      ],
    );
  }

  Widget _buildPaymentOption(
    String value,
    String title,
    IconData icon,
    String subtitle,
  ) {
    final isSelected = _selectedPaymentMethod == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppTheme.primaryGold : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? AppTheme.primaryGold.withOpacity(0.1) : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.deepGold : Colors.grey.shade600,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppTheme.deepGold : null,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppTheme.deepGold,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonorInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Donor Information',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            prefixIcon: Icon(Icons.person, color: AppTheme.deepGold),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email Address',
            prefixIcon: Icon(Icons.email, color: AppTheme.deepGold),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Phone Number (Optional)',
            prefixIcon: Icon(Icons.phone, color: AppTheme.deepGold),
          ),
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildGiveButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: _processGift,
        icon: const Icon(Icons.favorite),
        label: Text(_isOneTime ? 'Give Now' : 'Start Monthly Partnership'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryGold,
          foregroundColor: AppTheme.richBlack,
        ),
      ),
    );
  }

  void _processGift() {
    if (_formKey.currentState!.validate()) {
      // Process the gift
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Thank You!'),
          content: Text(
            'Your ${_isOneTime ? 'gift' : 'monthly partnership'} of \$${_amountController.text} will be processed using ${_getPaymentMethodName()}.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continue'),
            ),
          ],
        ),
      );
    }
  }

  String _getPaymentMethodName() {
    switch (_selectedPaymentMethod) {
      case 'mpesa':
        return 'M-Pesa';
      case 'card':
        return 'Credit/Debit Card';
      case 'bank':
        return 'Bank Transfer';
      case 'sendwave':
        return 'SendWave';
      case 'paypal':
        return 'PayPal';
      default:
        return 'Selected Payment Method';
    }
  }
}

class MyGivingTab extends ConsumerWidget {
  const MyGivingTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: EmptyStateWidget(
          icon: Icons.dashboard,
          title: 'My Giving Dashboard',
          subtitle:
              'Track your giving history and manage your partnerships. Sign in to access your personalized dashboard.',
          action: null,
        ),
      ),
    );
  }
}

class PartnershipSignupScreen extends ConsumerStatefulWidget {
  final String partnershipLevel;

  const PartnershipSignupScreen({super.key, required this.partnershipLevel});

  @override
  ConsumerState<PartnershipSignupScreen> createState() =>
      _PartnershipSignupScreenState();
}

class _PartnershipSignupScreenState
    extends ConsumerState<PartnershipSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.partnershipLevel} Partnership')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WelcomeSection(
                title: 'Join as ${widget.partnershipLevel}',
                subtitle:
                    'Complete your information to begin your partnership journey with JKMG.',
              ),
              const SizedBox(height: 24),
              // Form fields would go here
              const Text(
                'Partnership signup form will be implemented with backend integration.',
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Partnership signup will be available soon!',
                        ),
                        backgroundColor: AppTheme.primaryGold,
                      ),
                    );
                  },
                  child: const Text('Complete Partnership Signup'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
