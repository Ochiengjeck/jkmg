import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../models/notification.dart' as NotificationModel;
import '../../services/api_service.dart';
import '../../services/prayer_service.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  String _selectedFilter = 'all';
  final List<String> _filterOptions = ['all', 'unread', 'read'];
  final ApiService _apiService = ApiService();

  List<NotificationModel.Notification> _notifications = [];
  List<Map<String, dynamic>> _prayers = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Load notifications and prayers simultaneously
      await Future.wait([_loadNotifications(), _loadPrayers()]);
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadNotifications() async {
    try {
      // Don't pass status parameter when 'all' is selected, or pass empty string
      final response = _selectedFilter == 'all'
          ? await _apiService.getNotifications(perPage: 50)
          : await _apiService.getNotifications(
              status: _selectedFilter,
              perPage: 50,
            );
      setState(() {
        _notifications = response.data;
      });
    } catch (e) {
      print('Error loading notifications: $e');
      if (e.toString().contains('Unauthenticated')) {
        setState(() {
          _notifications = [];
        });
      }
    }
  }

  Future<void> _loadPrayers() async {
    try {
      final response = await _apiService.getScheduledPrayer();
      if (response['prayer'] != null) {
        setState(() {
          _prayers = [response['prayer']];
        });
      }
    } catch (e) {
      print('Error loading prayers: $e');
      if (e.toString().contains('Unauthenticated')) {
        setState(() {
          _prayers = [];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Inbox',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryGold,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryGold),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: AppTheme.primaryGold,
        child: Column(
          children: [
            _buildFilterSection(),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryGold,
                        ),
                      ),
                    )
                  : _error != null
                  ? _buildErrorState(_error!)
                  : _buildCombinedList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.accentGold.withOpacity(0.05),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.primaryGold.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.filter_list, color: AppTheme.primaryGold, size: 20),
          const SizedBox(width: 8),
          const Text(
            'Filter:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.deepGold,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: _filterOptions.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _selectedFilter = filter);
                      _loadData();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryGold.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryGold
                              : AppTheme.primaryGold.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        filter.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppTheme.deepGold
                              : AppTheme.primaryGold.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCombinedList() {
    final combinedItems = <Map<String, dynamic>>[];

    // Add prayers as special items
    for (var prayer in _prayers) {
      combinedItems.add({
        'type': 'prayer',
        'data': prayer,
        'created_at': prayer['created_at'] ?? DateTime.now().toIso8601String(),
      });
    }

    // Add notifications
    for (var notification in _notifications) {
      combinedItems.add({
        'type': 'notification',
        'data': notification,
        'created_at': notification.createdAt,
      });
    }

    // Sort by creation date (newest first)
    combinedItems.sort((a, b) {
      final dateA = DateTime.parse(a['created_at']);
      final dateB = DateTime.parse(b['created_at']);
      return dateB.compareTo(dateA);
    });

    if (combinedItems.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: combinedItems.length,
      itemBuilder: (context, index) {
        final item = combinedItems[index];
        if (item['type'] == 'prayer') {
          return _buildPrayerCard(item['data']);
        } else {
          return _buildNotificationCard(item['data']);
        }
      },
    );
  }

  Widget _buildPrayerCard(Map<String, dynamic> prayer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryGold.withOpacity(0.1),
            AppTheme.accentGold.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryGold.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGold.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _onPrayerTapped(prayer),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.play_circle_filled,
                  color: AppTheme.primaryGold,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            prayer['title'] ?? 'Prayer Audio',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.deepGold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGold,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'PRAYER',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.richBlack,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (prayer['pastor'] != null) ...[
                      Text(
                        'By ${prayer['pastor']['name']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.primaryGold.withOpacity(0.8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    Text(
                      prayer['message'] ?? 'Prayer message available',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color?.withOpacity(0.8),
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.headphones,
                          size: 14,
                          color: AppTheme.primaryGold.withOpacity(0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Tap to listen',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.primaryGold.withOpacity(0.7),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _formatNotificationTime(prayer['created_at'] ?? ''),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel.Notification notification) {
    final isUnread = !notification.isRead;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isUnread
            ? AppTheme.primaryGold.withOpacity(0.05)
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnread
              ? AppTheme.primaryGold.withOpacity(0.3)
              : Colors.grey.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _onNotificationTapped(notification),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getNotificationIconColor(
                    notification.type.value,
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getNotificationIcon(notification.type.value),
                  color: _getNotificationIconColor(notification.type.value),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isUnread
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              color: isUnread
                                  ? AppTheme.deepGold
                                  : Theme.of(
                                      context,
                                    ).textTheme.titleMedium?.color,
                            ),
                          ),
                        ),
                        if (isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryGold,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.body,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color?.withOpacity(0.8),
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatNotificationTime(notification.createdAt),
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
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: CustomCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryGold.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.inbox,
                size: 48,
                color: AppTheme.primaryGold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _selectedFilter == 'all'
                  ? 'Your inbox is empty'
                  : 'No $_selectedFilter notifications',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.deepGold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _selectedFilter == 'all'
                  ? 'You\'ll receive prayer notifications and updates here'
                  : 'Try changing the filter to see more notifications',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: CustomCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              'Error loading inbox',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGold,
                foregroundColor: AppTheme.richBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPrayerTapped(Map<String, dynamic> prayer) {
    final audioUrl = prayer['audio_url'];
    final title = prayer['title'] ?? 'Prayer';
    final message = prayer['message'] ?? '';

    if (audioUrl != null) {
      _showPrayerAudioDialog(title, message, audioUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No audio available for this prayer'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _onNotificationTapped(
    NotificationModel.Notification notification,
  ) async {
    if (!notification.isRead) {
      try {
        await _apiService.markNotificationAsRead(notification.id.toString());
        setState(() {
          final index = _notifications.indexWhere(
            (n) => n.id == notification.id,
          );
          if (index != -1) {
            _notifications[index] = notification.copyWith(isRead: true);
          }
        });
      } catch (e) {
        print('Error marking notification as read: $e');
      }
    }

    // Handle different notification types
    _handleNotificationAction(notification);
  }

  void _handleNotificationAction(NotificationModel.Notification notification) {
    switch (notification.type.value) {
      case 'prayer_reminder':
        _showPrayerReminderDialog(notification);
        break;
      case 'prayer_audio':
        _showNotificationPrayerDialog(notification);
        break;
      case 'deeper_prayer':
        _showDeeperPrayerDialog(notification);
        break;
      default:
        _showGeneralNotificationDialog(notification);
        break;
    }
  }

  void _showPrayerReminderDialog(NotificationModel.Notification notification) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.notifications_active,
                  color: AppTheme.primaryGold,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Prayer Reminder',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryGold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            notification.body,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Later'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to prayer plan
                Navigator.pushNamed(context, '/prayer-plan');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGold,
                foregroundColor: AppTheme.richBlack,
              ),
              child: const Text('Pray Now'),
            ),
          ],
        );
      },
    );
  }

  void _showPrayerAudioDialog(String title, String message, String audioUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.play_circle_filled,
                      color: AppTheme.primaryGold,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryGold,
                      ),
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGold.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        message,
                        style: const TextStyle(fontSize: 14, height: 1.4),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  StreamBuilder<PlayerState>(
                    stream: PrayerService.playerStateStream,
                    builder: (context, snapshot) {
                      final isPlaying = snapshot.data == PlayerState.playing;
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGold.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isPlaying ? Icons.volume_up : Icons.volume_off,
                              color: AppTheme.primaryGold,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isPlaying
                                  ? 'Prayer is playing...'
                                  : 'Ready to play prayer',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryGold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    await PrayerService.stopPrayerAudio();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                StreamBuilder<PlayerState>(
                  stream: PrayerService.playerStateStream,
                  builder: (context, snapshot) {
                    final isPlaying = snapshot.data == PlayerState.playing;
                    return ElevatedButton.icon(
                      onPressed: () async {
                        if (isPlaying) {
                          await PrayerService.stopPrayerAudio();
                        } else {
                          final success = await PrayerService.playPrayerAudio(
                            audioUrl,
                          );
                          if (!success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Failed to play prayer audio'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      icon: Icon(
                        isPlaying ? Icons.stop : Icons.play_arrow,
                        size: 16,
                      ),
                      label: Text(isPlaying ? 'Stop' : 'Play Prayer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGold,
                        foregroundColor: AppTheme.richBlack,
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showNotificationPrayerDialog(
    NotificationModel.Notification notification,
  ) {
    _showPrayerAudioDialog(
      'Prayer Audio Available',
      notification.body,
      '', // We would need to extract audio URL from notification data
    );
  }

  void _showDeeperPrayerDialog(NotificationModel.Notification notification) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.nightlight_round,
                  color: AppTheme.primaryGold,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Midnight Prayer',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryGold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            notification.body,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to deeper prayer
                Navigator.pushNamed(context, '/prayer-plan');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGold,
                foregroundColor: AppTheme.richBlack,
              ),
              child: const Text('Join Prayer'),
            ),
          ],
        );
      },
    );
  }

  void _showGeneralNotificationDialog(
    NotificationModel.Notification notification,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            notification.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryGold,
            ),
          ),
          content: Text(
            notification.body,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGold,
                foregroundColor: AppTheme.richBlack,
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'prayer_reminder':
        return Icons.notifications_active;
      case 'prayer_audio':
        return Icons.play_circle_filled;
      case 'deeper_prayer':
        return Icons.nightlight_round;
      case 'event':
        return Icons.event;
      case 'testimony':
        return Icons.favorite;
      case 'system':
        return Icons.info;
      default:
        return Icons.mail;
    }
  }

  Color _getNotificationIconColor(String type) {
    switch (type) {
      case 'prayer_reminder':
        return AppTheme.primaryGold;
      case 'prayer_audio':
        return AppTheme.successGreen;
      case 'deeper_prayer':
        return Colors.purple;
      case 'event':
        return Colors.blue;
      case 'testimony':
        return Colors.red;
      case 'system':
        return Colors.orange;
      default:
        return AppTheme.primaryGold;
    }
  }

  String _formatNotificationTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } catch (e) {
      return 'Recently';
    }
  }
}
