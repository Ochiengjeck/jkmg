import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/app_theme.dart';
import 'agent_selection_screen.dart';
import 'conversation_list_screen.dart';

class AICounselingScreen extends StatefulWidget {
  const AICounselingScreen({super.key});

  @override
  State<AICounselingScreen> createState() => _AICounselingScreenState();
}

class _AICounselingScreenState extends State<AICounselingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Create a temporary hosted URL for the Pickaxe chatbot
  String get _pickaxeChatbotUrl => 
      'https://studio.pickaxe.co/embed/bec6cee6-5db7-4230-aeba-c999039ad289';

  Future<void> _launchChatbot() async {
    final Uri url = Uri.parse(_pickaxeChatbotUrl);
    try {
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication, // Opens in browser
        webViewConfiguration: const WebViewConfiguration(
          enableJavaScript: true,
        ),
      )) {
        throw Exception('Could not launch chatbot');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening AI Assistant: $e'),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    }
  }

  void _startNewChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AgentSelectionScreen(),
      ),
    );
  }

  void _viewConversations() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ConversationListScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.charcoalBlack,
      appBar: AppBar(
        title: const Text(
          'AI Counseling Assistant',
          style: TextStyle(
            color: AppTheme.primaryGold,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppTheme.richBlack,
        iconTheme: const IconThemeData(color: AppTheme.primaryGold),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _showHelpDialog(context);
            },
            icon: const Icon(Icons.help_outline),
            tooltip: 'How to use AI Assistant',
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Hero Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryGold.withOpacity(0.15),
                        AppTheme.deepGold.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.primaryGold.withOpacity(0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryGold.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGold,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryGold.withOpacity(0.4),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.psychology,
                          size: 48,
                          color: AppTheme.richBlack,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'JKMG AI Counseling Assistant',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primaryGold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Biblical guidance and spiritual support powered by AI',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Bible Verse Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGold.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border(
                      left: BorderSide(
                        color: AppTheme.primaryGold,
                        width: 4,
                      ),
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '"The Lord is close to the brokenhearted and saves those who are crushed in spirit."',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '- Psalm 34:18',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.primaryGold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Features Section
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.richBlack,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.primaryGold.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'What you can expect:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryGold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildFeatureItem(
                        Icons.auto_stories,
                        'Biblical Guidance',
                        'Receive wisdom backed by relevant Scripture verses',
                      ),
                      _buildFeatureItem(
                        Icons.favorite,
                        'Spiritual Support',
                        'Get personalized care for your spiritual needs',
                      ),
                      _buildFeatureItem(
                        Icons.access_time,
                        '24/7 Availability',
                        'Access Christian counseling anytime you need it',
                      ),
                      _buildFeatureItem(
                        Icons.privacy_tip,
                        'Confidential',
                        'Your conversations are private and secure',
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: _startNewChat,
                          icon: const Icon(Icons.psychology, size: 20),
                          label: const Text(
                            'New Chat',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryGold,
                            foregroundColor: AppTheme.richBlack,
                            elevation: 6,
                            shadowColor: AppTheme.primaryGold.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: _viewConversations,
                          icon: const Icon(Icons.chat_bubble_outline, size: 20),
                          label: const Text(
                            'My Chats',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.richBlack,
                            foregroundColor: AppTheme.primaryGold,
                            elevation: 6,
                            shadowColor: Colors.black.withOpacity(0.3),
                            side: BorderSide(
                              color: AppTheme.primaryGold.withOpacity(0.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Web-based option
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: _launchChatbot,
                    icon: const Icon(Icons.open_in_browser, size: 18),
                    label: const Text(
                      'Open Web Version',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryGold,
                      side: BorderSide(
                        color: AppTheme.primaryGold.withOpacity(0.5),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Disclaimer
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.orange.shade300,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'This AI provides spiritual guidance but cannot replace professional counseling for serious mental health concerns.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryGold,
              size: 20,
            ),
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
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
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

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.charcoalBlack,
        title: const Row(
          children: [
            Icon(Icons.psychology, color: AppTheme.primaryGold),
            SizedBox(width: 8),
            Text(
              'AI Counseling Assistant',
              style: TextStyle(color: AppTheme.primaryGold),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How to use your AI Assistant:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            Text(
              '• Share your concerns or questions',
              style: TextStyle(color: Colors.white70),
            ),
            Text(
              '• Receive biblical guidance and scripture',
              style: TextStyle(color: Colors.white70),
            ),
            Text(
              '• Get personalized spiritual support',
              style: TextStyle(color: Colors.white70),
            ),
            Text(
              '• Access 24/7 Christian counseling',
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 12),
            Text(
              'Remember: This AI provides spiritual guidance but cannot replace professional counseling for serious mental health concerns.',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.primaryGold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Got it!',
              style: TextStyle(color: AppTheme.primaryGold),
            ),
          ),
        ],
      ),
    );
  }
}