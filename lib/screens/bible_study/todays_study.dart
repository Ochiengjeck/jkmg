import 'package:flutter/material.dart';
import '../../models/bible_study.dart';

class TodaysStudy extends StatelessWidget {
  final BibleStudy? study;

  const TodaysStudy({super.key, required this.study});

  @override
  Widget build(BuildContext context) {
    if (study == null) {
      return Card(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: const Color(0xFFB8860B).withOpacity(0.3)),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'No study available for today.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Study',
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
                  study!.topic,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color(0xFFB8860B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Scripture: ${study!.scripture}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black87,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  study!.excerpt,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Key Points:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFFB8860B),
                  ),
                ),
                ...?study!.discussionJson['key_points']?.map<Widget>(
                  (point) => Padding(
                    padding: const EdgeInsets.only(left: 16, top: 4),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.circle,
                          size: 8,
                          color: Color(0xFFB8860B),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            point,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white70
                                      : Colors.black87,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Discussion Questions:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFFB8860B),
                  ),
                ),
                ...?study!.discussionJson['questions']?.map<Widget>(
                  (question) => Padding(
                    padding: const EdgeInsets.only(left: 16, top: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.circle,
                          size: 8,
                          color: Color(0xFFB8860B),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            question,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white70
                                      : Colors.black87,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
