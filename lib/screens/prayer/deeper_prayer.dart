import 'package:flutter/material.dart';

class DeeperPrayer extends StatefulWidget {
  final Map<String, dynamic>? deeperPrayerInfo;
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
  bool _isLoading = false;

  final List<int> _availableDurations = [30, 60];

  Future<void> _recordDeeperPrayer() async {
    if (_selectedDuration == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a duration')));
      return;
    }
    setState(() => _isLoading = true);
    try {
      // await ApiService.participateInDeeperPrayer(
      //   duration: _selectedDuration!,
      //   date: DateTime.now(),
      // );
      setState(() {
        _isLoading = false;
        _selectedDuration = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deeper prayer participation recorded')),
      );
      widget.onDeeperPrayerRecorded();
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error recording deeper prayer: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final todayParticipation = widget.deeperPrayerInfo?['today_participation'];
    final totalCompleted = widget.deeperPrayerInfo?['total_completed'] ?? 0;

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
            padding: const EdgeInsets.all(16),
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
                    'Today\'s Session: ${todayParticipation['duration']} minutes (Completed)',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.green),
                  ),
                ],
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'Session Duration (minutes)',
                    labelStyle: TextStyle(color: const Color(0xFFB8860B)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: const Color(0xFFB8860B)),
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
                  onChanged: (widget.isLoading || _isLoading)
                      ? null
                      : (value) {
                          setState(() {
                            _selectedDuration = value;
                          });
                        },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: (widget.isLoading || _isLoading)
                      ? null
                      : _recordDeeperPrayer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB8860B),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.black),
                        )
                      : const Text('Record Deeper Prayer'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
