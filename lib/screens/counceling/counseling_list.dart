import 'package:flutter/material.dart';
import '../../models/counseling.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

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

class _CounselingListState extends State<CounselingList>
    with TickerProviderStateMixin {
  late AnimationController _listController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _listController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _listController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _listController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedListItem(Widget child, int index) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, 0.05 + (index * 0.01)),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _listController,
          curve: Interval(index * 0.08, 1.0, curve: Curves.easeOutCubic),
        ),
      ),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _fadeController,
            curve: Interval(index * 0.04, 1.0),
          ),
        ),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_listController, _fadeController]),
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAnimatedListItem(_buildSessionsHeader(), 0),
              const SizedBox(height: 16),
              _buildAnimatedListItem(_buildSearchAndFilter(), 1),
              const SizedBox(height: 16),
              widget.sessions.isEmpty
                  ? _buildAnimatedListItem(_buildEmptyState(), 2)
                  : Column(
                      children: widget.sessions.asMap().entries.map((entry) {
                        int index = entry.key;
                        CounselingSession session = entry.value;
                        return _buildAnimatedListItem(
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildSessionCard(context, session),
                          ),
                          index + 2,
                        );
                      }).toList(),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSessionsHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryGold.withOpacity(0.08),
            AppTheme.primaryGold.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryGold.withOpacity(0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryGold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.history_outlined,
              color: AppTheme.primaryGold,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Session History',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.primaryGold,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          if (widget.sessions.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppTheme.primaryGold.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryGold.withOpacity(0.25),
                ),
              ),
              child: Text(
                '${widget.sessions.length}',
                style: const TextStyle(
                  color: AppTheme.primaryGold,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return CustomCard(
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white.withOpacity(0.03),
              ),
              child: TextField(
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  labelText: 'Search sessions',
                  labelStyle: TextStyle(
                    color: AppTheme.primaryGold.withOpacity(0.7),
                    fontSize: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppTheme.primaryGold.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppTheme.primaryGold,
                      width: 1.5,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.search_outlined,
                    color: AppTheme.primaryGold.withOpacity(0.6),
                    size: 18,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                onChanged: widget.onSearchChanged,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryGold.withOpacity(0.15),
                  AppTheme.primaryGold.withOpacity(0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryGold.withOpacity(0.25),
              ),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.tune_outlined,
                color: AppTheme.primaryGold,
                size: 18,
              ),
              onPressed: () => _showFilterDialog(context),
              tooltip: 'Filter by date',
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return CustomCard(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryGold.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.psychology_outlined,
              size: 28,
              color: AppTheme.primaryGold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'No Sessions Yet',
            style: TextStyle(
              color: AppTheme.primaryGold,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your counseling sessions will appear here once you book your first appointment.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'scheduled':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return AppTheme.primaryGold;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle_outline;
      case 'scheduled':
        return Icons.schedule_outlined;
      case 'pending':
        return Icons.hourglass_empty_outlined;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.psychology_outlined;
    }
  }

  Widget _buildSessionCard(BuildContext context, CounselingSession session) {
    return CustomCard(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) => _buildSessionDetails(context, session),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getStatusColor(session.status.label).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _getStatusColor(session.status.label).withOpacity(0.25),
                        ),
                      ),
                      child: Icon(
                        _getStatusIcon(session.status.label),
                        color: _getStatusColor(session.status.label),
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session.topic,
                            style: const TextStyle(
                              color: AppTheme.primaryGold,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(session.status.label).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _getStatusColor(session.status.label).withOpacity(0.2),
                              ),
                            ),
                            child: Text(
                              session.status.label.toUpperCase(),
                              style: TextStyle(
                                color: _getStatusColor(session.status.label),
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppTheme.primaryGold.withOpacity(0.4),
                      size: 14,
                    ),
                  ],
                ),
                if (session.scheduledAt != null || session.counselor != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (session.scheduledAt != null) ...[ 
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.schedule_outlined,
                                color: Colors.grey.shade600,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '${session.scheduledAt}',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 11,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (session.counselor != null) ...[
                        if (session.scheduledAt != null)
                          const SizedBox(width: 12),
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                color: Colors.grey.shade600,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  session.counselor!.name,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 11,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSessionDetails(BuildContext context, CounselingSession session) {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppTheme.charcoalBlack, AppTheme.richBlack],
        ),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 30,
                      height: 3,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGold.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _getStatusColor(session.status.label).withOpacity(0.2),
                              _getStatusColor(session.status.label).withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getStatusColor(session.status.label).withOpacity(0.3),
                          ),
                        ),
                        child: Icon(
                          _getStatusIcon(session.status.label),
                          color: _getStatusColor(session.status.label),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              session.topic,
                              style: const TextStyle(
                                color: AppTheme.primaryGold,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(session.status.label).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: _getStatusColor(session.status.label).withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                session.status.label.toUpperCase(),
                                style: TextStyle(
                                  color: _getStatusColor(session.status.label),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (session.scheduledAt != null || session.counselor != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.03),
                            Colors.white.withOpacity(0.01),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.primaryGold.withOpacity(0.15),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Session Details',
                            style: TextStyle(
                              color: AppTheme.primaryGold,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (session.scheduledAt != null) ...[
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(
                                    Icons.schedule_outlined,
                                    color: Colors.blue,
                                    size: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Scheduled Time',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 10,
                                        ),
                                      ),
                                      Text(
                                        '${session.scheduledAt}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (session.counselor != null)
                              const SizedBox(height: 12),
                          ],
                          if (session.counselor != null) ...[
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(
                                    Icons.person_outline,
                                    color: Colors.green,
                                    size: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Counselor',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 10,
                                        ),
                                      ),
                                      Text(
                                        session.counselor!.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryGold.withOpacity(0.08),
                          AppTheme.primaryGold.withOpacity(0.03),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryGold.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.edit_note_outlined,
                              color: AppTheme.primaryGold,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Intake Form Details',
                              style: TextStyle(
                                color: AppTheme.primaryGold,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (session.intakeForm['issue_description'] != null) ...[
                          _buildDetailRow(
                            'Issue Description',
                            session.intakeForm['issue_description'],
                            Icons.description_outlined,
                          ),
                        ],
                        if (session.intakeForm['urgency_level'] != null) ...[
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            'Priority Level',
                            session.intakeForm['urgency_level'],
                            Icons.priority_high_outlined,
                          ),
                        ],
                        if (session.intakeForm['preferred_counselor'] != null) ...[
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            'Preferred Counselor',
                            session.intakeForm['preferred_counselor'],
                            Icons.person_outline,
                          ),
                        ],
                        if (session.intakeForm['goal'] != null) ...[
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            'Goal',
                            session.intakeForm['goal'],
                            Icons.flag_outlined,
                          ),
                        ],
                        if (session.intakeForm['primary_concern'] != null) ...[
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            'Primary Concern',
                            session.intakeForm['primary_concern'],
                            Icons.psychology_outlined,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded, size: 18),
                      label: const Text('Close'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGold.withOpacity(0.9),
                        foregroundColor: AppTheme.richBlack,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppTheme.primaryGold.withOpacity(0.15),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(icon, color: AppTheme.primaryGold, size: 12),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppTheme.primaryGold.withOpacity(0.8),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.charcoalBlack, AppTheme.richBlack],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primaryGold.withOpacity(0.2)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGold.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.filter_list_outlined,
                        color: AppTheme.primaryGold,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Filter Sessions',
                      style: TextStyle(
                        color: AppTheme.primaryGold,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white.withOpacity(0.03),
                  ),
                  child: TextField(
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      labelText: 'Start Date',
                      labelStyle: TextStyle(
                        color: AppTheme.primaryGold.withOpacity(0.7),
                        fontSize: 12,
                      ),
                      prefixIcon: Icon(
                        Icons.calendar_today_outlined,
                        color: AppTheme.primaryGold.withOpacity(0.6),
                        size: 16,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppTheme.primaryGold.withOpacity(0.2),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.primaryGold),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.02),
                    ),
                    readOnly: true,
                    controller: TextEditingController(
                      text: widget.startDate != null
                          ? '${widget.startDate!.day}/${widget.startDate!.month}/${widget.startDate!.year}'
                          : '',
                    ),
                    onTap: () => widget.onDateSelected(context, true),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white.withOpacity(0.03),
                  ),
                  child: TextField(
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      labelText: 'End Date',
                      labelStyle: TextStyle(
                        color: AppTheme.primaryGold.withOpacity(0.7),
                        fontSize: 12,
                      ),
                      prefixIcon: Icon(
                        Icons.event_outlined,
                        color: AppTheme.primaryGold.withOpacity(0.6),
                        size: 16,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppTheme.primaryGold.withOpacity(0.2),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.primaryGold),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.02),
                    ),
                    readOnly: true,
                    controller: TextEditingController(
                      text: widget.endDate != null
                          ? '${widget.endDate!.day}/${widget.endDate!.month}/${widget.endDate!.year}'
                          : '',
                    ),
                    onTap: () => widget.onDateSelected(context, false),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.primaryGold.withOpacity(0.3),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            widget.onDateSelected(context, true);
                            widget.onDateSelected(context, false);
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Clear Filters',
                            style: TextStyle(
                              color: AppTheme.primaryGold,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.primaryGold,
                              AppTheme.primaryGold.withOpacity(0.8),
                            ],
                          ),
                        ),
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Close',
                            style: TextStyle(
                              color: AppTheme.richBlack,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}