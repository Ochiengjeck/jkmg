import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

class AudioVideoTab extends ConsumerWidget {
  const AudioVideoTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WelcomeSection(
            title: 'Audio & Video Content',
            subtitle:
                'Access Rev. Julian\'s sermons, teachings, and prophetic messages in audio and video formats.',
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                _buildSectionHeader('Latest Sermons'),
                const SizedBox(height: 12),
                _buildMediaCard(
                  context,
                  'The Heart of Worship',
                  'Sunday Service - Dec 2024',
                  'Understanding true worship beyond songs',
                  Icons.play_circle_outline,
                  'Video • 48:32',
                  isVideo: true,
                ),
                _buildMediaCard(
                  context,
                  'Kingdom Economics Part 3',
                  'Wednesday Teaching - Nov 2024',
                  'God\'s principles for wealth creation',
                  Icons.headphones,
                  'Audio • 52:15',
                ),
                const SizedBox(height: 20),
                _buildSectionHeader('Prophetic Messages'),
                const SizedBox(height: 12),
                _buildMediaCard(
                  context,
                  '2025: Year of Divine Alignment',
                  'New Year Prophetic Word',
                  'Prophetic insights for the coming year',
                  Icons.record_voice_over,
                  'Audio • 35:20',
                ),
                _buildMediaCard(
                  context,
                  'The Season of Breakthrough',
                  'Rhema Experience Special',
                  'Breaking through spiritual barriers',
                  Icons.play_circle_outline,
                  'Video • 42:18',
                  isVideo: true,
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

  Widget _buildMediaCard(
    BuildContext context,
    String title,
    String date,
    String description,
    IconData icon,
    String duration, {
    bool isVideo = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 60,
              decoration: BoxDecoration(
                color: AppTheme.primaryGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppTheme.deepGold, size: 32),
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
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    duration,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.deepGold,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _playMedia(context, title, isVideo),
              icon: Icon(
                isVideo ? Icons.play_arrow : Icons.play_circle,
                color: AppTheme.primaryGold,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _playMedia(BuildContext context, String title, bool isVideo) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${isVideo ? 'Playing video' : 'Playing audio'}: "$title"',
        ),
        backgroundColor: AppTheme.primaryGold,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
