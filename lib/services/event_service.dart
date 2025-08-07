import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jkmg/models/event_model.dart';
import 'package:jkmg/models/registration_model.dart';
import 'package:jkmg/utils/token_helper.dart';

class EventService {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'https://jkmg.laravel.cloud/api';

  static Future<Map<String, String>> _headers() async {
    return await TokenHelper.getAuthHeaders();
  }

  static Future<List<Event>> fetchAllEvents() async {
    final response = await http.get(
      Uri.parse('$baseUrl/events'),
      headers: await _headers(),
    );

    final data = jsonDecode(response.body)['data'] as List;
    return data.map((e) => Event.fromJson(e)).toList();
  }

  static Future<List<EventRegistration>> fetchMyRegistrations() async {
    final response = await http.get(
      Uri.parse('$baseUrl/events/my-registrations'),
      headers: await _headers(),
    );

    final data = jsonDecode(response.body)['registrations'] as List;
    return data.map((e) => EventRegistration.fromJson(e)).toList();
  }

  static Future<Event> fetchEventDetails(String eventId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/events/$eventId'),
      headers: await _headers(),
    );

    final data = jsonDecode(response.body)['event'];
    return Event.fromJson(data);
  }

  static Future<String> registerForEvent({
    required String eventId,
    required bool volunteer,
    required String emergencyContact,
    required String specialRequirements,
    required String attendance,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/events/register'),
      headers: await _headers(),
      body: jsonEncode({
        'event_id': eventId,
        'volunteer': volunteer,
        'emergency_contact': emergencyContact,
        'special_requirements': specialRequirements,
        'attendance': attendance,
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return data['message'] ?? 'Registration successful';
    } else {
      throw Exception(data['message'] ?? 'Registration failed');
    }
  }

}
