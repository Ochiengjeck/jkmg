import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jkmg/models/event.dart';
import 'package:jkmg/provider/api_providers.dart';

class EventCard extends ConsumerWidget {
  final Event event;
  final VoidCallback onTap;

  const EventCard({super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formattedDate = DateFormat(
      'MMM d',
    ).format(DateTime.parse(event.startDate)); // e.g., Aug 6
    final registrationAsync = ref.watch(isRegisteredForEventProvider(event.id));

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        title: Text(
          event.displayTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.displayDescription,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      event.displayLocation,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        trailing: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 60,
          ), // Adjust based on your needs
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              registrationAsync.when(
                data: (registration) => Icon(
                  registration != null ? Icons.check_circle : Icons.event,
                  size: 18,
                  color: registration != null ? Colors.green : Colors.blueGrey,
                ),
                loading: () =>
                    const Icon(Icons.event, size: 18, color: Colors.blueGrey),
                error: (_, __) =>
                    const Icon(Icons.event, size: 18, color: Colors.blueGrey),
              ),
              Text(
                formattedDate,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
              registrationAsync.when(
                data: (registration) => registration != null
                    ? const Text(
                        'Registered',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
