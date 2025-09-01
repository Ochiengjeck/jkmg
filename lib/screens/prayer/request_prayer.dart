import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jkmg/provider/api_providers.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../models/prayer_category.dart';
import '../../models/daily_prayer.dart';
import '../../services/preference_service.dart';

class RequestPrayer extends ConsumerStatefulWidget {
  final VoidCallback onPrayerRequestSubmitted;

  const RequestPrayer({super.key, required this.onPrayerRequestSubmitted});

  @override
  ConsumerState<RequestPrayer> createState() => _RequestPrayerState();
}

class _RequestPrayerState extends ConsumerState<RequestPrayer> {
  final _formKey = GlobalKey<FormState>();
  PrayerCategory? _selectedCategory;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isSubmitting = false;
  bool _hasActiveCommitment = false;
  DateTime? _commitmentEndDate;
  int _remainingDays = 0;

  static const String _commitmentStartKey = 'prayer_commitment_start';
  static const String _commitmentEndKey = 'prayer_commitment_end';
  static const String _commitmentCategoryKey = 'prayer_commitment_category';

  @override
  void initState() {
    super.initState();
    _checkActiveCommitment();
  }

  Future<void> _checkActiveCommitment() async {
    final prefs = await PreferenceService.getInstance();
    final commitmentEndString = prefs.getString(_commitmentEndKey);

    if (commitmentEndString != null) {
      final commitmentEnd = DateTime.parse(commitmentEndString);
      final now = DateTime.now();

      if (commitmentEnd.isAfter(now)) {
        setState(() {
          _hasActiveCommitment = true;
          _commitmentEndDate = commitmentEnd;
          _remainingDays = commitmentEnd.difference(now).inDays + 1;
        });
      } else {
        // Clear expired commitment
        await _clearCommitment();
      }
    }
  }

  Future<void> _clearCommitment() async {
    final prefs = await PreferenceService.getInstance();
    await prefs.remove(_commitmentStartKey);
    await prefs.remove(_commitmentEndKey);
    await prefs.remove(_commitmentCategoryKey);
  }

  Future<void> _saveCommitment() async {
    final prefs = await PreferenceService.getInstance();
    final startDate = DateTime.now();
    final endDate = startDate.add(
      const Duration(days: 6),
    ); // 7 days including today

    await prefs.setString(_commitmentStartKey, startDate.toIso8601String());
    await prefs.setString(_commitmentEndKey, endDate.toIso8601String());
    await prefs.setString(_commitmentCategoryKey, _selectedCategory!.name);

    setState(() {
      _hasActiveCommitment = true;
      _commitmentEndDate = endDate;
      _remainingDays = 7;
    });
  }

  Future<void> _submitPrayerRequest() async {
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a prayer category')),
      );
      return;
    }

    // Show confirmation dialog first
    final confirmed = await _showCommitmentConfirmationDialog();
    if (!confirmed) return;

    setState(() => _isSubmitting = true);
    try {
      final dailyPrayer = await ref.read(
        dailyPrayerProvider(_selectedCategory!.id).future,
      );

      // Save the commitment after successful prayer retrieval
      await _saveCommitment();

      setState(() => _isSubmitting = false);

      if (mounted) {
        _showDailyPrayerPopup(dailyPrayer);
        widget.onPrayerRequestSubmitted();
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting daily prayer: $e')),
        );
      }
    }
  }

  Future<bool> _showCommitmentConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: AppTheme.richBlack,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGold.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: AppTheme.primaryGold,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      '7-Day Prayer Commitment',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryGold,
                      ),
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryGold.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selected Category: ${_selectedCategory?.name}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryGold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'By confirming, you agree to:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '• Commit to 7 days of focused prayer\n• Cannot make other prayer requests during this period\n• Other prayer categories will be disabled\n• Daily prayer reminders will be sent',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'This commitment helps maintain focus and consistency in your spiritual journey. Are you ready to begin?',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGold,
                    foregroundColor: AppTheme.richBlack,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Start Commitment',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          if (_hasActiveCommitment) ...[
            ..._buildActiveCommitmentSection(context),
          ] else ...[
            ..._buildPrayerRequestSection(context),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildActiveCommitmentSection(BuildContext context) {
    return [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.successGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.successGreen.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: AppTheme.successGreen,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Active 7-Day Prayer Commitment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.successGreen,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'You have $_remainingDays day${_remainingDays == 1 ? '' : 's'} remaining in your prayer commitment.',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Commitment ends: ${_formatDate(_commitmentEndDate!)}',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
            const SizedBox(height: 12),
            const Text(
              'Other prayer categories are disabled during your commitment period. Stay focused on your current prayer journey.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildPrayerRequestSection(BuildContext context) {
    return [
      _buildIntroText(context),
      const SizedBox(height: 16),
      _buildCategorySelection(context),
      if (_selectedCategory != null) ...[
        const SizedBox(height: 20),
        _buildSubmitSection(context),
      ],
    ];
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryGold.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.church,
            color: AppTheme.primaryGold,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Request Prayer',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.deepGold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIntroText(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.richBlack.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'This feature offers personalized spiritual support by allowing you to select a specific prayer focus based on the life challenge you are facing. Once chosen, the prayer request remains fixed for a 7-day period to encourage consistency and focused intercession.',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey,
          height: 1.4,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildCategorySelection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Prayer Category',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.deepGold,
          ),
        ),
        const SizedBox(height: 12),
        Consumer(
          builder: (context, ref, child) {
            final prayerCategoriesAsync = ref.watch(prayerCategoriesProvider);

            return prayerCategoriesAsync.when(
              data: (categories) {
                if (categories.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'No prayer categories available',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  );
                }

                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: categories.map((category) {
                    final isSelected = _selectedCategory?.id == category.id;
                    return GestureDetector(
                      onTap: (_isSubmitting || _hasActiveCommitment)
                          ? null
                          : () {
                              setState(() {
                                _selectedCategory = category;
                                if (_selectedCategory != null) {
                                  _startDate = DateTime.now();
                                  _endDate = DateTime.now().add(
                                    const Duration(days: 7),
                                  );
                                }
                              });
                            },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _hasActiveCommitment
                              ? Colors.grey.withOpacity(0.1)
                              : isSelected
                              ? AppTheme.primaryGold.withOpacity(0.2)
                              : AppTheme.accentGold.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _hasActiveCommitment
                                ? Colors.grey.withOpacity(0.3)
                                : isSelected
                                ? AppTheme.primaryGold
                                : AppTheme.primaryGold.withOpacity(0.2),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: _hasActiveCommitment
                                ? Colors.grey.shade500
                                : isSelected
                                ? AppTheme.deepGold
                                : Colors.grey.shade700,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => Container(
                padding: const EdgeInsets.all(16),
                child: const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.primaryGold,
                    ),
                  ),
                ),
              ),
              error: (error, stackTrace) => Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Error loading prayer categories',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      error.toString(),
                      style: const TextStyle(fontSize: 10, color: Colors.red),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () => ref.refresh(prayerCategoriesProvider),
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(60, 28),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        textStyle: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSubmitSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.successGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.successGreen.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_today,
                color: AppTheme.successGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '7-Day Prayer Commitment',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.successGreen,
                      ),
                    ),
                    Text(
                      _startDate != null
                          ? 'From ${_formatDate(_startDate!)} to ${_formatDate(_endDate!)}'
                          : 'Dates will be set automatically',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: (_isSubmitting || _hasActiveCommitment)
                ? null
                : _submitPrayerRequest,
            icon: _isSubmitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: AppTheme.richBlack,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.auto_awesome),
            label: Text(
              _isSubmitting ? 'Getting Prayer...' : 'Get Daily Prayer',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGold,
              foregroundColor: AppTheme.richBlack,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDailyPrayerPopup(DailyPrayer dailyPrayer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppTheme.richBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGold.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGold.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          color: AppTheme.primaryGold,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          dailyPrayer.displayTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryGold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.close,
                          color: AppTheme.primaryGold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGold.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            dailyPrayer.displayMessage,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.6,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        if (dailyPrayer.pastor.name.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(
                                Icons.person,
                                size: 18,
                                color: AppTheme.primaryGold,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'By ${dailyPrayer.displayPastorName}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  color: AppTheme.primaryGold,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.richBlack,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    border: Border(
                      top: BorderSide(
                        color: AppTheme.primaryGold.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: dailyPrayer.hasAudio
                              ? () {
                                  // TODO: Implement audio playback
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Playing prayer audio...'),
                                    ),
                                  );
                                }
                              : null,
                          icon: Icon(
                            Icons.play_arrow,
                            color: dailyPrayer.hasAudio
                                ? Colors.white
                                : Colors.grey.shade400,
                          ),
                          label: Text(
                            'Play Prayer',
                            style: TextStyle(
                              color: dailyPrayer.hasAudio
                                  ? Colors.white
                                  : Colors.grey.shade400,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: dailyPrayer.hasAudio
                                ? AppTheme.primaryGold
                                : Colors.grey.shade600,
                            disabledBackgroundColor: Colors.grey.shade600,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: const Size(0, 48),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: AppTheme.primaryGold,
                          side: const BorderSide(color: AppTheme.primaryGold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: const Size(80, 48),
                        ),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
