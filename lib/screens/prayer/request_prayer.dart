import 'package:flutter/material.dart';

class RequestPrayer extends StatefulWidget {
  final VoidCallback onPrayerRequestSubmitted;

  const RequestPrayer({super.key, required this.onPrayerRequestSubmitted});

  @override
  State<RequestPrayer> createState() => _RequestPrayerState();
}

class _RequestPrayerState extends State<RequestPrayer> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

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

  Future<void> _submitPrayerRequest() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        // await ApiService.createPrayerRequest(
        //   category: _selectedCategory!,
        //   startDate: _startDate!,
        //   endDate: _endDate!,
        // );
        setState(() {
          _isLoading = false;
          _selectedCategory = null;
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
        setState(() => _isLoading = false);
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
        Form(
          key: _formKey,
          child: Card(
            color: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: const Color(0xFFB8860B).withOpacity(0.3)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Prayer Category',
                      labelStyle: TextStyle(color: const Color(0xFFB8860B)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: const Color(0xFFB8860B)),
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
                    onChanged: _isLoading
                        ? null
                        : (value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                    validator: (value) =>
                        value == null ? 'Please select a category' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Start Date',
                      labelStyle: TextStyle(color: const Color(0xFFB8860B)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: const Color(0xFFB8860B)),
                      ),
                    ),
                    controller: TextEditingController(
                      text: _startDate != null
                          ? '${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}'
                          : '',
                    ),
                    onTap: _isLoading ? null : () => _selectDate(context, true),
                    validator: (value) => _startDate == null
                        ? 'Please select a start date'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'End Date',
                      labelStyle: TextStyle(color: const Color(0xFFB8860B)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: const Color(0xFFB8860B)),
                      ),
                    ),
                    controller: TextEditingController(
                      text: _endDate != null
                          ? '${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}'
                          : '',
                    ),
                    onTap: _isLoading
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
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitPrayerRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB8860B),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          )
                        : const Text('Submit Prayer Request'),
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
