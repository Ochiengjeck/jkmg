import 'package:flutter/material.dart';
import 'package:jkmg/models/event_model.dart';
import 'package:jkmg/services/event_service.dart';

class EventRegistrationScreen extends StatefulWidget {
  final Event event;

  const EventRegistrationScreen({super.key, required this.event});

  @override
  State<EventRegistrationScreen> createState() => _EventRegistrationScreenState();
}

class _EventRegistrationScreenState extends State<EventRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emergencyContactController = TextEditingController();
  final TextEditingController specialRequirementsController = TextEditingController();

  bool volunteer = false;
  String attendance = 'physical';
  bool _isSubmitting = false;

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final message = await EventService.registerForEvent(
        eventId: widget.event.id,
        volunteer: volunteer,
        emergencyContact: emergencyContactController.text.trim(),
        specialRequirements: specialRequirementsController.text.trim(),
        attendance: attendance,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register for Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(widget.event.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),

              TextFormField(
                controller: emergencyContactController,
                decoration: const InputDecoration(labelText: 'Emergency Contact'),
                keyboardType: TextInputType.phone,
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Please enter an emergency contact'
                    : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: specialRequirementsController,
                decoration: const InputDecoration(labelText: 'Special Requirements'),
                maxLines: 3,
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: attendance,
                decoration: const InputDecoration(labelText: 'Attendance'),
                items: const [
                  DropdownMenuItem(value: 'physical', child: Text('Physical')),
                  DropdownMenuItem(value: 'virtual', child: Text('Virtual')),
                ],
                onChanged: (val) => setState(() => attendance = val!),
              ),

              const SizedBox(height: 12),

              CheckboxListTile(
                value: volunteer,
                onChanged: (val) => setState(() => volunteer = val ?? false),
                title: const Text('Would you like to volunteer?'),
                controlAffinity: ListTileControlAffinity.leading,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitRegistration,
                  child: _isSubmitting
                      ? const CircularProgressIndicator()
                      : const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}