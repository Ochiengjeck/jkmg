import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jkmg/provider/api_providers.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Submit a Prayer Request',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: const Color(0xFFB8860B),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          color: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: const Color(0xFFB8860B).withOpacity(0.3)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Prayer Title',
                      labelStyle: const TextStyle(color: Color(0xFFB8860B)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFB8860B)),
                      ),
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
                      labelText: 'Description',
                      labelStyle: const TextStyle(color: Color(0xFFB8860B)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFB8860B)),
                      ),
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
                      labelText: 'Prayer Category',
                      labelStyle: const TextStyle(color: Color(0xFFB8860B)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFB8860B)),
                      ),
                    ),
                    value: _selectedCategory,
                    items: _prayerCategories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(
                              category[0].toUpperCase() + category.substring(1),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: _isSubmitting
                        ? null
                        : (value) => setState(() => _selectedCategory = value),
                    validator: (value) =>
                        value == null ? 'Please select a category' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Urgency',
                      labelStyle: const TextStyle(color: Color(0xFFB8860B)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFB8860B)),
                      ),
                    ),
                    value: _selectedUrgency,
                    items: _urgencyLevels
                        .map(
                          (urgency) => DropdownMenuItem(
                            value: urgency,
                            child: Text(
                              urgency[0].toUpperCase() + urgency.substring(1),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: _isSubmitting
                        ? null
                        : (value) => setState(() => _selectedUrgency = value),
                    validator: (value) =>
                        value == null ? 'Please select an urgency level' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Start Date',
                      labelStyle: const TextStyle(color: Color(0xFFB8860B)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFB8860B)),
                      ),
                    ),
                    controller: TextEditingController(
                      text: _startDate != null
                          ? '${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}'
                          : '',
                    ),
                    onTap: _isSubmitting
                        ? null
                        : () => _selectDate(context, true),
                    validator: (value) => _startDate == null
                        ? 'Please select a start date'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'End Date',
                      labelStyle: const TextStyle(color: Color(0xFFB8860B)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFB8860B)),
                      ),
                    ),
                    controller: TextEditingController(
                      text: _endDate != null
                          ? '${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}'
                          : '',
                    ),
                    onTap: _isSubmitting
                        ? null
                        : () => _selectDate(context, false),
                    validator: (value) {
                      if (_endDate == null) return 'Please select an end date';
                      if (_startDate != null &&
                          _endDate!.isBefore(_startDate!)) {
                        return 'End date must be after start date';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    title: const Text(
                      'Submit Anonymously',
                      style: TextStyle(color: Color(0xFFB8860B)),
                    ),
                    value: _isAnonymous,
                    onChanged: _isSubmitting
                        ? null
                        : (value) =>
                              setState(() => _isAnonymous = value ?? false),
                    activeColor: const Color(0xFFB8860B),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    title: const Text(
                      'Make Public',
                      style: TextStyle(color: Color(0xFFB8860B)),
                    ),
                    value: _isPublic,
                    onChanged: _isSubmitting
                        ? null
                        : (value) => setState(() => _isPublic = value ?? true),
                    activeColor: const Color(0xFFB8860B),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitPrayerRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB8860B),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          )
                        : const Text(
                            'Submit Prayer Request',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
