import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jkmg/models/event_model.dart';
import 'package:jkmg/models/registration_model.dart';
import 'package:jkmg/services/event_service.dart';

final allEventsProvider = FutureProvider<List<Event>>((ref) async {
  return EventService.fetchAllEvents();
});

final myRegistrationsProvider = FutureProvider<List<EventRegistration>>((ref) async {
  return EventService.fetchMyRegistrations();
});

final eventDetailsProvider = FutureProvider.family<Event, String>((ref, eventId) async {
  return EventService.fetchEventDetails(eventId);
});
