import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/user.dart';
import '../models/prayer.dart';
import '../models/bible_study.dart';
import '../models/event.dart';
import '../models/registration_model.dart';
import '../models/resource.dart';
import '../models/testimony.dart';
import '../models/donation.dart';
import '../models/counseling.dart';
import '../models/salvation.dart';
import '../models/notification.dart';
import '../models/feedback.dart';
import 'preference_service.dart';

class ApiService {
  final String baseUrl =
      dotenv.env['BASE_URL'] ?? 'https://jkmg.laravel.cloud/api';
  String? _token;

  ApiService() {
    _loadTokenFromStorage();
  }

  Future<void> _loadTokenFromStorage() async {
    final prefs = await PreferenceService.getInstance();
    _token = prefs.getAuthToken();
  }

  // Helper method to get headers
  Future<Map<String, String>> _getHeaders([bool includeAuth = true]) async {
    // Ensure token is loaded before making requests
    if (_token == null) {
      await _loadTokenFromStorage();
    }

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (includeAuth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  // Authentication
  Future<User> register({
    required String name,
    required String phone,
    required String country,
    required String password,
    required String passwordConfirmation,
    String? email,
    String? timezone,
    List<String>? prayerTimes,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: await _getHeaders(false),
      body: jsonEncode({
        'name': name,
        'phone': phone,
        'country': country,
        'password': password,
        'password_confirmation': passwordConfirmation,
        if (email != null) 'email': email,
        if (timezone != null) 'timezone': timezone,
        if (prayerTimes != null) 'prayer_times': prayerTimes,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      _token = data['token'];

      // Save token to storage
      final prefs = await PreferenceService.getInstance();
      await prefs.saveAuthToken(_token!);

      return User.fromJson(data['user']);
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  Future<User> login({
    required String username,
    required String password,
  }) async {
    final Map<String, dynamic> loginData = {
      'username': username,
      'password': password,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: await _getHeaders(false),
      body: jsonEncode(loginData),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['token'];

      // Save token to storage
      final prefs = await PreferenceService.getInstance();
      await prefs.saveAuthToken(_token!);

      return User.fromJson(data['user']);
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  // Forgot Password
  Future<void> forgotPassword({required String email}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/forgot-password'),
      headers: await _getHeaders(false),
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send password reset email: ${response.body}');
    }
  }

  // Send OTP for password reset
  Future<void> sendPasswordResetOtp({required String email}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/email/verification/send'),
      headers: await _getHeaders(false),
      body: jsonEncode({'email': email, 'for_reset': true}),
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Failed to send OTP');
    }
  }

  // Verify OTP for password reset
  Future<String> verifyPasswordResetOtp({
    required String email,
    required String otp,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/email/verification/verify'),
      headers: await _getHeaders(false),
      body: jsonEncode({'email': email, 'otp': otp}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['reset_token'] ?? '';
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Failed to verify OTP');
    }
  }

  // Reset password using token
  Future<void> resetPasswordWithToken({
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reset-password'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Failed to reset password');
    }
  }

  Future<void> logout() async {
    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      _token = null;

      // Clear token from storage
      final prefs = await PreferenceService.getInstance();
      await prefs.clearAuthData();
    } else {
      throw Exception('Failed to logout: ${response.body}');
    }
  }

  // Helper method to check for authentication errors and clear tokens
  Future<void> _handleAuthenticationError(http.Response response) async {
    if (response.statusCode == 401) {
      // Clear stored token when we get unauthorized
      _token = null;
      final prefs = await PreferenceService.getInstance();
      await prefs.clearAuthData();
    }
  }

  // User Management
  Future<User> getCurrentUser() async {
    final response = await http.get(
      Uri.parse('$baseUrl/user'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data['user']);
    } else {
      await _handleAuthenticationError(response);
      throw Exception('Failed to get user: ${response.body}');
    }
  }

  Future<User> updateProfile({
    String? name,
    String? email,
    String? country,
    String? timezone,
    List<String>? prayerTimes,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/user/profile'),
      headers: await _getHeaders(),
      body: jsonEncode({
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (country != null) 'country': country,
        if (timezone != null) 'timezone': timezone,
        if (prayerTimes != null) 'prayer_times': prayerTimes,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data['user']);
    } else {
      throw Exception('Failed to update profile: ${response.body}');
    }
  }

  // Prayer System
  Future<PrayerSchedule> getPrayerSchedule() async {
    final response = await http.get(
      Uri.parse('$baseUrl/prayers/schedule'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PrayerSchedule.fromJson(data);
    } else {
      throw Exception('Failed to get prayer schedule: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getScheduledPrayer({int? prayerId}) async {
    String endpoint = '$baseUrl/prayers/scheduled';
    if (prayerId != null) {
      endpoint += '?prayer_id=$prayerId';
    }

    final response = await http.get(
      Uri.parse(endpoint),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get scheduled prayer: ${response.body}');
    }
  }

  Future<PrayerRequest> createPrayerRequest({
    required String title,
    required String description,
    required String category,
    required String urgency,
    required bool isAnonymous,
    required bool isPublic,
    required String startDate,
    required String endDate,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/prayers/request'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'title': title,
        'description': description,
        'category': category,
        'urgency': urgency,
        'is_anonymous': isAnonymous,
        'is_public': isPublic,
        'start_date': startDate,
        'end_date': endDate,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return PrayerRequest.fromJson(data['prayer_request']);
    } else {
      throw Exception('Failed to create prayer request: ${response.body}');
    }
  }

  Future<DeeperPrayerInfo> getDeeperPrayerInfo() async {
    final response = await http.get(
      Uri.parse('$baseUrl/prayers/deeper'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return DeeperPrayerInfo.fromJson(data);
    } else {
      throw Exception('Failed to get deeper prayer info: ${response.body}');
    }
  }

  Future<DeeperPrayerParticipation> participateInDeeperPrayer({
    required int duration,
    String? notes,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/prayers/deeper'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'duration': duration,
        if (notes != null) 'notes': notes,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return DeeperPrayerParticipation.fromJson(data['participation']);
    } else {
      throw Exception(
        'Failed to record deeper prayer participation: ${response.body}',
      );
    }
  }

  // Bible Studies
  Future<BibleStudy> getTodaysBibleStudy() async {
    final response = await http.get(
      Uri.parse('$baseUrl/bible/today'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return BibleStudy.fromJson(data['study']);
    } else {
      throw Exception('Failed to get today\'s Bible study: ${response.body}');
    }
  }

  Future<PaginatedResponse<BibleStudy>> getBibleStudies({
    String? startDate,
    String? endDate,
    String? search,
    int? perPage,
  }) async {
    final queryParameters = {
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (search != null) 'search': search,
      if (perPage != null) 'per_page': perPage.toString(),
    };

    final response = await http.get(
      Uri.parse(
        '$baseUrl/bible/studies',
      ).replace(queryParameters: queryParameters),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return PaginatedResponse.fromJson(
        data,
        (json) => BibleStudy.fromJson(json),
      );
    } else {
      throw Exception('Failed to get Bible studies: ${response.body}');
    }
  }

  // Events
  Future<PaginatedResponse<Event>> getEvents({
    String? type,
    String? status,
    bool? withLivestream,
    int? perPage,
  }) async {
    final queryParameters = {
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (withLivestream != null) 'with_livestream': withLivestream.toString(),
      if (perPage != null) 'per_page': perPage.toString(),
    };

    final response = await http.get(
      Uri.parse('$baseUrl/events').replace(queryParameters: queryParameters),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PaginatedResponse.fromJson(data, (json) => Event.fromJson(json));
    } else {
      throw Exception('Failed to get events: ${response.body}');
    }
  }

  Future<Event> getEventDetails(String eventId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/events/$eventId'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Event.fromJson(data['event']);
    } else {
      throw Exception('Failed to get event details: ${response.body}');
    }
  }

  Future<EventRegistration> registerForEvent({
    required String eventId,
    required String attendance,
    required bool volunteer,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/events/register'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'event_id': eventId,
        'attendance': attendance,
        'volunteer': volunteer,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return EventRegistration.fromJson(data['registration']);
    } else {
      throw Exception('Failed to register for event: ${response.body}');
    }
  }

  Future<PaginatedResponse<EventRegistration>> getMyEventRegistrations({
    int? perPage,
  }) async {
    final queryParameters = {
      if (perPage != null) 'per_page': perPage.toString(),
    };

    final response = await http.get(
      Uri.parse(
        '$baseUrl/events/my-registrations',
      ).replace(queryParameters: queryParameters),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Handle the custom response format for registrations
      final registrations = data['registrations'] as List;
      final pagination = data['pagination'] as Map<String, dynamic>;

      return PaginatedResponse<EventRegistration>(
        data: registrations
            .map((item) => EventRegistration.fromJson(item))
            .toList(),
        links: {}, // API doesn't provide links in this format
        meta: pagination, // Use pagination object as meta
      );
    } else {
      throw Exception('Failed to get event registrations: ${response.body}');
    }
  }

  // Resources
  Future<PaginatedResponse<Resource>> getResources({
    String? type,
    String? language,
    String? search,
    int? perPage,
  }) async {
    final queryParameters = {
      if (type != null) 'type': type,
      if (language != null) 'language': language,
      if (search != null) 'search': search,
      if (perPage != null) 'per_page': perPage.toString(),
    };

    final response = await http.get(
      Uri.parse('$baseUrl/resources').replace(queryParameters: queryParameters),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PaginatedResponse.fromJson(
        data,
        (json) => Resource.fromJson(json),
      );
    } else {
      throw Exception('Failed to get resources: ${response.body}');
    }
  }

  Future<Resource> getResourceDetails(String resourceId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/resources/$resourceId'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Resource.fromJson(data['resource']);
    } else {
      throw Exception('Failed to get resource details: ${response.body}');
    }
  }

  // Testimonies
  Future<PaginatedResponse<Testimony>> getTestimonies({
    String? search,
    int? perPage,
  }) async {
    final queryParameters = {
      if (search != null) 'search': search,
      if (perPage != null) 'per_page': perPage.toString(),
    };

    final response = await http.get(
      Uri.parse(
        '$baseUrl/testimonies',
      ).replace(queryParameters: queryParameters),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PaginatedResponse.fromJson(
        data,
        (json) => Testimony.fromJson(json),
      );
    } else {
      throw Exception('Failed to get testimonies: ${response.body}');
    }
  }

  Future<Testimony> submitTestimony({
    required String title,
    required String body,
    String? media,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/testimonies'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'title': title,
        'body': body,
        if (media != null) 'media': media,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Testimony.fromJson(data['testimony']);
    } else {
      throw Exception('Failed to submit testimony: ${response.body}');
    }
  }

  Future<PaginatedResponse<Testimony>> getMyTestimonies({int? perPage}) async {
    final queryParameters = {
      if (perPage != null) 'per_page': perPage.toString(),
    };

    final response = await http.get(
      Uri.parse(
        '$baseUrl/testimonies/my',
      ).replace(queryParameters: queryParameters),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PaginatedResponse.fromJson(
        data,
        (json) => Testimony.fromJson(json),
      );
    } else {
      throw Exception('Failed to get my testimonies: ${response.body}');
    }
  }

  // Donations
  Future<Donation> createDonation({
    required double amount,
    required String method,
    required String purpose,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/donate'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'amount': amount,
        'method': method,
        'purpose': purpose,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Donation.fromJson(data['donation']);
    } else {
      throw Exception('Failed to create donation: ${response.body}');
    }
  }

  Future<PaginatedResponse<Donation>> getMyDonations({
    String? status,
    int? perPage,
  }) async {
    final queryParameters = {
      if (status != null) 'status': status,
      if (perPage != null) 'per_page': perPage.toString(),
    };

    final response = await http.get(
      Uri.parse(
        '$baseUrl/donations/my',
      ).replace(queryParameters: queryParameters),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PaginatedResponse.fromJson(
        data,
        (json) => Donation.fromJson(json),
      );
    } else {
      throw Exception('Failed to get donations: ${response.body}');
    }
  }

  // Counseling
  Future<CounselingSession> bookCounselingSession({
    required String topic,
    String? scheduledAt,
    required Map<String, dynamic> intakeForm,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/counseling/book'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'topic': topic,
        if (scheduledAt != null) 'scheduled_at': scheduledAt,
        'intake_form': intakeForm,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return CounselingSession.fromJson(data['session']);
    } else {
      throw Exception('Failed to book counseling session: ${response.body}');
    }
  }

  Future<PaginatedResponse<CounselingSession>> getMyCounselingSessions({
    String? status,
    String? startDate,
    String? endDate,
    String? search,
    int? perPage,
  }) async {
    final queryParameters = {
      if (status != null) 'status': status,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (search != null) 'search': search,
      if (perPage != null) 'per_page': perPage.toString(),
    };

    final response = await http.get(
      Uri.parse(
        '$baseUrl/counseling/sessions',
      ).replace(queryParameters: queryParameters),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PaginatedResponse.fromJson(
        data,
        (json) => CounselingSession.fromJson(json),
      );
    } else {
      throw Exception('Failed to get counseling sessions: ${response.body}');
    }
  }

  // Salvation
  Future<SalvationDecision> recordSalvationDecision({
    required String type,
    String? name,
    String? email,
    String? phone,
    String? reason,
    String? testimony,
    required bool audioSent,
  }) async {
    final Map<String, dynamic> requestData = {
      'type': type,
      'audio_sent': audioSent,
    };

    if (name != null) requestData['name'] = name;
    if (email != null) requestData['email'] = email;
    if (phone != null) requestData['phone'] = phone;
    if (reason != null) requestData['reason'] = reason;
    if (testimony != null) requestData['testimony'] = testimony;

    final response = await http.post(
      Uri.parse('$baseUrl/salvation/decisions'),
      headers: await _getHeaders(),
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return SalvationDecision.fromJson(data['data']);
    } else {
      throw Exception('Failed to record salvation decision: ${response.body}');
    }
  }

  Future<PaginatedResponse<SalvationDecision>> getSalvationDecisions({
    int? perPage,
    String? startDate,
    String? endDate,
    String? search,
  }) async {
    final queryParameters = {
      if (perPage != null) 'per_page': perPage.toString(),
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (search != null) 'search': search,
    };

    final uri = Uri.parse(
      '$baseUrl/salvation/decisions',
    ).replace(queryParameters: queryParameters);

    final response = await http.get(uri, headers: await _getHeaders());

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PaginatedResponse<SalvationDecision>.fromJson(
        data,
        (item) => SalvationDecision.fromJson(item),
      );
    } else {
      throw Exception('Failed to get salvation decisions: ${response.body}');
    }
  }

  Future<List<Map<String, String>>> getSalvationTestimonies({
    int limit = 10,
    int offset = 0,
  }) async {
    final queryParameters = {
      'limit': limit.toString(),
      'offset': offset.toString(),
    };

    final uri = Uri.parse(
      '$baseUrl/salvation/testimonies',
    ).replace(queryParameters: queryParameters);

    final response = await http.get(uri, headers: await _getHeaders());

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, String>>.from(
        data['data'].map((item) => Map<String, String>.from(item)),
      );
    } else {
      throw Exception('Failed to get salvation testimonies: ${response.body}');
    }
  }

  // Notifications
  Future<PaginatedResponse<Notification>> getNotifications({
    String? status,
    int? perPage,
  }) async {
    final queryParameters = {
      if (status != null) 'status': status,
      if (perPage != null) 'per_page': perPage.toString(),
    };

    final uri = Uri.parse(
      '$baseUrl/notifications',
    ).replace(queryParameters: queryParameters);

    final response = await http.get(uri, headers: await _getHeaders());

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PaginatedResponse.fromJson(
        data,
        (json) => Notification.fromJson(json),
      );
    } else {
      await _handleAuthenticationError(response);
      throw Exception('Failed to get notifications: ${response.body}');
    }
  }

  Future<Notification> markNotificationAsRead(String notificationId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/notifications/$notificationId/read'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Notification.fromJson(data['notification']);
    } else {
      throw Exception('Failed to mark notification as read: ${response.body}');
    }
  }

  // Feedback
  Future<List<FeedbackType>> getFeedbackTypes() async {
    final response = await http.get(
      Uri.parse('$baseUrl/feedback-types'),
      headers: await _getHeaders(false),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['feedback_types'] as List)
          .map((item) => FeedbackType.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to get feedback types: ${response.body}');
    }
  }

  Future<Feedback> submitFeedback({
    required String type,
    required String subject,
    required String message,
    int? rating,
    String? contactEmail,
    Map<String, dynamic>? metadata,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/feedback'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'type': type,
        'subject': subject,
        'message': message,
        if (rating != null) 'rating': rating,
        if (contactEmail != null) 'contact_email': contactEmail,
        if (metadata != null) 'metadata': metadata,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Feedback.fromJson(data['feedback']);
    } else {
      throw Exception('Failed to submit feedback: ${response.body}');
    }
  }

  Future<PaginatedResponse<Feedback>> getMyFeedback({
    String? type,
    String? status,
    int? perPage,
  }) async {
    final queryParameters = {
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (perPage != null) 'per_page': perPage.toString(),
    };

    final response = await http.get(
      Uri.parse('$baseUrl/feedback').replace(queryParameters: queryParameters),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PaginatedResponse.fromJson(
        data,
        (json) => Feedback.fromJson(json),
      );
    } else {
      throw Exception('Failed to get feedback: ${response.body}');
    }
  }

  Future<Feedback> getSpecificFeedback(String feedbackId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/feedback/$feedbackId'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Feedback.fromJson(data['feedback']);
    } else {
      throw Exception('Failed to get specific feedback: ${response.body}');
    }
  }

  Future<FeedbackStats> getMyFeedbackStats() async {
    final response = await http.get(
      Uri.parse('$baseUrl/feedback-stats/my'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return FeedbackStats.fromJson(data['stats']);
    } else {
      throw Exception('Failed to get feedback stats: ${response.body}');
    }
  }

  // New Salvation endpoints
  Future<Map<String, dynamic>> submitLifeToChrist({
    required int age,
    required String gender,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/salvation/submit-life'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'age': age,
        'gender': gender,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      
      // If there's a prayer URL, we could optionally create a local notification
      // For now, just return the data as the backend should handle notifications
      return data;
    } else {
      throw Exception('Failed to submit life to Christ: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> resubmitLifeToChrist({
    required int age,
    required String gender,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/salvation/resubmit-life'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'age': age,
        'gender': gender,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      
      // If there's a prayer URL, we could optionally create a local notification
      // For now, just return the data as the backend should handle notifications
      return data;
    } else {
      throw Exception('Failed to rededicate life to Christ: ${response.body}');
    }
  }

  // Get salvation statistics
  Future<Map<String, dynamic>> getSalvationStats() async {
    final response = await http.get(
      Uri.parse('$baseUrl/salvation/stats'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get salvation stats: ${response.body}');
    }
  }
}

// Generic Paginated Response class
class PaginatedResponse<T> {
  final List<T> data;
  final Map<String, String?> links;
  final Map<String, dynamic> meta;

  PaginatedResponse({
    required this.data,
    required this.links,
    required this.meta,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT, {
    String key = 'data',
  }) {
    return PaginatedResponse<T>(
      data: (json[key] as List).map((item) => fromJsonT(item)).toList(),
      links: Map<String, String?>.from(json['links']),
      meta: Map<String, dynamic>.from(json['meta']),
    );
  }
}
