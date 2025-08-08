import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jkmg/provider/api_providers.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

class RequestPrayer extends StatefulWidget {
  final VoidCallback onPrayerRequestSubmitted;

  const RequestPrayer({super.key, required this.onPrayerRequestSubmitted});

  @override
  State<RequestPrayer> createState() => _RequestPrayerState();
}

class _RequestPrayerState extends State<RequestPrayer> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _description;
  String? _selectedCategory;
  String? _selectedUrgency;
  bool _isAnonymous = false;
  bool _isPublic = true;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isSubmitting = false;

  final List<String> _prayerCategories = [
    'healing',
    'marriage',
    'protection',
    'financial',
    'family',
    'career',
    'salvation',
    'guidance',
    'thanksgiving',
    'other',
  ];

  final List<String> _urgencyLevels = ['high', 'medium', 'low'];

  Future<void> _submitPrayerRequest() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      try {
        await ProviderScope.containerOf(context).read(
          createPrayerRequestProvider({
            'title': _title!,
            'description': _description!,
            'category': _selectedCategory!,
            'urgency': _selectedUrgency!,
            'is_anonymous': _isAnonymous,
            'is_public': _isPublic,
            'start_date':
                '${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}',
            'end_date':
                '${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}',
          }).future,
        );
        setState(() {
          _isSubmitting = false;
          _title = null;
          _description = null;
          _selectedCategory = null;
          _selectedUrgency = null;
          _isAnonymous = false;
          _isPublic = true;
          _startDate = null;
          _endDate = null;
        });
        _formKey.currentState!.reset();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Prayer request submitted successfully'),
          ),
        );
        widget.onPrayerRequestSubmitted();
      } catch (e) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting prayer request: $e')),
        );
      }
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
            _buildForm(context),
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
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _prayerCategories.map((category) {
            final isSelected = _selectedCategory == category;
            return GestureDetector(
              onTap: _isSubmitting ? null : () {
                setState(() {
                  _selectedCategory = category;
                  if (_selectedCategory != null) {
                    _startDate = DateTime.now();
                    _endDate = DateTime.now().add(const Duration(days: 7));
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  category[0].toUpperCase() + category.substring(1),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? AppTheme.deepGold : Colors.grey.shade700,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Prayer Details',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.deepGold,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Prayer Title',
              labelStyle: const TextStyle(color: AppTheme.primaryGold),
              hintText: 'Brief title for your prayer request',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primaryGold),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.primaryGold.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primaryGold, width: 2),
              ),
              prefixIcon: const Icon(Icons.title, color: AppTheme.primaryGold),
            ),
            onChanged: (value) => setState(() => _title = value),
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter a title'
                : null,
            enabled: !_isSubmitting,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Prayer Description',
              labelStyle: const TextStyle(color: AppTheme.primaryGold),
              hintText: 'Describe your prayer need in detail',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primaryGold),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.primaryGold.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primaryGold, width: 2),
              ),
              prefixIcon: const Icon(Icons.description, color: AppTheme.primaryGold),
            ),
            maxLines: 3,
            onChanged: (value) => setState(() => _description = value),
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter a description'
                : null,
            enabled: !_isSubmitting,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Priority Level',
              labelStyle: const TextStyle(color: AppTheme.primaryGold),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primaryGold),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.primaryGold.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primaryGold, width: 2),
              ),
              prefixIcon: const Icon(Icons.priority_high, color: AppTheme.primaryGold),
            ),
            value: _selectedUrgency,
            items: _urgencyLevels
                .map(
                  (urgency) => DropdownMenuItem(
                    value: urgency,
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: urgency == 'high' ? Colors.red : 
                                   urgency == 'medium' ? Colors.orange : Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(urgency[0].toUpperCase() + urgency.substring(1)),
                      ],
                    ),
                  ),
                )
                .toList(),
            onChanged: _isSubmitting
                ? null
                : (value) => setState(() => _selectedUrgency = value),
            validator: (value) =>
                value == null ? 'Please select a priority level' : null,
          ),
          const SizedBox(height: 16),
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
          const SizedBox(height: 16),
          _buildPrivacyOptions(context),
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
              label: Text(_isSubmitting ? 'Submitting...' : 'Submit Prayer Request'),
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
      ),
    );
  }

  Widget _buildPrivacyOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Privacy Settings',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.deepGold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.accentGold.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.primaryGold.withOpacity(0.1)),
          ),
          child: Column(
            children: [
              CheckboxListTile(
                title: const Text(
                  'Submit Anonymously',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'Your name will not be displayed with this request',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ),
                value: _isAnonymous,
                onChanged: _isSubmitting
                    ? null
                    : (value) => setState(() => _isAnonymous = value ?? false),
                activeColor: AppTheme.primaryGold,
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const Divider(height: 1),
              CheckboxListTile(
                title: const Text(
                  'Make Public',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'Allow other users to see and pray for this request',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ),
                value: _isPublic,
                onChanged: _isSubmitting
                    ? null
                    : (value) => setState(() => _isPublic = value ?? true),
                activeColor: AppTheme.primaryGold,
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
