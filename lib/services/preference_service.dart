import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';

class PreferenceService {
  static PreferenceService? _instance;
  static SharedPreferences? _prefs;

  PreferenceService._();

  static Future<PreferenceService> getInstance() async {
    _instance ??= PreferenceService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // Theme Preferences
  static const String _themeKey = 'theme_mode';
  static const String _isFirstLaunchKey = 'is_first_launch';

  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _prefs?.setString(_themeKey, themeMode.name);
  }

  ThemeMode getThemeMode() {
    final themeName = _prefs?.getString(_themeKey) ?? ThemeMode.light.name;
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == themeName,
      orElse: () => ThemeMode.light,
    );
  }

  Future<void> setFirstLaunch(bool isFirst) async {
    await _prefs?.setBool(_isFirstLaunchKey, isFirst);
  }

  bool isFirstLaunch() {
    return _prefs?.getBool(_isFirstLaunchKey) ?? true;
  }

  // User Preferences
  static const String _userDataKey = 'user_data';
  static const String _prayerTimesKey = 'prayer_times';
  static const String _timezoneKey = 'timezone';
  static const String _countryKey = 'country';
  static const String _languageKey = 'language';

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _prefs?.setString(_userDataKey, json.encode(userData));
  }

  Map<String, dynamic>? getUserData() {
    final userDataString = _prefs?.getString(_userDataKey);
    if (userDataString != null) {
      try {
        return json.decode(userDataString) as Map<String, dynamic>;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> setPrayerTimes(List<String> prayerTimes) async {
    await _prefs?.setStringList(_prayerTimesKey, prayerTimes);
  }

  List<String> getPrayerTimes() {
    return _prefs?.getStringList(_prayerTimesKey) ??
        ['06:00', '12:00', '18:00']; // Default prayer times
  }

  Future<void> setTimezone(String timezone) async {
    await _prefs?.setString(_timezoneKey, timezone);
  }

  String getTimezone() {
    return _prefs?.getString(_timezoneKey) ?? 'UTC';
  }

  Future<void> setCountry(String country) async {
    await _prefs?.setString(_countryKey, country);
  }

  String getCountry() {
    return _prefs?.getString(_countryKey) ?? 'Kenya';
  }

  Future<void> setLanguage(String language) async {
    await _prefs?.setString(_languageKey, language);
  }

  String getLanguage() {
    return _prefs?.getString(_languageKey) ?? 'English';
  }

  // Offline Data Cache
  static const String _cachedEventsKey = 'cached_events';
  static const String _cachedPrayersKey = 'cached_prayers';
  static const String _cachedStudiesKey = 'cached_studies';
  static const String _cachedResourcesKey = 'cached_resources';
  static const String _lastSyncKey = 'last_sync';

  Future<void> cacheEvents(List<Map<String, dynamic>> events) async {
    await _prefs?.setString(_cachedEventsKey, json.encode(events));
    await _updateLastSync();
  }

  List<Map<String, dynamic>> getCachedEvents() {
    final eventsString = _prefs?.getString(_cachedEventsKey);
    if (eventsString != null) {
      try {
        final List<dynamic> decoded = json.decode(eventsString);
        return decoded.cast<Map<String, dynamic>>();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  Future<void> cachePrayers(List<Map<String, dynamic>> prayers) async {
    await _prefs?.setString(_cachedPrayersKey, json.encode(prayers));
    await _updateLastSync();
  }

  List<Map<String, dynamic>> getCachedPrayers() {
    final prayersString = _prefs?.getString(_cachedPrayersKey);
    if (prayersString != null) {
      try {
        final List<dynamic> decoded = json.decode(prayersString);
        return decoded.cast<Map<String, dynamic>>();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  Future<void> cacheStudies(List<Map<String, dynamic>> studies) async {
    await _prefs?.setString(_cachedStudiesKey, json.encode(studies));
    await _updateLastSync();
  }

  List<Map<String, dynamic>> getCachedStudies() {
    final studiesString = _prefs?.getString(_cachedStudiesKey);
    if (studiesString != null) {
      try {
        final List<dynamic> decoded = json.decode(studiesString);
        return decoded.cast<Map<String, dynamic>>();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  Future<void> cacheResources(List<Map<String, dynamic>> resources) async {
    await _prefs?.setString(_cachedResourcesKey, json.encode(resources));
    await _updateLastSync();
  }

  List<Map<String, dynamic>> getCachedResources() {
    final resourcesString = _prefs?.getString(_cachedResourcesKey);
    if (resourcesString != null) {
      try {
        final List<dynamic> decoded = json.decode(resourcesString);
        return decoded.cast<Map<String, dynamic>>();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  Future<void> _updateLastSync() async {
    await _prefs?.setString(_lastSyncKey, DateTime.now().toIso8601String());
  }

  DateTime? getLastSync() {
    final lastSyncString = _prefs?.getString(_lastSyncKey);
    if (lastSyncString != null) {
      try {
        return DateTime.parse(lastSyncString);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Notification Preferences
  static const String _notificationEnabledKey = 'notifications_enabled';
  static const String _prayerNotificationsKey = 'prayer_notifications';
  static const String _eventNotificationsKey = 'event_notifications';

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs?.setBool(_notificationEnabledKey, enabled);
  }

  bool getNotificationsEnabled() {
    return _prefs?.getBool(_notificationEnabledKey) ?? true;
  }

  Future<void> setPrayerNotifications(bool enabled) async {
    await _prefs?.setBool(_prayerNotificationsKey, enabled);
  }

  bool getPrayerNotifications() {
    return _prefs?.getBool(_prayerNotificationsKey) ?? true;
  }

  Future<void> setEventNotifications(bool enabled) async {
    await _prefs?.setBool(_eventNotificationsKey, enabled);
  }

  bool getEventNotifications() {
    return _prefs?.getBool(_eventNotificationsKey) ?? true;
  }

  // App State
  static const String _authTokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';

  Future<void> saveAuthToken(String token) async {
    await _prefs?.setString(_authTokenKey, token);
  }

  String? getAuthToken() {
    return _prefs?.getString(_authTokenKey);
  }

  Future<void> saveUserId(String userId) async {
    await _prefs?.setString(_userIdKey, userId);
  }

  String? getUserId() {
    return _prefs?.getString(_userIdKey);
  }

  // User Session Management
  static const String _userSessionKey = 'user_session';

  Future<void> saveUserSession(User user) async {
    final userJson = user.toJson();
    await _prefs?.setString(_userSessionKey, json.encode(userJson));
    await saveUserId(user.id.toString());
  }

  Future<User?> getUserSession() async {
    final userSessionString = _prefs?.getString(_userSessionKey);
    if (userSessionString != null) {
      try {
        final userJson = json.decode(userSessionString) as Map<String, dynamic>;
        return User.fromJson(userJson);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> clearUserSession() async {
    await _prefs?.remove(_userSessionKey);
  }

  Future<void> clearAuthData() async {
    await _prefs?.remove(_authTokenKey);
    await _prefs?.remove(_userIdKey);
    await _prefs?.remove(_userDataKey);
    await _prefs?.remove(_userSessionKey);
  }

  // Generic methods for custom data
  Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  String? getString(String key) {
    return _prefs?.getString(key);
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  Future<void> setDouble(String key, double value) async {
    await _prefs?.setDouble(key, value);
  }

  double? getDouble(String key) {
    return _prefs?.getDouble(key);
  }

  Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  Future<void> clear() async {
    await _prefs?.clear();
  }

  bool containsKey(String key) {
    return _prefs?.containsKey(key) ?? false;
  }

  Set<String> getKeys() {
    return _prefs?.getKeys() ?? <String>{};
  }
}

// Extension for easier access to preferences
extension PreferenceExtensions on PreferenceService {
  // Quick access methods
  bool get isDarkMode => getThemeMode() == ThemeMode.dark;
  bool get isLoggedIn => getAuthToken() != null;
  bool get hasUserData => getUserData() != null;

  Future<void> toggleTheme() async {
    final currentMode = getThemeMode();
    final newMode = currentMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    await setThemeMode(newMode);
  }
}
