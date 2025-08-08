import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jkmg/models/event_model.dart';
import 'package:jkmg/models/registration_model.dart';
import 'package:jkmg/provider/event_provider.dart';
import 'package:jkmg/widgets/event_card.dart';
import 'event_detail_screen.dart';

class EventListScreen extends ConsumerStatefulWidget {
  const EventListScreen({super.key});

  @override
  ConsumerState<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends ConsumerState<EventListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.index == 0) {
      _refreshAllEvents();
    } else {
      _refreshMyRegistrations();
    }
  }

  @override
  Widget build(BuildContext context) {
    final allEventsAsync = ref.watch(allEventsProvider);
    final myRegistrationsAsync = ref.watch(myRegistrationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Events'),
            Tab(text: 'My Registrations'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEventList(allEventsAsync),
          _buildRegistrationList(myRegistrationsAsync),
        ],
      ),
    );
  }

  Future<void> _refreshAllEvents() async {
    ref.invalidate(allEventsProvider);
    await Future.delayed(Duration.zero);
  }

  Future<void> _refreshMyRegistrations() async {
    ref.invalidate(myRegistrationsProvider);
    await Future.delayed(Duration.zero);
  }

  // Handles List<Event>
  Widget _buildEventList(AsyncValue<List<Event>> eventList) {
    return eventList.when(
      data: (events) {
        if (events.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => _refreshAllEvents(),
            child: const SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: 400,
                child: Center(child: Text("No events found.")),
              ),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () => _refreshAllEvents(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return EventCard(
                event: event,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventDetailScreen(event: event),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => RefreshIndicator(
        onRefresh: () => _refreshAllEvents(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: 400,
            child: Center(child: Text('Error: $err')),
          ),
        ),
      ),
    );
  }

  // ✅ New handler for List<EventRegistration>
  Widget _buildRegistrationList(AsyncValue<List<EventRegistration>> registrationList) {
    return registrationList.when(
      data: (registrations) {

        if (registrations.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => _refreshMyRegistrations(),
            child: const SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: 400,
                child: Center(child: Text("You haven't registered for any events yet.")),
              ),
            ),
          );
        }

        // Convert registration list to event list, filtering out null events
        final events = registrations
            .where((r) => r.event != null)
            .map((r) => r.event!)
            .toList();

        if (events.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => _refreshMyRegistrations(),
            child: const SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: 400,
                child: Center(child: Text("No valid events found in your registrations.")),
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _refreshMyRegistrations(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return EventCard(
                event: event,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventDetailScreen(event: event),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => RefreshIndicator(
        onRefresh: () => _refreshMyRegistrations(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: 400,
            child: Center(child: Text('Error: $err')),
          ),
        ),
      ),
    );
  }
}
