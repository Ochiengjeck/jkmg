import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/theme_notifier.dart';
import '../../provider/providers.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../services/preference_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _notificationsEnabled = true;
  bool _prayerReminders = true;
  bool _eventNotifications = true;
  bool _studyReminders = false;
  bool _offlineMode = false;
  double _fontSize = 16.0;
  String _selectedLanguage = 'English';

  final List<String> _languages = ['English', 'Swahili', 'French', 'Spanish'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadSettings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    // Load saved settings from shared preferences
    final prefs = await PreferenceService.getInstance();

    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _prayerReminders = prefs.getBool('prayer_reminders') ?? true;
      _eventNotifications = prefs.getBool('event_notifications') ?? true;
      _studyReminders = prefs.getBool('study_reminders') ?? false;
      _offlineMode = prefs.getBool('offline_mode') ?? false;
      _fontSize = prefs.getDouble('font_size') ?? 16.0;
      _selectedLanguage = prefs.getString('selected_language') ?? 'English';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await PreferenceService.getInstance();

    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    await prefs.setBool('prayer_reminders', _prayerReminders);
    await prefs.setBool('event_notifications', _eventNotifications);
    await prefs.setBool('study_reminders', _studyReminders);
    await prefs.setBool('offline_mode', _offlineMode);
    await prefs.setDouble('font_size', _fontSize);
    await prefs.setString('selected_language', _selectedLanguage);
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
                    child: _buildGeneralTab(),
                  ),
                  Container(
                    color: AppTheme.richBlack,
                    child: _buildNotificationsTab(),
                  ),
                  Container(
                    color: AppTheme.richBlack,
                    child: _buildAppearanceTab(),
                  ),
                  Container(color: AppTheme.richBlack, child: _buildDataTab()),
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
          const Icon(Icons.settings, color: AppTheme.primaryGold, size: 48),
          const SizedBox(height: 12),
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Customize Your App Experience',
            style: TextStyle(fontSize: 14, color: Colors.white70),
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
              isScrollable: true,
              indicator: BoxDecoration(
                color: AppTheme.primaryGold,
                borderRadius: BorderRadius.circular(20),
              ),
              indicatorPadding: const EdgeInsets.symmetric(
                vertical: 1,
                horizontal: 0,
              ),
              padding: EdgeInsets.all(0),
              labelPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              labelStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              tabs: [
                SizedBox(width: 100, child: Tab(text: 'General')),
                SizedBox(width: 100, child: Tab(text: 'Notifications')),
                SizedBox(width: 100, child: Tab(text: 'Appearance')),
                SizedBox(width: 100, child: Tab(text: 'Data')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'General Settings',
            subtitle: 'Basic app configuration',
          ),
          const SizedBox(height: 16),
          _buildLanguageSettings(),
          const SizedBox(height: 20),
          _buildPrayerSettings(),
          const SizedBox(height: 20),
          _buildAccountSettings(),
        ],
      ),
    );
  }

  Widget _buildLanguageSettings() {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.language, color: AppTheme.deepGold),
                const SizedBox(width: 12),
                const Text(
                  'Language & Region',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedLanguage,
              decoration: const InputDecoration(
                labelText: 'App Language',
                prefixIcon: Icon(Icons.translate, color: AppTheme.deepGold),
              ),
              items: _languages.map((language) {
                return DropdownMenuItem(value: language, child: Text(language));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                _saveSettings();
              },
            ),
            const SizedBox(height: 12),
            Text(
              'Restart app to apply language changes',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerSettings() {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.access_time, color: AppTheme.deepGold),
                const SizedBox(width: 12),
                const Text(
                  'Prayer Settings',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.schedule, color: AppTheme.deepGold),
              title: const Text('Prayer Times'),
              subtitle: const Text('06:00, 12:00, 18:00'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Prayer time customization coming soon!'),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.volume_up, color: AppTheme.deepGold),
              title: const Text('Prayer Sound'),
              subtitle: const Text('Default notification sound'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sound customization coming soon!'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSettings() {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_circle, color: AppTheme.deepGold),
                const SizedBox(width: 12),
                const Text(
                  'Account',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.security, color: AppTheme.deepGold),
              title: const Text('Privacy & Security'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Privacy settings coming soon!'),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.lock_reset, color: AppTheme.deepGold),
              title: const Text('Change Password'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password change coming soon!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Notification Preferences',
            subtitle: 'Manage when and how you receive notifications',
          ),
          const SizedBox(height: 16),
          CustomCard(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Enable Notifications'),
                    subtitle: const Text('Turn all notifications on/off'),
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                      _saveSettings();
                    },
                    activeColor: AppTheme.primaryGold,
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Prayer Reminders'),
                    subtitle: const Text('Get reminded for prayer times'),
                    value: _prayerReminders,
                    onChanged: _notificationsEnabled
                        ? (value) {
                            setState(() {
                              _prayerReminders = value;
                            });
                            _saveSettings();
                          }
                        : null,
                    activeColor: AppTheme.primaryGold,
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Event Notifications'),
                    subtitle: const Text('Updates about upcoming events'),
                    value: _eventNotifications,
                    onChanged: _notificationsEnabled
                        ? (value) {
                            setState(() {
                              _eventNotifications = value;
                            });
                            _saveSettings();
                          }
                        : null,
                    activeColor: AppTheme.primaryGold,
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Study Reminders'),
                    subtitle: const Text('Bible study session reminders'),
                    value: _studyReminders,
                    onChanged: _notificationsEnabled
                        ? (value) {
                            setState(() {
                              _studyReminders = value;
                            });
                            _saveSettings();
                          }
                        : null,
                    activeColor: AppTheme.primaryGold,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          CustomCard(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.schedule, color: AppTheme.deepGold),
                      const SizedBox(width: 12),
                      const Text(
                        'Quiet Hours',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Set times when you don\'t want to receive notifications',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    title: const Text('From: 22:00'),
                    subtitle: const Text('To: 06:00'),
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Quiet hours feature coming soon!'),
                          ),
                        );
                      },
                      activeColor: AppTheme.primaryGold,
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

  Widget _buildAppearanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Appearance Settings',
            subtitle: 'Customize how the app looks',
          ),
          const SizedBox(height: 16),
          _buildThemeSettings(),
          const SizedBox(height: 20),
          _buildFontSettings(),
        ],
      ),
    );
  }

  Widget _buildThemeSettings() {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.palette, color: AppTheme.deepGold),
                const SizedBox(width: 12),
                const Text(
                  'Theme',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Consumer(
              builder: (context, ref, child) {
                final isDarkMode = ref.watch(isDarkModeProvider);
                return Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Dark Mode'),
                      subtitle: const Text(
                        'Use dark theme for better night viewing',
                      ),
                      value: isDarkMode,
                      onChanged: (value) {
                        ref.read(themeProvider.notifier).toggleTheme();
                      },
                      activeColor: AppTheme.primaryGold,
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(
                        isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        color: AppTheme.deepGold,
                      ),
                      title: Text(
                        isDarkMode ? 'Dark Theme Active' : 'Light Theme Active',
                      ),
                      subtitle: const Text('Tap above to switch themes'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFontSettings() {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.text_fields, color: AppTheme.deepGold),
                const SizedBox(width: 12),
                const Text(
                  'Text Size',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Adjust text size for better readability',
              style: TextStyle(fontSize: _fontSize - 2),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('A', style: TextStyle(fontSize: 12)),
                Expanded(
                  child: Slider(
                    value: _fontSize,
                    min: 12.0,
                    max: 24.0,
                    divisions: 6,
                    label: _fontSize.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        _fontSize = value;
                      });
                    },
                    onChangeEnd: (value) {
                      _saveSettings();
                    },
                    activeColor: AppTheme.primaryGold,
                  ),
                ),
                Text('A', style: TextStyle(fontSize: 20)),
              ],
            ),
            Text(
              'Sample text at selected size',
              style: TextStyle(fontSize: _fontSize),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Data & Storage',
            subtitle: 'Manage app data and offline content',
          ),
          const SizedBox(height: 16),
          _buildOfflineSettings(),
          const SizedBox(height: 20),
          _buildStorageInfo(),
          const SizedBox(height: 20),
          _buildDataManagement(),
        ],
      ),
    );
  }

  Widget _buildOfflineSettings() {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.offline_bolt, color: AppTheme.deepGold),
                const SizedBox(width: 12),
                const Text(
                  'Offline Mode',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enable Offline Mode'),
              subtitle: const Text('Download content for offline access'),
              value: _offlineMode,
              onChanged: (value) {
                setState(() {
                  _offlineMode = value;
                });
                _saveSettings();
              },
              activeColor: AppTheme.primaryGold,
            ),
            if (_offlineMode) ...[
              const Divider(),
              ListTile(
                leading: Icon(Icons.download, color: AppTheme.deepGold),
                title: const Text('Download Content'),
                subtitle: const Text('Bible studies, prayers, and resources'),
                trailing: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Offline content download coming soon!'),
                      ),
                    );
                  },
                  child: const Text('Download'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStorageInfo() {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.storage, color: AppTheme.deepGold),
                const SizedBox(width: 12),
                const Text(
                  'Storage Usage',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStorageItem('App Data', '12.5 MB', 0.3),
            const SizedBox(height: 12),
            _buildStorageItem('Cached Images', '8.2 MB', 0.2),
            const SizedBox(height: 12),
            _buildStorageItem('Offline Content', '25.1 MB', 0.5),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Total: 45.8 MB',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.deepGold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _showClearCacheDialog();
                  },
                  child: const Text('Clear Cache'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageItem(String label, String size, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(size, style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGold),
        ),
      ],
    );
  }

  Widget _buildDataManagement() {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.manage_accounts, color: AppTheme.deepGold),
                const SizedBox(width: 12),
                const Text(
                  'Data Management',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.backup, color: AppTheme.deepGold),
              title: const Text('Backup Data'),
              subtitle: const Text('Save your app data to cloud'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Backup feature coming soon!')),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.restore, color: AppTheme.deepGold),
              title: const Text('Restore Data'),
              subtitle: const Text('Restore from previous backup'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Restore feature coming soon!')),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.delete_forever, color: Colors.red.shade600),
              title: const Text('Reset App Data'),
              subtitle: const Text('Clear all data and start fresh'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showResetDataDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Cache'),
          content: const Text(
            'This will clear cached images and temporary files. Your app data will remain intact.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cache cleared successfully!'),
                    backgroundColor: AppTheme.successGreen,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGold,
                foregroundColor: AppTheme.richBlack,
              ),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  void _showResetDataDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset App Data'),
          content: const Text(
            'This will permanently delete all your app data, preferences, and cached content. This action cannot be undone.\n\nAre you sure you want to continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Data reset feature will be available soon!'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
              ),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }
}
