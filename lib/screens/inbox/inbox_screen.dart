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

class _InboxScreenState extends State<InboxScreen> with WidgetsBindingObserver {
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
    WidgetsBinding.instance.addObserver(this);
    _loadData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh data when app comes back into focus
      _loadData();
    }
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
      backgroundColor: AppTheme.richBlack,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => AppTheme.primaryGoldGradient.createShader(bounds),
          child: const Text(
            'Inbox',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 24,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryGold.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.primaryGold.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryGold, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryGold.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.mark_email_read_outlined, color: AppTheme.primaryGold, size: 20),
              onPressed: () => _markAllAsRead(),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.darkBackgroundGradient,
        ),
        child: RefreshIndicator(
          onRefresh: _loadData,
          color: AppTheme.primaryGold,
          backgroundColor: AppTheme.charcoalBlack,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: kToolbarHeight + 40),
                    _buildStatsSection(),
                    _buildFilterSection(),
                  ],
                ),
              ),
              _isLoading
                  ? SliverFillRemaining(child: _buildLoadingState())
                  : _error != null
                  ? SliverFillRemaining(child: _buildErrorState(_error!))
                  : _buildCombinedListSliver(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    final totalNotifications = _notifications.length;
    final unreadCount = _notifications.where((n) => !n.isRead).length;
    final prayerCount = _prayers.length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryGold.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildStatItem(
            icon: Icons.mail_outline,
            label: 'Total',
            count: totalNotifications,
            color: AppTheme.primaryGold,
          ),
          const SizedBox(width: 16),
          _buildStatItem(
            icon: Icons.mark_email_unread,
            label: 'Unread',
            count: unreadCount,
            color: AppTheme.successGreen,
          ),
          const SizedBox(width: 16),
          _buildStatItem(
            icon: Icons.play_circle_filled,
            label: 'Prayers',
            count: prayerCount,
            color: AppTheme.deepGold,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required int count,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 6),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primaryGold.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.primaryGold.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGold),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          ShaderMask(
            shaderCallback: (bounds) => AppTheme.primaryGoldGradient.createShader(bounds),
            child: const Text(
              'Loading your messages...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryGold.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.tune,
                  color: AppTheme.primaryGold,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Filter Messages',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryGold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
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
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? AppTheme.primaryGoldGradient
                            : null,
                        color: isSelected
                            ? null
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : AppTheme.primaryGold.withOpacity(0.5),
                          width: 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppTheme.primaryGold.withOpacity(0.2),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        _getFilterDisplayName(filter),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? AppTheme.richBlack
                              : AppTheme.primaryGold,
                          letterSpacing: 0.3,
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

  String _getFilterDisplayName(String filter) {
    switch (filter) {
      case 'all':
        return 'All Messages';
      case 'unread':
        return 'Unread';
      case 'read':
        return 'Read';
      default:
        return filter.toUpperCase();
    }
  }

  Widget _buildCombinedListSliver() {
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
      return SliverFillRemaining(child: _buildEmptyState());
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = combinedItems[index];
            return Padding(
              padding: EdgeInsets.only(bottom: index < combinedItems.length - 1 ? 8 : 0),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300 + (index * 30)),
                child: item['type'] == 'prayer'
                    ? _buildPrayerCard(item['data'])
                    : _buildNotificationCard(item['data']),
              ),
            );
          },
          childCount: combinedItems.length,
        ),
      ),
    );
  }

  Widget _buildPrayerCard(Map<String, dynamic> prayer) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryGold.withOpacity(0.15),
            AppTheme.deepGold.withOpacity(0.1),
            AppTheme.primaryGold.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryGold.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            spreadRadius: 0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onPrayerTapped(prayer),
          borderRadius: BorderRadius.circular(20),
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
                        gradient: AppTheme.primaryGoldGradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryGold.withOpacity(0.2),
                            blurRadius: 4,
                            spreadRadius: 0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.play_circle_filled,
                        color: AppTheme.richBlack,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: AppTheme.primaryGoldGradient,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.volume_up,
                                  size: 14,
                                  color: AppTheme.richBlack,
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'PRAYER AUDIO',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    color: AppTheme.richBlack,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            prayer['title'] ?? 'Prayer Audio',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primaryGold,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (prayer['pastor'] != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryGold.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGold.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 16,
                            color: AppTheme.primaryGold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Led by',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              prayer['pastor']['name'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.primaryGold,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                if (prayer['message'] != null && prayer['message'].isNotEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryGold.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      prayer['message'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGold.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.primaryGold.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            prayer['prayer'] != null && prayer['prayer'].toString().isNotEmpty 
                              ? Icons.headphones 
                              : Icons.hourglass_empty,
                            size: 16,
                            color: AppTheme.primaryGold,
                          ),
                          SizedBox(width: 6),
                          Text(
                            prayer['prayer'] != null && prayer['prayer'].toString().isNotEmpty
                              ? 'Tap to listen'
                              : 'Prayer coming soon',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.primaryGold,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatNotificationTime(prayer['created_at'] ?? ''),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel.Notification notification) {
    final isUnread = !notification.isRead;
    final notificationColor = _getNotificationIconColor(notification.type.value);

    return Container(
      decoration: BoxDecoration(
        gradient: isUnread
            ? LinearGradient(
                colors: [
                  notificationColor.withOpacity(0.1),
                  notificationColor.withOpacity(0.05),
                  Colors.transparent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isUnread ? null : AppTheme.charcoalBlack.withOpacity(0.7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isUnread
              ? notificationColor.withOpacity(0.4)
              : AppTheme.primaryGold.withOpacity(0.2),
          width: isUnread ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 4,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onNotificationTapped(notification),
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: isUnread
                            ? LinearGradient(
                                colors: [
                                  notificationColor,
                                  notificationColor.withOpacity(0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: isUnread ? null : notificationColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: isUnread
                            ? [
                                BoxShadow(
                                  color: notificationColor.withOpacity(0.2),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        _getNotificationIcon(notification.type.value),
                        color: isUnread ? Colors.white : notificationColor,
                        size: 18,
                      ),
                    ),
                    if (isUnread)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGold,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.richBlack,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: notificationColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: notificationColor.withOpacity(0.4),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              _getNotificationTypeDisplay(notification.type.value),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: notificationColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _formatNotificationTime(notification.createdAt),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        notification.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isUnread ? FontWeight.w800 : FontWeight.w600,
                          color: isUnread ? Colors.white : Colors.white.withOpacity(0.9),
                          letterSpacing: 0.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        notification.body,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.7),
                          height: 1.4,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (isUnread) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: notificationColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: notificationColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.touch_app,
                                size: 14,
                                color: notificationColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Tap to read',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: notificationColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  String _getNotificationTypeDisplay(String type) {
    switch (type) {
      case 'prayer_reminder':
        return 'PRAYER';
      case 'prayer_audio':
        return 'AUDIO';
      case 'deeper_prayer':
        return 'MIDNIGHT';
      case 'event':
        return 'EVENT';
      case 'testimony':
        return 'TESTIMONY';
      case 'system':
        return 'SYSTEM';
      default:
        return 'MESSAGE';
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    AppTheme.primaryGold.withOpacity(0.1),
                    AppTheme.primaryGold.withOpacity(0.05),
                    Colors.transparent,
                  ],
                  radius: 1.0,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primaryGold.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                _selectedFilter == 'all' ? Icons.inbox_outlined : Icons.filter_list_off,
                size: 64,
                color: AppTheme.primaryGold,
              ),
            ),
            const SizedBox(height: 24),
            ShaderMask(
              shaderCallback: (bounds) => AppTheme.primaryGoldGradient.createShader(bounds),
              child: Text(
                _selectedFilter == 'all'
                    ? 'Your Inbox is Empty'
                    : 'No ${_getFilterDisplayName(_selectedFilter)} Found',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _selectedFilter == 'all'
                  ? 'You\'ll receive prayer notifications, ministry updates, and community messages here'
                  : 'Try selecting "All Messages" to see your complete inbox',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
                height: 1.5,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            if (_selectedFilter != 'all') ...[
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGoldGradient,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryGold.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() => _selectedFilter = 'all');
                      _loadData();
                    },
                    borderRadius: BorderRadius.circular(25),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.visibility,
                            size: 20,
                            color: AppTheme.richBlack,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Show All Messages',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.richBlack,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
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

  Future<void> _markAllAsRead() async {
    try {
      final unreadNotifications = _notifications.where((n) => !n.isRead).toList();
      
      if (unreadNotifications.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.info, color: Colors.white, size: 20),
                SizedBox(width: 12),
                Text('No unread notifications to mark'),
              ],
            ),
            backgroundColor: AppTheme.primaryGold,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        return;
      }

      // Mark all unread notifications as read
      for (final notification in unreadNotifications) {
        await _apiService.markNotificationAsRead(notification.id.toString());
      }

      // Update local state
      setState(() {
        for (int i = 0; i < _notifications.length; i++) {
          if (!_notifications[i].isRead) {
            _notifications[i] = _notifications[i].copyWith(isRead: true);
          }
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.mark_email_read, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Text('Marked ${unreadNotifications.length} messages as read'),
            ],
          ),
          backgroundColor: AppTheme.successGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Text('Failed to mark messages as read'),
            ],
          ),
          backgroundColor: AppTheme.errorRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _onPrayerTapped(Map<String, dynamic> prayer) {
    final audioUrl = prayer['prayer'];
    final title = prayer['title'] ?? 'Prayer Audio from Rev Julian Kyula';
    final message = prayer['message'] ?? 'A special prayer message for you';

    if (audioUrl != null && audioUrl.isNotEmpty) {
      _showPrayerAudioDialog(title, message, audioUrl);
    } else {
      _showPrayerMessageDialog(title, message);
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

  void _showPrayerMessageDialog(String title, String message) {
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
                  Icons.favorite,
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message,
                  style: const TextStyle(fontSize: 16, height: 1.4),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.orange.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info,
                      color: Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Audio prayer will be available soon.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGold,
                foregroundColor: AppTheme.richBlack,
              ),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showNotificationPrayerDialog(
    NotificationModel.Notification notification,
  ) {
    // Try to extract prayer URL from notification data
    final notificationData = notification.data;
    final prayerUrl = notificationData?['prayer_url'] ?? notificationData?['prayer'];
    
    if (prayerUrl != null && prayerUrl.isNotEmpty) {
      _showPrayerAudioDialog(
        'Prayer Audio Available',
        notification.body,
        prayerUrl,
      );
    } else {
      _showPrayerMessageDialog('Prayer Message', notification.body);
    }
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
