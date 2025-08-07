import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/api_providers.dart';

class BookCounselingForm extends ConsumerStatefulWidget {
  const BookCounselingForm({super.key});

  @override
  ConsumerState<BookCounselingForm> createState() => _BookCounselingFormState();
}

class _BookCounselingFormState extends ConsumerState<BookCounselingForm> {
  final _formKey = GlobalKey<FormState>();
  final _topicController = TextEditingController();
  final _issueController = TextEditingController();
  final _counselorController = TextEditingController();

  DateTime? _scheduledAt;
  String _urgencyLevel = 'medium';
  bool _isSubmitting = false; // Add loading state

  @override
  void dispose() {
    _topicController.dispose();
    _issueController.dispose();
    _counselorController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _scheduledAt = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _topicController.clear();
    _issueController.clear();
    _counselorController.clear();
    setState(() {
      _scheduledAt = null;
      _urgencyLevel = 'medium';
      _isSubmitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: const Color(0xFFB8860B).withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Book a Counseling Session',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFFB8860B),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _topicController,
                decoration: InputDecoration(
                  labelText: 'Topic',
                  labelStyle: const TextStyle(color: Color(0xFFB8860B)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabled: !_isSubmitting,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a topic';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _issueController,
                decoration: InputDecoration(
                  labelText: 'Issue Description',
                  labelStyle: const TextStyle(color: Color(0xFFB8860B)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabled: !_isSubmitting,
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please describe the issue';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _urgencyLevel,
                decoration: InputDecoration(
                  labelText: 'Urgency Level',
                  labelStyle: const TextStyle(color: Color(0xFFB8860B)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'low', child: Text('Low')),
                  DropdownMenuItem(value: 'medium', child: Text('Medium')),
                  DropdownMenuItem(value: 'high', child: Text('High')),
                ],
                onChanged: _isSubmitting
                    ? null
                    : (value) {
                        setState(() {
                          _urgencyLevel = value!;
                        });
                      },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _counselorController,
                decoration: InputDecoration(
                  labelText: 'Preferred Counselor (optional)',
                  labelStyle: const TextStyle(color: Color(0xFFB8860B)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabled: !_isSubmitting,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Preferred Date and Time (optional)',
                  labelStyle: const TextStyle(color: Color(0xFFB8860B)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabled: !_isSubmitting,
                ),
                readOnly: true,
                controller: TextEditingController(
                  text: _scheduledAt != null
                      ? '${_scheduledAt!.year}-${_scheduledAt!.month.toString().padLeft(2, '0')}-${_scheduledAt!.day.toString().padLeft(2, '0')} ${_scheduledAt!.hour.toString().padLeft(2, '0')}:${_scheduledAt!.minute.toString().padLeft(2, '0')}'
                      : '',
                ),
                onTap: _isSubmitting ? null : () => _selectDateTime(context),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isSubmitting = true;
                            });

                            try {
                              await ref.read(
                                bookCounselingSessionProvider({
                                  'topic': _topicController.text.trim(),
                                  'scheduled_at': _scheduledAt
                                      ?.toIso8601String(),
                                  'intake_form': {
                                    'issue_description': _issueController.text
                                        .trim(),
                                    'urgency_level': _urgencyLevel,
                                    'preferred_counselor':
                                        _counselorController.text.trim().isEmpty
                                        ? 'any'
                                        : _counselorController.text.trim(),
                                  },
                                }).future,
                              );

                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Session booked successfully!',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );

                                // Refresh the counseling sessions list
                                ref.refresh(
                                  myCounselingSessionsProvider({
                                    'per_page': 15,
                                  }),
                                );

                                _resetForm();
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                setState(() {
                                  _isSubmitting = false;
                                });
                              }
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB8860B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.black,
                            ),
                          ),
                        )
                      : const Text(
                          'Book Session',
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
