// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// import 'provider/api_providers.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await dotenv.load(fileName: ".env");
//   runApp(ProviderScope(child: JKMGApp()));
// }

// class JKMGApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'JKMG Spiritual Ministry',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends ConsumerStatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends ConsumerState<HomeScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 11, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('JKMG Ministry App'),
//         bottom: TabBar(
//           controller: _tabController,
//           isScrollable: true,
//           tabs: [
//             Tab(text: 'Auth'),
//             Tab(text: 'User'),
//             Tab(text: 'Prayer'),
//             Tab(text: 'Bible'),
//             Tab(text: 'Events'),
//             Tab(text: 'Resources'),
//             Tab(text: 'Testimonies'),
//             Tab(text: 'Donations'),
//             Tab(text: 'Counseling'),
//             Tab(text: 'Salvation'),
//             Tab(text: 'Feedback'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           AuthTab(),
//           UserTab(),
//           PrayerTab(),
//           BibleStudyTab(),
//           EventsTab(),
//           ResourcesTab(),
//           TestimoniesTab(),
//           DonationsTab(),
//           CounselingTab(),
//           SalvationTab(),
//           FeedbackTab(),
//         ],
//       ),
//     );
//   }
// }

// // Authentication Tab
// class AuthTab extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Register', style: Theme.of(context).textTheme.bodyLarge),
//           ElevatedButton(
//             onPressed: () async {
//               final params = {
//                 'name': 'John Doe',
//                 'phone': '+1234567890',
//                 'country': 'Kenya',
//                 'password': 'password123',
//                 'password_confirmation': 'password123',
//                 'email': 'john@example.com',
//                 'timezone': 'Africa/Nairobi',
//                 'prayer_times': ['06:00', '12:00', '18:00'],
//               };
//               try {
//                 final user = await ref.read(registerProvider(params).future);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Registered: ${user.name}')),
//                 );
//               } catch (e) {
//                 ScaffoldMessenger.of(
//                   context,
//                 ).showSnackBar(SnackBar(content: Text('Error: $e')));
//               }
//             },
//             child: Text('Register User'),
//           ),
//           SizedBox(height: 16),
//           Text('Login', style: Theme.of(context).textTheme.bodyLarge),
//           ElevatedButton(
//             onPressed: () async {
//               final params = {
//                 'phone': '+254768061759',
//                 'password': 'password123',
//               };
//               try {
//                 final user = await ref.read(loginProvider(params).future);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Logged in: ${user.name}')),
//                 );
//               } catch (e) {
//                 ScaffoldMessenger.of(
//                   context,
//                 ).showSnackBar(SnackBar(content: Text('Error: $e')));
//               }
//             },
//             child: Text('Login'),
//           ),
//           SizedBox(height: 16),
//           Text('Logout', style: Theme.of(context).textTheme.bodyLarge),
//           ElevatedButton(
//             onPressed: () async {
//               try {
//                 await ref.read(logoutProvider.future);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Logged out successfully')),
//                 );
//               } catch (e) {
//                 ScaffoldMessenger.of(
//                   context,
//                 ).showSnackBar(SnackBar(content: Text('Error: $e')));
//               }
//             },
//             child: Text('Logout'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // User Management Tab
// class UserTab extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final userAsync = ref.watch(currentUserProvider);
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Current User', style: Theme.of(context).textTheme.bodyLarge),
//           userAsync.when(
//             data: (user) =>
//                 Text('Name: ${user.name}\nEmail: ${user.email ?? 'N/A'}'),
//             loading: () => CircularProgressIndicator(),
//             error: (e, _) => Text('Error: $e'),
//           ),
//           SizedBox(height: 16),
//           Text('Update Profile', style: Theme.of(context).textTheme.bodyLarge),
//           ElevatedButton(
//             onPressed: () async {
//               final params = {
//                 'name': 'John Smith',
//                 'email': 'john.smith@example.com',
//                 'country': 'Kenya',
//                 'timezone': 'Africa/Nairobi',
//                 'prayer_times': ['05:30', '12:00', '18:30'],
//               };
//               try {
//                 final user = await ref.read(
//                   updateProfileProvider(params).future,
//                 );
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Profile updated: ${user.name}')),
//                 );
//               } catch (e) {
//                 ScaffoldMessenger.of(
//                   context,
//                 ).showSnackBar(SnackBar(content: Text('Error: $e')));
//               }
//             },
//             child: Text('Update Profile'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Prayer System Tab
// class PrayerTab extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final scheduleAsync = ref.watch(prayerScheduleProvider);
//     final deeperInfoAsync = ref.watch(deeperPrayerInfoProvider);
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Prayer Schedule', style: Theme.of(context).textTheme.bodyLarge),
//           scheduleAsync.when(
//             data: (schedule) =>
//                 Text('Prayer Times: ${schedule.prayerTimes.join(", ")}'),
//             loading: () => CircularProgressIndicator(),
//             error: (e, _) => Text('Error: $e'),
//           ),
//           SizedBox(height: 16),
//           Text(
//             'Create Prayer Request',
//             style: Theme.of(context).textTheme.bodyLarge,
//           ),
//           // ElevatedButton(
//           //   onPressed: () async {
//           //     final params = {
//           //       'category': 'healing',
//           //       'start_date': '2025-08-05',
//           //       'end_date': '2025-08-19',
//           //     };
//           //     try {
//           //       final prayer = await ref.read(
//           //         createPrayerRequestProvider(params).future,
//           //       );
//           //       ScaffoldMessenger.of(context).showSnackBar(
//           //         SnackBar(
//           //           content: Text('Prayer created: ${prayer.category.label}'),
//           //         ),
//           //       );
//           //     } catch (e) {
//           //       ScaffoldMessenger.of(
//           //         context,
//           //       ).showSnackBar(SnackBar(content: Text('Error: $e')));
//           //     }
//           //   },
//           //   child: Text('Create Prayer Request'),
//           // ),
//           SizedBox(height: 16),
//           Text(
//             'Deeper Prayer Info',
//             style: Theme.of(context).textTheme.bodyLarge,
//           ),
//           deeperInfoAsync.when(
//             data: (info) => Text('Total Completed: ${info.totalCompleted}'),
//             loading: () => CircularProgressIndicator(),
//             error: (e, _) => Text('Error: $e'),
//           ),
//           SizedBox(height: 16),
//           Text(
//             'Participate in Deeper Prayer',
//             style: Theme.of(context).textTheme.bodyLarge,
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final params = {'duration': 60, 'date': '2025-08-05'};
//               try {
//                 final participation = await ref.read(
//                   participateInDeeperPrayerProvider(params).future,
//                 );
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text(
//                       'Participated: ${participation.duration} minutes',
//                     ),
//                   ),
//                 );
//               } catch (e) {
//                 ScaffoldMessenger.of(
//                   context,
//                 ).showSnackBar(SnackBar(content: Text('Error: $e')));
//               }
//             },
//             child: Text('Record Participation'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Bible Study Tab
// class BibleStudyTab extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final todayStudyAsync = ref.watch(todaysBibleStudyProvider);
//     final studiesAsync = ref.watch(bibleStudiesProvider({'per_page': 15}));
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Today\'s Bible Study',
//             style: Theme.of(context).textTheme.bodyLarge,
//           ),
//           todayStudyAsync.when(
//             data: (study) => Text('Topic: ${study.topic}'),
//             loading: () => CircularProgressIndicator(),
//             error: (e, _) => Text('Error: $e'),
//           ),
//           SizedBox(height: 16),
//           Text('Bible Studies', style: Theme.of(context).textTheme.bodyLarge),
//           studiesAsync.when(
//             data: (studies) => Column(
//               children: studies.data
//                   .map((study) => ListTile(title: Text(study.topic)))
//                   .toList(),
//             ),
//             loading: () => CircularProgressIndicator(),
//             error: (e, _) => Text('Error: $e'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Events Tab
// class EventsTab extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final eventsAsync = ref.watch(eventsProvider({'per_page': 15}));
//     final eventDetailsAsync = ref.watch(
//       eventDetailsProvider('uuid-123-456-789'),
//     );
//     final registrationsAsync = ref.watch(
//       myEventRegistrationsProvider({'per_page': 15}),
//     );
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Events', style: Theme.of(context).textTheme.bodyLarge),
//           eventsAsync.when(
//             data: (events) => Column(
//               children: events.data
//                   .map((event) => ListTile(title: Text(event.title)))
//                   .toList(),
//             ),
//             loading: () => CircularProgressIndicator(),
//             error: (e, _) => Text('Error: $e'),
//           ),
//           SizedBox(height: 16),
//           Text('Event Details', style: Theme.of(context).textTheme.bodyLarge),
//           eventDetailsAsync.when(
//             data: (event) => Text('Event: ${event.title}'),
//             loading: () => CircularProgressIndicator(),
//             error: (e, _) => Text('Error: $e'),
//           ),
//           SizedBox(height: 16),
//           Text(
//             'Register for Event',
//             style: Theme.of(context).textTheme.bodyLarge,
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final params = {
//                 'event_id': 'uuid-123-456-789',
//                 'attendance': 'physical',
//                 'volunteer': true,
//               };
//               try {
//                 final registration = await ref.read(
//                   registerForEventProvider(params).future,
//                 );
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text(
//                       'Registered for: ${registration.event.title}',
//                     ),
//                   ),
//                 );
//               } catch (e) {
//                 ScaffoldMessenger.of(
//                   context,
//                 ).showSnackBar(SnackBar(content: Text('Error: $e')));
//               }
//             },
//             child: Text('Register for Event'),
//           ),
//           SizedBox(height: 16),
//           Text(
//             'My Event Registrations',
//             style: Theme.of(context).textTheme.bodyLarge,
//           ),
//           registrationsAsync.when(
//             data: (registrations) => Column(
//               children: registrations.data
//                   .map((reg) => ListTile(title: Text(reg.event.title)))
//                   .toList(),
//             ),
//             loading: () => CircularProgressIndicator(),
//             error: (e, _) => Text('Error: $e'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Resources Tab
// class ResourcesTab extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final resourcesAsync = ref.watch(resourcesProvider({'per_page': 15}));
//     final resourceDetailsAsync = ref.watch(resourceDetailsProvider('1'));
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Resources', style: Theme.of(context).textTheme.bodyLarge),
//           resourcesAsync.when(
//             data: (resources) => Column(
//               children: resources.data
//                   .map((resource) => ListTile(title: Text(resource.title)))
//                   .toList(),
//             ),
//             loading: () => CircularProgressIndicator(),
//             error: (e, _) => Text('Error: $e'),
//           ),
//           SizedBox(height: 16),
//           Text(
//             'Resource Details',
//             style: Theme.of(context).textTheme.bodyLarge,
//           ),
//           resourceDetailsAsync.when(
//             data: (resource) => Text('Resource: ${resource.title}'),
//             loading: () => CircularProgressIndicator(),
//             error: (e, _) => Text('Error: $e'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Testimonies Tab
// class TestimoniesTab extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final testimoniesAsync = ref.watch(testimoniesProvider({'per_page': 15}));
//     final myTestimoniesAsync = ref.watch(
//       myTestimoniesProvider({'per_page': 15}),
//     );
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Testimonies', style: Theme.of(context).textTheme.bodyLarge),
//           testimoniesAsync.when(
//             data: (testimonies) => Column(
//               children: testimonies.data
//                   .map((testimony) => ListTile(title: Text(testimony.title)))
//                   .toList(),
//             ),
//             loading: () => CircularProgressIndicator(),
//             error: (e, _) => Text('Error: $e'),
//           ),
//           SizedBox(height: 16),
//           Text(
//             'Submit Testimony',
//             style: Theme.of(context).textTheme.bodyLarge,
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final params = {
//                 'title': 'God\'s Provision',
//                 'body': 'I want to share how God provided for my family...',
//                 'media': null,
//               };
//               try {
//                 final testimony = await ref.read(
//                   submitTestimonyProvider(params).future,
//                 );
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('Testimony submitted: ${testimony.title}'),
//                   ),
//                 );
//               } catch (e) {
//                 ScaffoldMessenger.of(
//                   context,
//                 ).showSnackBar(SnackBar(content: Text('Error: $e')));
//               }
//             },
//             child: Text('Submit Testimony'),
//           ),
//           SizedBox(height: 16),
//           Text('My Testimonies', style: Theme.of(context).textTheme.bodyLarge),
//           myTestimoniesAsync.when(
//             data: (testimonies) => Column(
//               children: testimonies.data
//                   .map((testimony) => ListTile(title: Text(testimony.title)))
//                   .toList(),
//             ),
//             loading: () => CircularProgressIndicator(),
//             error: (e, _) => Text('Error: $e'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Donations Tab
// class DonationsTab extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final donationsAsync = ref.watch(myDonationsProvider({'per_page': 15}));
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Create Donation', style: Theme.of(context).textTheme.bodyLarge),
//           ElevatedButton(
//             onPressed: () async {
//               final params = {
//                 'amount': 1000.0,
//                 'method': 'mpesa',
//                 'purpose': 'Church Building Fund',
//               };
//               try {
//                 final donation = await ref.read(
//                   createDonationProvider(params).future,
//                 );
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('Donation created: ${donation.purpose}'),
//                   ),
//                 );
//               } catch (e) {
//                 ScaffoldMessenger.of(
//                   context,
//                 ).showSnackBar(SnackBar(content: Text('Error: $e')));
//               }
//             },
//             child: Text('Create Donation'),
//           ),
//           SizedBox(height: 16),
//           Text('My Donations', style: Theme.of(context).textTheme.bodyLarge),
//           donationsAsync.when(
//             data: (donations) => Column(
//               children: donations.data
//                   .map((donation) => ListTile(title: Text(donation.purpose)))
//                   .toList(),
//             ),
//             loading: () => CircularProgressIndicator(),
//             error: (e, _) => Text('Error: $e'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Counseling Tab
// class CounselingTab extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final sessionsAsync = ref.watch(
//       myCounselingSessionsProvider({'per_page': 15}),
//     );
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Book Counseling Session',
//             style: Theme.of(context).textTheme.bodyLarge,
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final params = {
//                 'topic': 'Marriage Guidance',
//                 'intake_form': {
//                   'preferred_time': 'Morning',
//                   'urgency': 'medium',
//                   'previous_counseling': false,
//                   'specific_concerns': 'Communication issues with spouse',
//                   'preferred_counselor_gender': 'any',
//                 },
//               };
//               try {
//                 final session = await ref.read(
//                   bookCounselingSessionProvider(params).future,
//                 );
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Session booked: ${session.topic}')),
//                 );
//               } catch (e) {
//                 ScaffoldMessenger.of(
//                   context,
//                 ).showSnackBar(SnackBar(content: Text('Error: $e')));
//               }
//             },
//             child: Text('Book Session'),
//           ),
//           SizedBox(height: 16),
//           Text(
//             'My Counseling Sessions',
//             style: Theme.of(context).textTheme.bodyLarge,
//           ),
//           sessionsAsync.when(
//             data: (sessions) => Column(
//               children: sessions.data
//                   .map((session) => ListTile(title: Text(session.topic)))
//                   .toList(),
//             ),
//             loading: () => CircularProgressIndicator(),
//             error: (e, _) => Text('Error: $e'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Salvation Tab
// class SalvationTab extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Record Salvation Decision',
//             style: Theme.of(context).textTheme.bodyLarge,
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final params = {'type': 'salvation', 'audio_sent': false};
//               try {
//                 final decision = await ref.read(
//                   recordSalvationDecisionProvider(params).future,
//                 );
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('Decision recorded: ${decision.type.label}'),
//                   ),
//                 );
//               } catch (e) {
//                 ScaffoldMessenger.of(
//                   context,
//                 ).showSnackBar(SnackBar(content: Text('Error: $e')));
//               }
//             },
//             child: Text('Record Salvation'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Feedback Tab
// class FeedbackTab extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final feedbackTypesAsync = ref.watch(feedbackTypesProvider);
//     final feedbackAsync = ref.watch(myFeedbackProvider({'per_page': 15}));
//     final feedbackStatsAsync = ref.watch(myFeedbackStatsProvider);
//     final specificFeedbackAsync = ref.watch(specificFeedbackProvider('1'));
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Feedback Types', style: Theme.of(context).textTheme.bodyLarge),
//           feedbackTypesAsync.when(
//             data: (types) => Column(
//               children: types
//                   .map((type) => ListTile(title: Text(type.label)))
//                   .toList(),
//             ),
//             loading: () => CircularProgressIndicator(),
//             error: (e, _) => Text('Error: $e'),
//           ),
//           SizedBox(height: 16),
//           Text('Submit Feedback', style: Theme.of(context).textTheme.bodyLarge),
//           ElevatedButton(
//             onPressed: () async {
//               final params = {
//                 'type': 'feature_request',
//                 'subject': 'Add Dark Mode',
//                 'message':
//                     'Please add a dark mode option for better usage during evening prayers',
//                 'rating': null,
//                 'contact_email': 'user@example.com',
//                 'metadata': {
//                   'device_info': 'iPhone 13 Pro',
//                   'app_version': '1.2.3',
//                   'platform': 'ios',
//                   'screen': 'Settings',
//                 },
//               };
//               try {
//                 final feedback = await ref.read(
//                   submitFeedbackProvider(params).future,
//                 );
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('Feedback submitted: ${feedback.subject}'),
//                   ),
//                 );
//               } catch (e) {
//                 ScaffoldMessenger.of(
//                   context,
//                 ).showSnackBar(SnackBar(content: Text('Error: $e')));
//               }
//             },
//             child: Text('Submit Feedback'),
//           ),
//           SizedBox(height: 16),
//           Text('My Feedback', style: Theme.of(context).textTheme.bodyLarge),
//           feedbackAsync.when(
//             data: (feedbacks) => Column(
//               children: feedbacks.data
//                   .map((feedback) => ListTile(title: Text(feedback.subject)))
//                   .toList(),
//             ),
//             loading: () => CircularProgressIndicator(),
//             error: (e, _) => Text('Error: $e'),
//           ),
//           SizedBox(height: 16),
//           Text(
//             'Specific Feedback',
//             style: Theme.of(context).textTheme.bodyLarge,
//           ),
//           specificFeedbackAsync.when(
//             data: (feedback) => Text('Feedback: ${feedback.subject}'),
//             loading: () => CircularProgressIndicator(),
//             error: (e, _) => Text('Error: $e'),
//           ),
//           SizedBox(height: 16),
//           Text('Feedback Stats', style: Theme.of(context).textTheme.bodyLarge),
//           feedbackStatsAsync.when(
//             data: (stats) => Text('Total Feedback: ${stats.totalFeedback}'),
//             loading: () => CircularProgressIndicator(),
//             error: (e, _) => Text('Error: $e'),
//           ),
//         ],
//       ),
//     );
//   }
// }
