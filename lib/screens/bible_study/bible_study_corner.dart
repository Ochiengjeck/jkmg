import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jkmg/provider/api_providers.dart';

import '../../models/bible_study.dart';
import 'study_list.dart';
import 'todays_study.dart';

class BibleStudyCornerScreen extends ConsumerStatefulWidget {
  const BibleStudyCornerScreen({super.key});

  @override
  ConsumerState<BibleStudyCornerScreen> createState() =>
      _BibleStudyCornerScreenState();
}

class _BibleStudyCornerScreenState
    extends ConsumerState<BibleStudyCornerScreen> {
  List<Map<String, dynamic>> _studies = [];
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
    final todayStudyAsync = ref.watch(todaysBibleStudyProvider).value;
    final studiesAsync = ref.watch(
      bibleStudiesProvider(const {
        'per_page': 15,
        'start_date': null,
        'end_date': null,
        'search': null,
      }),
    );

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
                TodaysStudy(study: todayStudyAsync),
                const SizedBox(height: 24),

                studiesAsync.when(
                  data: (paststudies) => StudyList(
                    studies: paststudies.data,
                    searchQuery: _searchQuery,
                    startDate: _startDate,
                    endDate: _endDate,
                    onSearchChanged: _onSearchChanged,
                    onDateSelected: _selectDate,
                  ),
                  // Column(
                  //   children: studies.data
                  //       .map((study) => ListTile(title: Text(study.topic)))
                  //       .toList(),
                  // ),
                  loading: () => CircularProgressIndicator(),
                  error: (e, _) => Text('Error: $e'),
                ),
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
          'Bible Study Corner',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: const Color(0xFFB8860B),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Grow in faith through God\'s Word',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white70
                : Colors.black87,
          ),
        ),
      ],
    );
  }
}
