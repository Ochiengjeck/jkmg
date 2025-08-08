import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/counseling.dart';
import '../../provider/api_providers.dart';
import 'book_counseling.dart';
import 'counseling_list.dart';

class CounselingCornerScreen extends ConsumerStatefulWidget {
  const CounselingCornerScreen({super.key});

  @override
  ConsumerState<CounselingCornerScreen> createState() =>
      _CounselingCornerScreenState();
}

class _CounselingCornerScreenState
    extends ConsumerState<CounselingCornerScreen> {
  String _searchQuery = '';
  DateTime? _startDate;
  DateTime? _endDate;

  // Direct state management
  bool _isLoading = true;
  List<CounselingSession> _sessions = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    print('🔄 Starting to load sessions directly...');
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final apiService = ref.read(apiServiceProvider);
      final result = await apiService.getMyCounselingSessions(
        status: null,
        startDate: _startDate?.toIso8601String(),
        endDate: _endDate?.toIso8601String(),
        search: _searchQuery.isEmpty ? null : _searchQuery,
        perPage: 15,
      );

      print('✅ Sessions loaded directly: ${result.data.length}');

      if (mounted) {
        setState(() {
          _sessions = result.data;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error loading sessions directly: $e');
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _loadSessions(); // Reload with new search
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
      _loadSessions(); // Reload with new date filter
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              BookCounselingForm(),
              const SizedBox(height: 24),
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFFB8860B)),
            SizedBox(height: 16),
            Text(
              'Loading your counseling sessions...',
              style: TextStyle(color: Color(0xFFB8860B), fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading sessions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadSessions,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB8860B),
              ),
              child: const Text('Retry', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      );
    }

    // Show the sessions list
    return RefreshIndicator(
      onRefresh: _loadSessions,
      child: CounselingList(
        sessions: _sessions,
        searchQuery: _searchQuery,
        startDate: _startDate,
        endDate: _endDate,
        onSearchChanged: _onSearchChanged,
        onDateSelected: _selectDate,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Seek guidance and support through our counseling services',
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
