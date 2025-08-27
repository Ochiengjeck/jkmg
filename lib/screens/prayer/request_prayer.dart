import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jkmg/provider/api_providers.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../models/prayer_category.dart';

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

  Future<void> _submitPrayerRequest() async {
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a prayer category')),
      );
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      await ref.read(
        createPrayerRequestProvider({
          'title': 'Prayer for ${_selectedCategory!.name}',
          'description': 'Prayer request for ${_selectedCategory!.name}',
          'category': _selectedCategory!.name, // Use category ID instead of name
          'urgency': 'medium',
          'is_anonymous': false,
          'is_public': true,
          'start_date':
              '${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}',
          'end_date':
              '${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}',
        }).future,
      );
      setState(() {
        _isSubmitting = false;
        _selectedCategory = null;
        _startDate = null;
        _endDate = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Prayer request submitted successfully')),
      );
      widget.onPrayerRequestSubmitted();
    } catch (e) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting prayer request: $e')),
      );
    }
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
          _buildIntroText(context),
          const SizedBox(height: 16),
          _buildCategorySelection(context),
          if (_selectedCategory != null) ...[
            const SizedBox(height: 20),
            _buildSubmitSection(context),
          ],
        ],
      ),
    );
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
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }
                
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: categories.map((category) {
                    final isSelected = _selectedCategory?.id == category.id;
                    return GestureDetector(
                      onTap: _isSubmitting
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
                          color: isSelected
                              ? AppTheme.primaryGold.withOpacity(0.2)
                              : AppTheme.accentGold.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryGold
                                : AppTheme.primaryGold.withOpacity(0.2),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected
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
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.red,
                      ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            onPressed: _isSubmitting ? null : _submitPrayerRequest,
            icon: _isSubmitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: AppTheme.richBlack,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.send),
            label: Text(
              _isSubmitting ? 'Submitting...' : 'Submit Prayer Request',
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
