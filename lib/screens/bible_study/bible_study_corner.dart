import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  bool _isLoading = false;
  Map<String, dynamic>? _todaysStudy;
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
    // _fetchStudyData();
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
      // _fetchStudyData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 24),
                      TodaysStudy(study: _todaysStudy),
                      const SizedBox(height: 24),
                      StudyList(
                        studies: _studies,
                        searchQuery: _searchQuery,
                        startDate: _startDate,
                        endDate: _endDate,
                        onSearchChanged: _onSearchChanged,
                        onDateSelected: _selectDate,
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
