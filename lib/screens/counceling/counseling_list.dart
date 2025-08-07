import 'package:flutter/material.dart';
import '../../models/counseling.dart';

class CounselingList extends StatefulWidget {
  final List<CounselingSession> sessions;
  final String searchQuery;
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(String) onSearchChanged;
  final Function(BuildContext, bool) onDateSelected;

  const CounselingList({
    super.key,
    required this.sessions,
    required this.searchQuery,
    required this.startDate,
    required this.endDate,
    required this.onSearchChanged,
    required this.onDateSelected,
  });

  @override
  State<CounselingList> createState() => _CounselingListState();
}

class _CounselingListState extends State<CounselingList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Past Sessions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: const Color(0xFFB8860B),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search by topic',
                  labelStyle: const TextStyle(color: Color(0xFFB8860B)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFB8860B)),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFFB8860B),
                  ),
                ),
                onChanged: widget.onSearchChanged,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.filter_list, color: Color(0xFFB8860B)),
              onPressed: () => _showFilterDialog(context),
            ),
          ],
        ),
        const SizedBox(height: 16),
        widget.sessions.isEmpty
            ? const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'No sessions found.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.sessions.length,
                itemBuilder: (context, index) =>
                    _buildSessionCard(context, widget.sessions[index]),
              ),
      ],
    );
  }

  Widget _buildSessionCard(BuildContext context, CounselingSession session) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: const Color(0xFFB8860B).withOpacity(0.3)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          session.topic,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: const Color(0xFFB8860B),
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status: ${session.status.label}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black87,
              ),
            ),
            if (session.scheduledAt != null)
              Text(
                'Scheduled: ${session.scheduledAt}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.black87,
                ),
              ),
            if (session.counselor != null)
              Text(
                'Counselor: ${session.counselor!.name}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.black87,
                ),
              ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFFB8860B)),
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => _buildSessionDetails(context, session),
          );
        },
      ),
    );
  }

  Widget _buildSessionDetails(BuildContext context, CounselingSession session) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            session.topic,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color(0xFFB8860B),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Status: ${session.status.label}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black87,
            ),
          ),
          if (session.scheduledAt != null) ...[
            const SizedBox(height: 8),
            Text(
              'Scheduled: ${session.scheduledAt}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black87,
              ),
            ),
          ],
          if (session.counselor != null) ...[
            const SizedBox(height: 8),
            Text(
              'Counselor: ${session.counselor!.name}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black87,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Text(
            'Intake Form Details:',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: const Color(0xFFB8860B)),
          ),
          const SizedBox(height: 8),
          if (session.intakeForm['issue_description'] != null)
            Text(
              'Issue Description: ${session.intakeForm['issue_description']}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black87,
              ),
            ),
          if (session.intakeForm['urgency_level'] != null) ...[
            const SizedBox(height: 8),
            Text(
              'Urgency Level: ${session.intakeForm['urgency_level']}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black87,
              ),
            ),
          ],
          if (session.intakeForm['preferred_counselor'] != null) ...[
            const SizedBox(height: 8),
            Text(
              'Preferred Counselor: ${session.intakeForm['preferred_counselor']}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black87,
              ),
            ),
          ],
          if (session.intakeForm['goal'] != null) ...[
            const SizedBox(height: 8),
            Text(
              'Goal: ${session.intakeForm['goal']}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black87,
              ),
            ),
          ],
          if (session.intakeForm['primary_concern'] != null) ...[
            const SizedBox(height: 8),
            Text(
              'Primary Concern: ${session.intakeForm['primary_concern']}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black87,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Close',
                style: TextStyle(color: Color(0xFFB8860B)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Sessions'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Start Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                readOnly: true,
                controller: TextEditingController(
                  text: widget.startDate != null
                      ? '${widget.startDate!.year}-${widget.startDate!.month.toString().padLeft(2, '0')}-${widget.startDate!.day.toString().padLeft(2, '0')}'
                      : '',
                ),
                onTap: () => widget.onDateSelected(context, true),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'End Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                readOnly: true,
                controller: TextEditingController(
                  text: widget.endDate != null
                      ? '${widget.endDate!.year}-${widget.endDate!.month.toString().padLeft(2, '0')}-${widget.endDate!.day.toString().padLeft(2, '0')}'
                      : '',
                ),
                onTap: () => widget.onDateSelected(context, false),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                widget.onDateSelected(context, true);
                widget.onDateSelected(context, false);
                Navigator.pop(context);
              },
              child: const Text('Clear Filters'),
            ),
          ],
        );
      },
    );
  }
}
