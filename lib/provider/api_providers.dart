import 'package:flutter_riverpod/flutter_riverpod.dart';

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
import '../services/api_service.dart';
import '../services/preference_service.dart';

// Initialize ApiService
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

// User Session Provider for persistent sessions
class UserSessionNotifier extends StateNotifier<User?> {
  UserSessionNotifier() : super(null);

  Future<void> saveUserSession(User user) async {
    try {
      final prefs = await PreferenceService.getInstance();
      await prefs.saveUserSession(user);
      state = user;
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  Future<void> loadUserSession() async {
    try {
      final prefs = await PreferenceService.getInstance();
      final user = await prefs.getUserSession();
      state = user;
    } catch (e) {
      state = null;
    }
  }

  Future<void> clearUserSession() async {
    try {
      final prefs = await PreferenceService.getInstance();
      await prefs.clearUserSession();
      state = null;
    } catch (e) {
      // Handle error
    }
  }
}

final userSessionProvider = StateNotifierProvider<UserSessionNotifier, User?>((ref) {
  return UserSessionNotifier();
});

// Authentication state provider
final authStateProvider = FutureProvider<bool>((ref) async {
  try {
    final prefs = await PreferenceService.getInstance();
    return prefs.isLoggedIn;
  } catch (e) {
    return false;
  }
});

// Authentication Providers
final registerProvider = FutureProvider.family<User, Map<String, dynamic>>((
  ref,
  params,
) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.register(
    name: params['name'] as String,
    phone: params['phone'] as String,
    country: params['country'] as String,
    password: params['password'] as String,
    passwordConfirmation: params['password_confirmation'] as String,
    email: params['email'] as String?,
    timezone: params['timezone'] as String?,
    prayerTimes: (params['prayer_times'] as List<dynamic>?)?.cast<String>(),
  );
});

final loginProvider = FutureProvider.family<User, Map<String, dynamic>>((
  ref,
  params,
) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.login(
    username: params['username'] as String,
    password: params['password'] as String,
  );
});

// Forgot Password Provider
final forgotPasswordProvider = FutureProvider.family<void, Map<String, dynamic>>((
  ref,
  params,
) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.forgotPassword(
    email: params['email'] as String,
  );
});

// Send Password Reset OTP Provider
final sendPasswordResetOtpProvider = FutureProvider.family<void, Map<String, dynamic>>((
  ref,
  params,
) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.sendPasswordResetOtp(
    email: params['email'] as String,
  );
});

// Verify Password Reset OTP Provider
final verifyPasswordResetOtpProvider = FutureProvider.family<String, Map<String, dynamic>>((
  ref,
  params,
) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.verifyPasswordResetOtp(
    email: params['email'] as String,
    otp: params['otp'] as String,
  );
});

// Reset Password with Token Provider
final resetPasswordWithTokenProvider = FutureProvider.family<void, Map<String, dynamic>>((
  ref,
  params,
) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.resetPasswordWithToken(
    token: params['token'] as String,
    password: params['password'] as String,
    passwordConfirmation: params['password_confirmation'] as String,
  );
});

final logoutProvider = FutureProvider<void>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.logout();
});

// User Management Providers
final currentUserProvider = FutureProvider<User>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.getCurrentUser();
});

final updateProfileProvider = FutureProvider.family<User, Map<String, dynamic>>(
  (ref, params) async {
    final apiService = ref.read(apiServiceProvider);
    return apiService.updateProfile(
      name: params['name'] as String?,
      email: params['email'] as String?,
      country: params['country'] as String?,
      timezone: params['timezone'] as String?,
      prayerTimes: (params['prayer_times'] as List<dynamic>?)?.cast<String>(),
    );
  },
);

// Prayer System Providers
final prayerScheduleProvider = FutureProvider<PrayerSchedule>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.getPrayerSchedule();
});

final createPrayerRequestProvider =
    FutureProvider.family<PrayerRequest, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final apiService = ref.read(apiServiceProvider);
      return apiService.createPrayerRequest(
        title: params['title'] as String,
        description: params['description'] as String,
        category: params['category'] as String,
        urgency: params['urgency'] as String,
        isAnonymous: params['is_anonymous'] as bool,
        isPublic: params['is_public'] as bool,
        startDate: params['start_date'] as String,
        endDate: params['end_date'] as String,
      );
    });

final deeperPrayerInfoProvider = FutureProvider<DeeperPrayerInfo>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.getDeeperPrayerInfo();
});

final participateInDeeperPrayerProvider =
    FutureProvider.family<DeeperPrayerParticipation, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final apiService = ref.read(apiServiceProvider);
      return apiService.participateInDeeperPrayer(
        duration: params['duration'] as int,
        notes: params['notes'] as String?,
      );
    });

// Bible Study Providers
final todaysBibleStudyProvider = FutureProvider<BibleStudy>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.getTodaysBibleStudy();
});

final bibleStudiesProvider =
    FutureProvider.family<PaginatedResponse<BibleStudy>, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final apiService = ref.read(apiServiceProvider);
      return apiService.getBibleStudies(
        startDate: params['start_date'] as String?,
        endDate: params['end_date'] as String?,
        search: params['search'] as String?,
        perPage: params['per_page'] as int?,
      );
    });

// Event Providers
final eventsProvider =
    FutureProvider.family<PaginatedResponse<Event>, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final apiService = ref.read(apiServiceProvider);
      return apiService.getEvents(
        type: params['type'] as String?,
        status: params['status'] as String?,
        withLivestream: params['with_livestream'] as bool?,
        perPage: params['per_page'] as int?,
      );
    });

// Specific provider for all events (cached)
final allEventsProvider = FutureProvider<PaginatedResponse<Event>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  try {
    return await apiService.getEvents();
  } catch (e) {
    // If authentication fails, return empty response
    if (e.toString().contains('unauthenticated') || e.toString().contains('401')) {
      return PaginatedResponse<Event>(
        data: [],
        links: {},
        meta: {},
      );
    }
    rethrow;
  }
});

// Specific provider for my registrations (cached) - requires auth
final myRegistrationsProvider = FutureProvider<PaginatedResponse<EventRegistration>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  try {
    return await apiService.getMyEventRegistrations();
  } catch (e) {
    // Return empty response if user not authenticated
    return PaginatedResponse<EventRegistration>(
      data: [],
      links: {},
      meta: {},
    );
  }
});

// Provider to check if user is registered for a specific event
final isRegisteredForEventProvider = FutureProvider.family<EventRegistration?, String>((ref, eventId) async {
  try {
    final registrations = await ref.watch(myRegistrationsProvider.future);
    final registration = registrations.data.where(
      (registration) => registration.event?.id == eventId,
    ).firstOrNull;
    return registration;
  } catch (e) {
    return null;
  }
});

final eventDetailsProvider = FutureProvider.family<Event, String>((
  ref,
  eventId,
) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.getEventDetails(eventId);
});

final registerForEventProvider =
    FutureProvider.family<EventRegistration, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final apiService = ref.read(apiServiceProvider);
      return apiService.registerForEvent(
        eventId: params['event_id'] as String,
        attendance: params['attendance'] as String,
        volunteer: params['volunteer'] as bool? ?? false,
      );
    });

final myEventRegistrationsProvider =
    FutureProvider.family<
      PaginatedResponse<EventRegistration>,
      Map<String, dynamic>
    >((ref, params) async {
      final apiService = ref.read(apiServiceProvider);
      return apiService.getMyEventRegistrations(
        perPage: params['per_page'] as int?,
      );
    });

// Resource Providers
final resourcesProvider =
    FutureProvider.family<PaginatedResponse<Resource>, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final apiService = ref.read(apiServiceProvider);
      return apiService.getResources(
        type: params['type'] as String?,
        language: params['language'] as String?,
        search: params['search'] as String?,
        perPage: params['per_page'] as int?,
      );
    });

final resourceDetailsProvider = FutureProvider.family<Resource, String>((
  ref,
  resourceId,
) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.getResourceDetails(resourceId);
});

// Testimony Providers
final testimoniesProvider =
    FutureProvider.family<PaginatedResponse<Testimony>, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final apiService = ref.read(apiServiceProvider);
      return apiService.getTestimonies(
        search: params['search'] as String?,
        perPage: params['per_page'] as int?,
      );
    });

final submitTestimonyProvider =
    FutureProvider.family<Testimony, Map<String, dynamic>>((ref, params) async {
      final apiService = ref.read(apiServiceProvider);
      return apiService.submitTestimony(
        title: params['title'] as String,
        body: params['body'] as String,
        media: params['media'] as String?,
      );
    });

final myTestimoniesProvider =
    FutureProvider.family<PaginatedResponse<Testimony>, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final apiService = ref.read(apiServiceProvider);
      return apiService.getMyTestimonies(perPage: params['per_page'] as int?);
    });

// Donation Providers
final createDonationProvider =
    FutureProvider.family<Donation, Map<String, dynamic>>((ref, params) async {
      final apiService = ref.read(apiServiceProvider);
      return apiService.createDonation(
        amount: params['amount'] as double,
        method: params['method'] as String,
        purpose: params['purpose'] as String,
      );
    });

final myDonationsProvider =
    FutureProvider.family<PaginatedResponse<Donation>, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final apiService = ref.read(apiServiceProvider);
      return apiService.getMyDonations(
        status: params['status'] as String?,
        perPage: params['per_page'] as int?,
      );
    });

// Counseling Providers
final bookCounselingSessionProvider =
    FutureProvider.family<CounselingSession, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final apiService = ref.read(apiServiceProvider);
      return apiService.bookCounselingSession(
        topic: params['topic'] as String,
        scheduledAt: params['scheduled_at'] as String?,
        intakeForm: params['intake_form'] as Map<String, dynamic>,
      );
    });

final myCounselingSessionsProvider =
    FutureProvider.family<
      PaginatedResponse<CounselingSession>,
      Map<String, dynamic>
    >((ref, params) async {
      final apiService = ref.read(apiServiceProvider);
      return apiService.getMyCounselingSessions(
        status: params['status'] as String?,
        startDate: params['start_date'] as String?,
        endDate: params['end_date'] as String?,
        search: params['search'] as String?,
        perPage: params['per_page'] as int?,
      );
    });

// Salvation Provider
final recordSalvationDecisionProvider =
    FutureProvider.family<SalvationDecision, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final apiService = ref.read(apiServiceProvider);
      return apiService.recordSalvationDecision(
        type: params['type'] as String,
        name: params['name'] as String?,
        email: params['email'] as String?,
        phone: params['phone'] as String?,
        reason: params['reason'] as String?,
        testimony: params['testimony'] as String?,
        audioSent: params['audio_sent'] as bool? ?? false,
      );
    });

// Salvation decisions list provider
final salvationDecisionsProvider =
    FutureProvider.family<PaginatedResponse<SalvationDecision>, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final apiService = ref.read(apiServiceProvider);
      return apiService.getSalvationDecisions(
        perPage: params['per_page'] as int?,
        startDate: params['start_date'] as String?,
        endDate: params['end_date'] as String?,
        search: params['search'] as String?,
      );
    });

// Get testimonies for salvation corner
final salvationTestimoniesProvider = FutureProvider.family<List<Map<String, String>>, Map<String, dynamic>>((
  ref,
  params,
) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.getSalvationTestimonies(
    limit: params['limit'] as int? ?? 10,
    offset: params['offset'] as int? ?? 0,
  );
});

// Notification Providers
final notificationsProvider =
    FutureProvider.family<
      PaginatedResponse<Notification>,
      Map<String, dynamic>
    >((ref, params) async {
      final apiService = ref.read(apiServiceProvider);
      return apiService.getNotifications(
        status: params['status'] as String?,
        perPage: params['per_page'] as int?,
      );
    });

final markNotificationAsReadProvider =
    FutureProvider.family<Notification, String>((ref, notificationId) async {
      final apiService = ref.read(apiServiceProvider);
      return apiService.markNotificationAsRead(notificationId);
    });

// Feedback Providers
final feedbackTypesProvider = FutureProvider<List<FeedbackType>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.getFeedbackTypes();
});

final submitFeedbackProvider =
    FutureProvider.family<Feedback, Map<String, dynamic>>((ref, params) async {
      final apiService = ref.read(apiServiceProvider);
      return apiService.submitFeedback(
        type: params['type'] as String,
        subject: params['subject'] as String,
        message: params['message'] as String,
        rating: params['rating'] as int?,
        contactEmail: params['contact_email'] as String?,
        metadata: params['metadata'] as Map<String, dynamic>?,
      );
    });

final myFeedbackProvider =
    FutureProvider.family<PaginatedResponse<Feedback>, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final apiService = ref.read(apiServiceProvider);
      return apiService.getMyFeedback(
        type: params['type'] as String?,
        status: params['status'] as String?,
        perPage: params['per_page'] as int?,
      );
    });

final specificFeedbackProvider = FutureProvider.family<Feedback, String>((
  ref,
  feedbackId,
) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.getSpecificFeedback(feedbackId);
});

final myFeedbackStatsProvider = FutureProvider<FeedbackStats>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.getMyFeedbackStats();
});
