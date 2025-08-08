import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jkmg/models/event.dart';
import 'package:jkmg/provider/api_providers.dart';

class EventRegistrationScreen extends ConsumerStatefulWidget {
  final Event event;

  const EventRegistrationScreen({super.key, required this.event});

  @override
  ConsumerState<EventRegistrationScreen> createState() => _EventRegistrationScreenState();
}

class _EventRegistrationScreenState extends ConsumerState<EventRegistrationScreen> {
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
      final registration = await ref.read(registerForEventProvider({
        'event_id': widget.event.id,
        'attendance': attendance,
        'volunteer': volunteer,
      }).future);

      if (!mounted) return;
      
      // Invalidate providers to refresh data
      ref.invalidate(allEventsProvider);
      ref.invalidate(myRegistrationsProvider);
      ref.invalidate(eventDetailsProvider(widget.event.id));
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful!')),
      );
      Navigator.pop(context, true); // Return true to indicate success

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
              Text(widget.event.displayTitle, style: Theme.of(context).textTheme.titleLarge),
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