import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jkmg/provider/api_providers.dart';
import 'package:jkmg/models/prayer.dart';

class DeeperPrayer extends StatefulWidget {
  final DeeperPrayerInfo? deeperPrayerInfo;
  final bool isLoading;
  final VoidCallback onDeeperPrayerRecorded;

  const DeeperPrayer({
    super.key,
    required this.deeperPrayerInfo,
    required this.isLoading,
    required this.onDeeperPrayerRecorded,
  });

  @override
  State<DeeperPrayer> createState() => _DeeperPrayerState();
}

class _DeeperPrayerState extends State<DeeperPrayer> {
  int? _selectedDuration;
  String _notes = '';
  bool _isSubmitting = false;
  final List<int> _availableDurations = [30, 60];

  Future<void> _recordDeeperPrayer() async {
    if (_selectedDuration == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a duration')));
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      await ProviderScope.containerOf(context).read(
        participateInDeeperPrayerProvider({
          'duration': _selectedDuration!,
          'notes': _notes.isNotEmpty ? _notes : null,
        }).future,
      );
      setState(() {
        _isSubmitting = false;
        _selectedDuration = null;
        _notes = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deeper prayer participation recorded')),
      );
      widget.onDeeperPrayerRecorded();
    } catch (e) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error recording deeper prayer: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final todayParticipation = widget.deeperPrayerInfo?.todayParticipation;
    final totalCompleted =
        widget.deeperPrayerInfo?.recentParticipations?.length ?? 0;
    final isTodayCompleted = todayParticipation?.completed == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deeper Prayer',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: const Color(0xFFB8860B),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          color: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: const Color(0xFFB8860B).withOpacity(0.3)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Sessions Completed: $totalCompleted',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black87,
                  ),
                ),
                if (todayParticipation != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Today\'s Session: ${todayParticipation.duration} minutes (Completed)',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.green),
                  ),
                ],
                if (isTodayCompleted) ...[
                  const SizedBox(height: 16),
                  Text(
                    'You have already completed today\'s deeper prayer session.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                if (!isTodayCompleted) ...[
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: 'Session Duration (minutes)',
                      labelStyle: const TextStyle(color: Color(0xFFB8860B)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFB8860B)),
                      ),
                    ),
                    value: _selectedDuration,
                    items: _availableDurations
                        .map(
                          (duration) => DropdownMenuItem(
                            value: duration,
                            child: Text('$duration minutes'),
                          ),
                        )
                        .toList(),
                    onChanged: (widget.isLoading || _isSubmitting)
                        ? null
                        : (value) => setState(() => _selectedDuration = value),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Notes (Optional)',
                      labelStyle: const TextStyle(color: Color(0xFFB8860B)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFB8860B)),
                      ),
                    ),
                    maxLines: 3,
                    onChanged: (value) => setState(() => _notes = value),
                    enabled: !(widget.isLoading || _isSubmitting),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: (widget.isLoading || _isSubmitting)
                        ? null
                        : _recordDeeperPrayer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB8860B),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          )
                        : const Text(
                            'Record Deeper Prayer',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
