import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

class DigitalMaterialsTab extends ConsumerWidget {
  const DigitalMaterialsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WelcomeSection(
            title: 'JKMG Digital Materials',
            subtitle:
                'Gain free access to Rev. Julian\'s wealth of wisdom—both in spiritual matters and marketplace leadership—through downloadable content including eBooks, audiobooks, and recorded messages.',
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                _buildSectionHeader('eBooks & Audiobooks'),
                const SizedBox(height: 12),
                _buildResourceCard(
                  context,
                  'Marketplace Leadership',
                  'Rev. Julian Kyula',
                  'Essential principles for Christian leadership in business and ministry',
                  Icons.business_center,
                  'Available in English, Swahili',
                ),
                const SizedBox(height: 12),
                _buildResourceCard(
                  context,
                  'Spiritual Growth Guide',
                  'Rev. Julian Kyula',
                  'A comprehensive guide to deepening your relationship with God',
                  Icons.spa,
                  'Available in English, French',
                ),
                const SizedBox(height: 12),
                _buildResourceCard(
                  context,
                  'Prayer & Intercession',
                  'Rev. Julian Kyula',
                  'Unlocking the power of effective prayer in daily life',
                  Icons.favorite,
                  'Available in English, Swahili, Spanish',
                ),
                const SizedBox(height: 20),
                _buildSectionHeader('Recorded Messages'),
                const SizedBox(height: 12),
                _buildResourceCard(
                  context,
                  'Faith in the Marketplace',
                  'Rev. Julian Kyula',
                  'Sermon series on integrating faith with business practices',
                  Icons.mic,
                  'Audio format - 45 minutes',
                ),
                _buildResourceCard(
                  context,
                  'Kingdom Economics',
                  'Rev. Julian Kyula',
                  'Understanding God\'s principles for financial stewardship',
                  Icons.attach_money,
                  'Audio format - 52 minutes',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppTheme.deepGold,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildResourceCard(
    BuildContext context,
    String title,
    String author,
    String description,
    IconData icon,
    String format,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                    color: AppTheme.primaryGold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppTheme.deepGold, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.richBlack,
                        ),
                      ),
                      Text(
                        'by $author',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _downloadResource(context, title),
                  icon: const Icon(Icons.download, color: AppTheme.deepGold),
                  tooltip: 'Download',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGold.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    format,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.deepGold,
                    ),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _viewResourceDetails(context, title),
                  child: const Text(
                    'View Details',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.deepGold,
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

  void _downloadResource(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading "$title"...'),
        backgroundColor: AppTheme.primaryGold,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _viewResourceDetails(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: const Text('Resource details will be available soon.'),
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
