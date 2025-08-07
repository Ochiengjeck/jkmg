import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/salvation.dart';
import '../../provider/api_providers.dart';

class SalvationCornerScreen extends ConsumerStatefulWidget {
  const SalvationCornerScreen({super.key});

  @override
  ConsumerState<SalvationCornerScreen> createState() =>
      _SalvationCornerScreenState();
}

class _SalvationCornerScreenState extends ConsumerState<SalvationCornerScreen> {
  String _searchQuery = '';
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final salvationDecisionsAsync = ref.watch(
    //   salvationDecisionsProvider({
    //     'per_page': 15,
    //     'start_date': _startDate?.toIso8601String(),
    //     'end_date': _endDate?.toIso8601String(),
    //     'search': _searchQuery.isEmpty ? null : _searchQuery,
    //   }),
    // );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildSalvationForm(context),
                const SizedBox(height: 24),
                // salvationDecisionsAsync.when(
                //   data: (decisions) => SalvationDecisionList(
                //     decisions: decisions.data,
                //     searchQuery: _searchQuery,
                //     startDate: _startDate,
                //     endDate: _endDate,
                //     onSearchChanged: _onSearchChanged,
                //     onDateSelected: _selectDate,
                //   ),
                //   loading: () => const Center(child: CircularProgressIndicator()),
                //   error: (e, _) => Text('Error: $e'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Salvation Corner',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: const Color(0xFFB8860B),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Begin or renew your journey with Christ',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white70
                : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildSalvationForm(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String selectedType = 'salvation';
    bool audioSent = false;

    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: const Color(0xFFB8860B).withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Record Your Decision',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFFB8860B),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: InputDecoration(
                  labelText: 'Decision Type',
                  labelStyle: const TextStyle(color: Color(0xFFB8860B)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'salvation',
                    child: Text('Salvation'),
                  ),
                  DropdownMenuItem(
                    value: 'rededication',
                    child: Text('Rededication'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: Text(
                  'Include Audio Testimony',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black87,
                  ),
                ),
                value: audioSent,
                onChanged: (value) {
                  setState(() {
                    audioSent = value!;
                  });
                },
                activeColor: const Color(0xFFB8860B),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        await ref.read(
                          recordSalvationDecisionProvider({
                            'type': selectedType,
                            'audio_sent': audioSent,
                          }).future,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Decision recorded successfully'),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Error: $e')));
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB8860B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Submit Decision',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SalvationDecisionList extends StatefulWidget {
  final List<SalvationDecision> decisions;
  final String searchQuery;
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(String) onSearchChanged;
  final Function(BuildContext, bool) onDateSelected;

  const SalvationDecisionList({
    super.key,
    required this.decisions,
    required this.searchQuery,
    required this.startDate,
    required this.endDate,
    required this.onSearchChanged,
    required this.onDateSelected,
  });

  @override
  State<SalvationDecisionList> createState() => _SalvationDecisionListState();
}

class _SalvationDecisionListState extends State<SalvationDecisionList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Past Decisions',
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
                  labelText: 'Search by type',
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
        widget.decisions.isEmpty
            ? const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'No decisions found.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.decisions.length,
                itemBuilder: (context, index) =>
                    _buildDecisionCard(context, widget.decisions[index]),
              ),
      ],
    );
  }

  Widget _buildDecisionCard(BuildContext context, SalvationDecision decision) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: const Color(0xFFB8860B).withOpacity(0.3)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          decision.type.label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: const Color(0xFFB8860B),
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${decision.submittedAt}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black87,
              ),
            ),
            Text(
              'Audio Included: ${decision.audioSent ? 'Yes' : 'No'}',
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
            builder: (context) => _buildDecisionDetails(context, decision),
          );
        },
      ),
    );
  }

  Widget _buildDecisionDetails(
    BuildContext context,
    SalvationDecision decision,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            decision.type.label,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color(0xFFB8860B),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Date: ${decision.submittedAt}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Audio Testimony: ${decision.audioSent ? 'Included' : 'Not Included'}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black87,
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
          title: const Text('Filter Decisions'),
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
