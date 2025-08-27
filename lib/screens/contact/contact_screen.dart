import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/feedback_dialog.dart';
import '../../services/preference_service.dart';

class ContactScreen extends ConsumerStatefulWidget {
  const ContactScreen({super.key});

  @override
  ConsumerState<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends ConsumerState<ContactScreen>
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
      backgroundColor: AppTheme.richBlack,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 220.0,
                floating: false,
                pinned: true,
                backgroundColor: AppTheme.richBlack,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildHeaderContent(),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(60.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: AppTheme.primaryGold.withOpacity(0.2),
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
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
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              Container(color: AppTheme.richBlack, child: _buildContactTab()),
              Container(color: AppTheme.richBlack, child: _buildLocationTab()),
              Container(color: AppTheme.richBlack, child: _buildSocialTab()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderContent() {
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
            style: TextStyle(fontSize: 14, color: Colors.white70),
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
          _buildFeedbackSection(),
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
          '+254 703 349 237',
          'Call us during business hours',
          () => _launchPhone('+254703349237'),
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
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
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

  Widget _buildFeedbackSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Share Your Feedback',
          subtitle: 'Help us improve your experience with JKMG',
        ),
        const SizedBox(height: 12),
        CustomCard(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGold.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.feedback_outlined,
                        color: AppTheme.deepGold,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'We Value Your Input',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.deepGold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Share your thoughts, suggestions, and experiences with our comprehensive feedback system.',
                            style: TextStyle(fontSize: 13, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () => _showFeedbackDialog(),
                  icon: const Icon(Icons.rate_review),
                  label: const Text('Share Your Feedback'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGold,
                    foregroundColor: AppTheme.richBlack,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Your feedback helps us improve the JKMG experience for everyone.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
                      child: const Icon(
                        Icons.location_city,
                        color: AppTheme.deepGold,
                        size: 24,
                      ),
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
                            'Waterfront Mall, Karen, Nairobi',
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
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'Julian Kyula Ministry Global\nWaterfront Mall, Karen\nNairobi, Kenya\nEast Africa\n\nPhone: +254 703 349 237',
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
          title: 'Church Assemblies (Branches)',
          subtitle: 'RUACH Tabernacle locations across Nairobi',
        ),
        const SizedBox(height: 12),
        _buildBranchLocationCard(
          'RUACH Tabernacle',
          'Next to Shell Windsor Northern Bypass Rd.',
          'Nairobi Outer, Kenya',
          '+254 757 155 471',
          Icons.church,
        ),
        const SizedBox(height: 12),
        _buildBranchLocationCard(
          'RUACH West',
          'Movenpick Hotel and Residences, Mkungu Close',
          'Nairobi, Kenya',
          '+254 110 007 736',
          Icons.location_city,
        ),
        const SizedBox(height: 12),
        _buildBranchLocationCard(
          'RUACH South',
          'WaterFront Mall, Karen',
          'Nairobi, Kenya',
          '+254 716 341 739',
          Icons.shopping_cart_outlined,
        ),
        const SizedBox(height: 12),
        _buildBranchLocationCard(
          'RUACH East',
          'Immediate Entrance after Ideal Ceramics Main Gate, ICD RD, Off Mombasa Road',
          'Nairobi, Kenya',
          '+254 797 438 919',
          Icons.business,
        ),
        const SizedBox(height: 12),
        _buildBranchLocationCard(
          'RUACH Rivers',
          'Havilah Ranch, Ruaka',
          'Moi Nairobi Area, Kenya',
          '+254 797 404 865',
          Icons.nature,
        ),
      ],
    );
  }

  Widget _buildBranchLocationCard(
    String title,
    String address,
    String city,
    String phone,
    IconData icon,
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
                  color: AppTheme.deepGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppTheme.deepGold, size: 22),
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
                        fontWeight: FontWeight.w700,
                        color: AppTheme.deepGold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      city,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppTheme.primaryGold,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Address:',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.deepGold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Text(
                    address,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade700,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _launchPhone(phone.replaceAll(' ', '')),
                  icon: const Icon(Icons.phone, size: 16),
                  label: Text(phone, style: const TextStyle(fontSize: 11)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.successGreen,
                    side: BorderSide(
                      color: AppTheme.successGreen.withOpacity(0.5),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _openBranchMap(address, city),
                  icon: const Icon(Icons.map, size: 16),
                  label: const Text(
                    'Directions',
                    style: TextStyle(fontSize: 11),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryGold,
                    side: BorderSide(
                      color: AppTheme.primaryGold.withOpacity(0.5),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
            ],
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
            () => _launchUrl(
              'https://www.tiktok.com/@juliankyulaofficial?_t=ZM-8yrsij1pj66&_r=1',
            ),
          ),
          _buildSocialMediaCard(
            'Instagram',
            'Daily inspiration and behind-the-scenes',
            Icons.camera_alt,
            Colors.purple,
            '@jkyula',
            () => _launchUrl(
              'https://www.instagram.com/jkyula?igsh=bXA4YnEzeXh6ZGxs',
            ),
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
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
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
          const Icon(Icons.open_in_new, color: AppTheme.deepGold, size: 16),
        ],
      ),
    );
  }

  Widget _buildNewsletterSignup() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryGold.withOpacity(0.1),
            AppTheme.accentGold.withOpacity(0.05),
          ],
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
            style: TextStyle(fontSize: 12, height: 1.4),
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

  void _showFeedbackDialog() {
    showDialog(context: context, builder: (context) => const FeedbackDialog());
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
    _launchUrl(
      'https://maps.google.com/?q=Waterfront+Mall,+Karen,+Nairobi,+Kenya',
    );
  }

  void _openBranchMap(String address, String city) {
    final query = Uri.encodeComponent('$address, $city');
    _launchUrl('https://maps.google.com/?q=$query');
  }

  void _signupNewsletter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Newsletter Signup'),
        content: const Text(
          'Newsletter signup feature will be available soon. Thank you for your interest!',
        ),
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
