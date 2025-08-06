import 'package:flutter/material.dart';

class StudyList extends StatefulWidget {
  final List<Map<String, dynamic>> studies;
  final String searchQuery;
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(String) onSearchChanged;
  final Function(BuildContext, bool) onDateSelected;

  const StudyList({
    super.key,
    required this.studies,
    required this.searchQuery,
    required this.startDate,
    required this.endDate,
    required this.onSearchChanged,
    required this.onDateSelected,
  });

  @override
  State<StudyList> createState() => _StudyListState();
}

class _StudyListState extends State<StudyList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Past Studies',
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
        widget.studies.isEmpty
            ? const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'No studies found.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.studies.length,
                itemBuilder: (context, index) =>
                    _buildStudyCard(context, widget.studies[index]),
              ),
      ],
    );
  }

  Widget _buildStudyCard(BuildContext context, Map<String, dynamic> study) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: const Color(0xFFB8860B).withOpacity(0.3)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          study['topic'],
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: const Color(0xFFB8860B),
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scripture: ${study['scripture']}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black87,
                fontStyle: FontStyle.italic,
              ),
            ),
            Text(
              'Date: ${study['date']}',
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
            builder: (context) => _buildStudyDetails(context, study),
          );
        },
      ),
    );
  }

  Widget _buildStudyDetails(BuildContext context, Map<String, dynamic> study) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            study['topic'],
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color(0xFFB8860B),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Scripture: ${study['scripture']}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black87,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            study['devotional'],
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Key Points:',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: const Color(0xFFB8860B)),
          ),
          ...?study['discussion_json']['key_points']?.map<Widget>(
            (point) => Padding(
              padding: const EdgeInsets.only(left: 16, top: 4),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 8, color: Color(0xFFB8860B)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      point,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
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
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: const Color(0xFFB8860B)),
          ),
          ...?study['discussion_json']['questions']?.map<Widget>(
            (question) => Padding(
              padding: const EdgeInsets.only(left: 16, top: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.circle, size: 8, color: Color(0xFFB8860B)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      question,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
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
          title: const Text('Filter Studies'),
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
