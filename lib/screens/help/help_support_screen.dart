import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends ConsumerStatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  ConsumerState<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends ConsumerState<HelpSupportScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _contactFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

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
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFAQTab(),
                _buildContactTab(),
                _buildResourcesTab(),
              ],
            ),
          ),
        ],
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
          const Icon(Icons.help_outline, color: AppTheme.primaryGold, size: 48),
          const SizedBox(height: 12),
          const Text(
            'Help & Support',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'We\'re here to help you every step of the way',
            style: TextStyle(fontSize: 14, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TabBar(
            controller: _tabController,
            labelColor: AppTheme.primaryGold,
            unselectedLabelColor: Colors.white60,
            indicatorColor: AppTheme.primaryGold,
            labelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            tabs: const [
              Tab(icon: Icon(Icons.quiz), text: 'FAQ'),
              Tab(icon: Icon(Icons.contact_support), text: 'Contact'),
              Tab(icon: Icon(Icons.library_books), text: 'Resources'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFAQTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Frequently Asked Questions',
            subtitle: 'Find quick answers to common questions',
          ),
          const SizedBox(height: 16),
          _buildFAQSection('Getting Started', [
            FAQItem(
              'How do I create an account?',
              'To create an account, tap the "Sign Up" button on the login screen and fill in your details. You\'ll receive a verification email to complete the process.',
            ),
            FAQItem(
              'How do I reset my password?',
              'On the login screen, tap "Forgot Password" and enter your email. You\'ll receive instructions to reset your password.',
            ),
            FAQItem(
              'Can I use the app without an internet connection?',
              'Some features like downloaded Bible studies and prayer guides work offline, but most functionality requires an internet connection.',
            ),
          ]),
          const SizedBox(height: 20),
          _buildFAQSection('Prayer & Worship', [
            FAQItem(
              'How do I customize my prayer times?',
              'Go to Profile > Preferences > Prayer Times to set your preferred prayer schedule and notification times.',
            ),
            FAQItem(
              'Can I submit prayer requests for others?',
              'Yes, you can submit prayer requests for yourself or others through the Prayer section of the app.',
            ),
            FAQItem(
              'How do I join live prayer sessions?',
              'Live prayer sessions are announced in the Events section. Tap on a session to join via the livestream link.',
            ),
          ]),
          const SizedBox(height: 20),
          _buildFAQSection('Events & Community', [
            FAQItem(
              'How do I register for events?',
              'Browse events in the Events section and tap "Register" on any event you\'d like to attend. You\'ll receive confirmation details.',
            ),
            FAQItem(
              'Can I volunteer for events?',
              'Yes! When registering for events, you can indicate your interest in volunteering. Event organizers will contact you with details.',
            ),
            FAQItem(
              'How do I access livestreamed events?',
              'Registered events with livestreams will show a "Join Livestream" button when the event is active.',
            ),
          ]),
          const SizedBox(height: 20),
          _buildFAQSection('Technical Issues', [
            FAQItem(
              'The app is running slowly, what can I do?',
              'Try closing and reopening the app, check your internet connection, or clear the app cache in Settings > Data & Storage.',
            ),
            FAQItem(
              'I\'m not receiving notifications',
              'Check your device notification settings and ensure notifications are enabled for this app in Settings > Notifications.',
            ),
            FAQItem(
              'How do I update the app?',
              'Visit your device\'s app store and search for "JKMG" to download the latest version.',
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildFAQSection(String title, List<FAQItem> items) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.help_outline, color: AppTheme.deepGold, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.deepGold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...items.map((item) => _buildFAQItem(item)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(FAQItem item) {
    return ExpansionTile(
      title: Text(
        item.question,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              item.answer,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Contact Our Team',
            subtitle: 'Get personalized help from our support team',
          ),
          const SizedBox(height: 16),
          _buildQuickContactOptions(),
          const SizedBox(height: 24),
          _buildContactForm(),
        ],
      ),
    );
  }

  Widget _buildQuickContactOptions() {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.phone, color: AppTheme.deepGold),
                const SizedBox(width: 12),
                const Text(
                  'Quick Contact Options',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildContactOption(
              Icons.email,
              'Email Support',
              'support@jkmg.org',
              'Send us a detailed message',
              () => _launchEmail('support@jkmg.org'),
            ),
            const Divider(),
            _buildContactOption(
              Icons.phone,
              'Phone Support',
              '+1 (555) 123-4567',
              'Mon-Fri 9AM-6PM EST',
              () => _launchPhone('+15551234567'),
            ),
            const Divider(),
            _buildContactOption(
              Icons.chat,
              'WhatsApp',
              '+1 (555) 987-6543',
              'Quick chat support',
              () => _launchWhatsApp('+15559876543'),
            ),
            const Divider(),
            _buildContactOption(
              Icons.schedule,
              'Schedule a Call',
              'Book appointment',
              'Get one-on-one assistance',
              () => _showScheduleDialog(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption(
    IconData icon,
    String title,
    String subtitle,
    String description,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryGold.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.deepGold, size: 20),
      ),
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(
            description,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildContactForm() {
    return Form(
      key: _contactFormKey,
      child: CustomCard(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.message, color: AppTheme.deepGold),
                  const SizedBox(width: 12),
                  const Text(
                    'Send us a Message',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Your Name',
                  prefixIcon: Icon(Icons.person, color: AppTheme.deepGold),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
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
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  labelText: 'Subject',
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
                  labelText: 'Your Message',
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
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitContactForm,
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
                      : const Text('Send Message'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResourcesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Help Resources',
            subtitle: 'Guides, tutorials, and useful information',
          ),
          const SizedBox(height: 16),
          _buildResourceCategory('Getting Started', [
            ResourceItem(
              'User Guide',
              'Complete guide to using the app',
              Icons.menu_book,
            ),
            ResourceItem(
              'Video Tutorials',
              'Step-by-step video guides',
              Icons.play_circle,
            ),
            ResourceItem(
              'Quick Start Tips',
              'Essential tips for new users',
              Icons.tips_and_updates,
            ),
          ]),
          const SizedBox(height: 20),
          _buildResourceCategory('Prayer & Worship', [
            ResourceItem(
              'Prayer Guide',
              'How to use prayer features',
              Icons.church,
            ),
            ResourceItem(
              'Worship Resources',
              'Songs, verses, and devotions',
              Icons.music_note,
            ),
            ResourceItem(
              'Bible Study Tools',
              'Making the most of study features',
              Icons.school,
            ),
          ]),
          const SizedBox(height: 20),
          _buildResourceCategory('Community Features', [
            ResourceItem(
              'Event Participation',
              'Joining and engaging in events',
              Icons.event,
            ),
            ResourceItem(
              'Volunteer Guide',
              'How to volunteer effectively',
              Icons.volunteer_activism,
            ),
            ResourceItem(
              'Partnership Info',
              'Supporting the ministry',
              Icons.handshake,
            ),
          ]),
          const SizedBox(height: 20),
          _buildResourceCategory('Technical Support', [
            ResourceItem(
              'Troubleshooting',
              'Common issues and solutions',
              Icons.build,
            ),
            ResourceItem(
              'App Updates',
              'What\'s new in each version',
              Icons.update,
            ),
            ResourceItem(
              'Privacy & Security',
              'Keeping your data safe',
              Icons.security,
            ),
          ]),
          const SizedBox(height: 24),
          _buildSupportContact(),
        ],
      ),
    );
  }

  Widget _buildResourceCategory(String title, List<ResourceItem> items) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.folder, color: AppTheme.deepGold),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...items.map((item) => _buildResourceItem(item)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceItem(ResourceItem item) {
    return ListTile(
      leading: Icon(item.icon, color: AppTheme.deepGold),
      title: Text(item.title),
      subtitle: Text(item.description),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${item.title} resource coming soon!')),
        );
      },
    );
  }

  Widget _buildSupportContact() {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.support_agent, color: AppTheme.primaryGold, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Still Need Help?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Our support team is here for you 24/7',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _tabController.animateTo(1),
                    icon: const Icon(Icons.message),
                    label: const Text('Contact Us'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGold,
                      foregroundColor: AppTheme.richBlack,
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

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=JKMG App Support Request',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      _showErrorDialog('Could not launch email client');
    }
  }

  Future<void> _launchPhone(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      _showErrorDialog('Could not launch phone dialer');
    }
  }

  Future<void> _launchWhatsApp(String phone) async {
    final Uri whatsappUri = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: phone,
      query: 'text=Hello, I need help with the JKMG app',
    );
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      _showErrorDialog('Could not launch WhatsApp');
    }
  }

  void _showScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Schedule a Call'),
        content: const Text(
          'This feature will allow you to schedule a one-on-one call with our support team. Implementation coming soon!',
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitContactForm() async {
    if (!_contactFormKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      // TODO: Implement actual form submission
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Message sent successfully! We\'ll get back to you soon.',
            ),
            backgroundColor: AppTheme.successGreen,
          ),
        );
        _clearForm();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending message: ${e.toString()}'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _subjectController.clear();
    _messageController.clear();
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem(this.question, this.answer);
}

class ResourceItem {
  final String title;
  final String description;
  final IconData icon;

  ResourceItem(this.title, this.description, this.icon);
}
