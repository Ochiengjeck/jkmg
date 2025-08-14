import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../services/preference_service.dart';

class ContactScreen extends ConsumerStatefulWidget {
  const ContactScreen({super.key});

  @override
  ConsumerState<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends ConsumerState<ContactScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  late TabController _tabController;
  String _inquiryType = 'General';
  bool _isSubmitting = false;

  final List<String> _inquiryTypes = [
    'General',
    'Prayer Request',
    'Testimony',
    'Technical Support',
    'Partnership',
    'Event Information',
    'Speaking Request',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.richBlack,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Container(
                    color: AppTheme.richBlack,
                    child: _buildContactTab(),
                  ),
                  Container(
                    color: AppTheme.richBlack,
                    child: _buildLocationTab(),
                  ),
                  Container(
                    color: AppTheme.richBlack,
                    child: _buildSocialTab(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.richBlack, AppTheme.charcoalBlack],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Icon(
            Icons.contact_support,
            color: AppTheme.primaryGold,
            size: 48,
          ),
          const SizedBox(height: 12),
          const Text(
            'Contact JKMG',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'We\'d Love to Hear from You',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: AppTheme.primaryGold.withOpacity(0.2)),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black87,
              unselectedLabelColor: Colors.white60,
              indicatorColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.label,
              dividerHeight: 0,
              indicator: BoxDecoration(
                color: AppTheme.primaryGold,
                borderRadius: BorderRadius.circular(20),
              ),
              indicatorPadding: const EdgeInsets.symmetric(vertical: 3),
              labelStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              tabs: [
                SizedBox(width: 100, child: Tab(text: 'Contact')),
                SizedBox(width: 100, child: Tab(text: 'Location')),
                SizedBox(width: 100, child: Tab(text: 'Social')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildContactInfo(),
          const SizedBox(height: 24),
          _buildContactForm(),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Get in Touch',
          subtitle: 'Reach out to us through any of these channels',
        ),
        const SizedBox(height: 12),
        _buildContactInfoCard(
          Icons.email,
          'Email Address',
          'info@jkministriesglobal.org',
          'Send us an email anytime',
          () => _launchEmail('info@jkministriesglobal.org'),
        ),
        const SizedBox(height: 12),
        _buildContactInfoCard(
          Icons.phone,
          'Phone Number',
          '+254 700 000 000',
          'Call us during business hours',
          () => _launchPhone('+254700000000'),
        ),
        const SizedBox(height: 12),
        _buildContactInfoCard(
          Icons.schedule,
          'Office Hours',
          'Mon - Fri: 9:00 AM - 5:00 PM EAT',
          'Saturday: 10:00 AM - 2:00 PM EAT',
          null,
        ),
      ],
    );
  }

  Widget _buildContactInfoCard(
    IconData icon,
    String title,
    String primary,
    String secondary,
    VoidCallback? onTap,
  ) {
    return CustomCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.deepGold, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.deepGold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  primary,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  secondary,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null) ...[
            const Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.deepGold,
              size: 16,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContactForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Send us a Message',
            subtitle: 'Fill out the form below and we\'ll get back to you',
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name *',
                            prefixIcon: Icon(Icons.person, color: AppTheme.deepGold),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email Address *',
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
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number (Optional)',
                      prefixIcon: Icon(Icons.phone, color: AppTheme.deepGold),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _inquiryType,
                    decoration: const InputDecoration(
                      labelText: 'Inquiry Type *',
                      prefixIcon: Icon(Icons.category, color: AppTheme.deepGold),
                    ),
                    items: _inquiryTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _inquiryType = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _subjectController,
                    decoration: const InputDecoration(
                      labelText: 'Subject *',
                      prefixIcon: Icon(Icons.subject, color: AppTheme.deepGold),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a subject';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      labelText: 'Message *',
                      prefixIcon: Icon(Icons.message, color: AppTheme.deepGold),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your message';
                      }
                      if (value.length < 10) {
                        return 'Message must be at least 10 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _isSubmitting ? null : _submitForm,
                      icon: _isSubmitting 
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppTheme.richBlack,
                              ),
                            )
                          : const Icon(Icons.send),
                      label: Text(_isSubmitting ? 'Sending...' : 'Send Message'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGold,
                        foregroundColor: AppTheme.richBlack,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '* Required fields',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We typically respond within 48 hours during business days.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Our Location',
            subtitle: 'Visit us at our main office',
          ),
          const SizedBox(height: 12),
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGold.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.location_city, color: AppTheme.deepGold, size: 24),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'JKMG Headquarters',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Nairobi, Kenya',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.deepGold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Address Details:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Julian Kyula Ministry Global\nP.O. Box 12345-00100\nNairobi, Kenya\nEast Africa',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _openMap,
                    icon: const Icon(Icons.map),
                    label: const Text('View on Map'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryGold,
                      side: const BorderSide(color: AppTheme.primaryGold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildServiceLocations(),
        ],
      ),
    );
  }

  Widget _buildServiceLocations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Service Locations',
          subtitle: 'Where we worship and gather',
        ),
        const SizedBox(height: 12),
        _buildServiceLocationCard(
          'Ruach Assemblies (Purpose Centre Church)',
          'Sunday Services: 9:00 AM & 11:00 AM',
          'Location: Nairobi, Kenya',
          Icons.church,
        ),
        const SizedBox(height: 12),
        _buildServiceLocationCard(
          'Rhema Experience (RXP)',
          'Wednesday Service: 5:00 PM',
          'Location: All Saints Cathedral, Nairobi',
          Icons.event,
        ),
      ],
    );
  }

  Widget _buildServiceLocationCard(
    String title,
    String schedule,
    String location,
    IconData icon,
  ) {
    return CustomCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.deepGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.deepGold, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  schedule,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.deepGold,
                  ),
                ),
                Text(
                  location,
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

  Widget _buildSocialTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Connect with Us',
            subtitle: 'Follow Rev. Julian and JKMG on social media',
          ),
          const SizedBox(height: 12),
          _buildSocialMediaCard(
            'Facebook',
            'Connect with our community and get updates',
            Icons.facebook,
            Colors.blue,
            'facebook.com/juliankyula',
            () => _launchUrl('https://www.facebook.com/share/1GLKoEuMK5/'),
          ),
          _buildSocialMediaCard(
            'TikTok',
            'Short inspirational videos and teachings',
            Icons.music_video,
            Colors.black,
            '@juliankyulaofficial',
            () => _launchUrl('https://www.tiktok.com/@juliankyulaofficial?_t=ZM-8yrsij1pj66&_r=1'),
          ),
          _buildSocialMediaCard(
            'Instagram',
            'Daily inspiration and behind-the-scenes',
            Icons.camera_alt,
            Colors.purple,
            '@jkyula',
            () => _launchUrl('https://www.instagram.com/jkyula?igsh=bXA4YnEzeXh6ZGxs'),
          ),
          const SizedBox(height: 24),
          _buildNewsletterSignup(),
        ],
      ),
    );
  }

  Widget _buildSocialMediaCard(
    String platform,
    String description,
    IconData icon,
    Color color,
    String handle,
    VoidCallback onTap,
  ) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: onTap,
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
                  platform,
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
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  handle,
                  style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.open_in_new,
            color: AppTheme.deepGold,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildNewsletterSignup() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryGold.withOpacity(0.1), AppTheme.accentGold.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryGold.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.email, color: AppTheme.deepGold),
              const SizedBox(width: 8),
              const Text(
                'Newsletter Signup',
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
            'Stay updated with our latest teachings, events, and ministry news.',
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _signupNewsletter,
              child: const Text('Subscribe to Newsletter'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      
      try {
        // Simulate form submission
        await Future.delayed(const Duration(seconds: 2));
        
        // Save form data locally for now
        final prefs = await PreferenceService.getInstance();
        await prefs.setString('last_contact_submission', DateTime.now().toIso8601String());
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Thank you! Your message has been sent successfully.'),
              backgroundColor: AppTheme.successGreen,
              behavior: SnackBarBehavior.floating,
            ),
          );
          _resetForm();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error sending message: ${e.toString()}'),
              backgroundColor: AppTheme.errorRed,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
      }
    }
  }

  void _resetForm() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _subjectController.clear();
    _messageController.clear();
    setState(() {
      _inquiryType = 'General';
    });
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=JKMG App Inquiry',
    );
    
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        // Copy to clipboard as fallback
        await Clipboard.setData(ClipboardData(text: email));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email address copied to clipboard'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      await Clipboard.setData(ClipboardData(text: email));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email address copied to clipboard'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _launchPhone(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        await Clipboard.setData(ClipboardData(text: phone));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Phone number copied to clipboard'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      await Clipboard.setData(ClipboardData(text: phone));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Phone number copied to clipboard'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await Clipboard.setData(ClipboardData(text: url));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Link copied to clipboard'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      await Clipboard.setData(ClipboardData(text: url));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Link copied to clipboard'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _openMap() {
    _launchUrl('https://maps.google.com/?q=Nairobi,Kenya');
  }

  void _signupNewsletter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Newsletter Signup'),
        content: const Text('Newsletter signup feature will be available soon. Thank you for your interest!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}