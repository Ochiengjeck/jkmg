import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/api_providers.dart';
import '../../utils/app_theme.dart';

class BookCounselingForm extends ConsumerStatefulWidget {
  const BookCounselingForm({super.key});

  @override
  ConsumerState<BookCounselingForm> createState() => _BookCounselingFormState();
}

class _BookCounselingFormState extends ConsumerState<BookCounselingForm>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _topicController = TextEditingController();
  final _issueController = TextEditingController();
  final _counselorController = TextEditingController();

  DateTime? _scheduledAt;
  String _urgencyLevel = 'medium';
  bool _isSubmitting = false;

  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
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

  Widget _buildAnimatedFormField({required Widget child, required int index}) {
    return SlideTransition(
      position:
          Tween<Offset>(
            begin: Offset(0, 0.1 + (index * 0.05)),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: _slideController,
              curve: Interval(index * 0.1, 1.0, curve: Curves.easeOutCubic),
            ),
          ),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _fadeController,
            curve: Interval(index * 0.1, 1.0),
          ),
        ),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_slideController, _fadeController]),
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.charcoalBlack,
                    AppTheme.richBlack.withOpacity(0.9),
                  ],
                ),
                border: Border.all(
                  color: AppTheme.primaryGold.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryGold.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAnimatedFormField(
                          index: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.primaryGold.withOpacity(0.2),
                                  AppTheme.primaryGold.withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: AppTheme.primaryGold.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryGold.withOpacity(
                                      0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.psychology_outlined,
                                    color: AppTheme.primaryGold,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Book a Counseling Session',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: AppTheme.primaryGold,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildAnimatedFormField(
                          index: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.05),
                                  Colors.white.withOpacity(0.02),
                                ],
                              ),
                            ),
                            child: TextFormField(
                              controller: _topicController,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Session Topic',
                                labelStyle: TextStyle(
                                  color: AppTheme.primaryGold.withOpacity(0.8),
                                  fontSize: 16,
                                ),
                                prefixIcon: Icon(
                                  Icons.topic_outlined,
                                  color: AppTheme.primaryGold.withOpacity(0.7),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: AppTheme.primaryGold.withOpacity(
                                      0.3,
                                    ),
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: AppTheme.primaryGold,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                    color: Colors.redAccent,
                                    width: 1.5,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.05),
                                enabled: !_isSubmitting,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter a topic';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildAnimatedFormField(
                          index: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.05),
                                  Colors.white.withOpacity(0.02),
                                ],
                              ),
                            ),
                            child: TextFormField(
                              controller: _issueController,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              maxLines: 4,
                              decoration: InputDecoration(
                                labelText: 'Describe Your Concern',
                                labelStyle: TextStyle(
                                  color: AppTheme.primaryGold.withOpacity(0.8),
                                  fontSize: 16,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(bottom: 60),
                                  child: Icon(
                                    Icons.edit_note_outlined,
                                    color: AppTheme.primaryGold.withOpacity(
                                      0.7,
                                    ),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: AppTheme.primaryGold.withOpacity(
                                      0.3,
                                    ),
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: AppTheme.primaryGold,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                    color: Colors.redAccent,
                                    width: 1.5,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.05),
                                enabled: !_isSubmitting,
                                hintText:
                                    'Share what you\'d like to discuss...',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 14,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please describe your concern';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildAnimatedFormField(
                          index: 3,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.05),
                                  Colors.white.withOpacity(0.02),
                                ],
                              ),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: _urgencyLevel,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              dropdownColor: AppTheme.charcoalBlack,
                              decoration: InputDecoration(
                                labelText: 'Priority Level',
                                labelStyle: TextStyle(
                                  color: AppTheme.primaryGold.withOpacity(0.8),
                                  fontSize: 16,
                                ),
                                prefixIcon: Icon(
                                  Icons.priority_high_outlined,
                                  color: AppTheme.primaryGold.withOpacity(0.7),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: AppTheme.primaryGold.withOpacity(
                                      0.3,
                                    ),
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: AppTheme.primaryGold,
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.05),
                              ),
                              items: [
                                DropdownMenuItem(
                                  value: 'low',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        color: Colors.green,
                                        size: 12,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Low Priority',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'medium',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        color: Colors.orange,
                                        size: 12,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Medium Priority',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'high',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        color: Colors.red,
                                        size: 12,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'High Priority',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              onChanged: _isSubmitting
                                  ? null
                                  : (value) {
                                      setState(() {
                                        _urgencyLevel = value!;
                                      });
                                    },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildAnimatedFormField(
                          index: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.05),
                                  Colors.white.withOpacity(0.02),
                                ],
                              ),
                            ),
                            child: TextFormField(
                              controller: _counselorController,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Preferred Counselor (Optional)',
                                labelStyle: TextStyle(
                                  color: AppTheme.primaryGold.withOpacity(0.8),
                                  fontSize: 16,
                                ),
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: AppTheme.primaryGold.withOpacity(0.7),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: AppTheme.primaryGold.withOpacity(
                                      0.3,
                                    ),
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: AppTheme.primaryGold,
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.05),
                                enabled: !_isSubmitting,
                                hintText:
                                    'Leave blank for any available counselor',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildAnimatedFormField(
                          index: 5,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.05),
                                  Colors.white.withOpacity(0.02),
                                ],
                              ),
                            ),
                            child: TextFormField(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Preferred Date & Time (Optional)',
                                labelStyle: TextStyle(
                                  color: AppTheme.primaryGold.withOpacity(0.8),
                                  fontSize: 16,
                                ),
                                prefixIcon: Icon(
                                  Icons.schedule_outlined,
                                  color: AppTheme.primaryGold.withOpacity(0.7),
                                ),
                                suffixIcon: Icon(
                                  Icons.calendar_today_outlined,
                                  color: AppTheme.primaryGold.withOpacity(0.7),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: AppTheme.primaryGold.withOpacity(
                                      0.3,
                                    ),
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: AppTheme.primaryGold,
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.05),
                                enabled: !_isSubmitting,
                                hintText: 'Tap to select date and time',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 14,
                                ),
                              ),
                              readOnly: true,
                              controller: TextEditingController(
                                text: _scheduledAt != null
                                    ? '${_scheduledAt!.day}/${_scheduledAt!.month}/${_scheduledAt!.year} at ${_scheduledAt!.hour.toString().padLeft(2, '0')}:${_scheduledAt!.minute.toString().padLeft(2, '0')}'
                                    : '',
                              ),
                              onTap: _isSubmitting
                                  ? null
                                  : () => _selectDateTime(context),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        _buildAnimatedFormField(
                          index: 6,
                          child: Container(
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.primaryGold,
                                  AppTheme.primaryGold.withOpacity(0.8),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryGold.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
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
                                              'topic': _topicController.text
                                                  .trim(),
                                              'scheduled_at': _scheduledAt
                                                  ?.toIso8601String(),
                                              'intake_form': {
                                                'issue_description':
                                                    _issueController.text
                                                        .trim(),
                                                'urgency_level': _urgencyLevel,
                                                'preferred_counselor':
                                                    _counselorController.text
                                                        .trim()
                                                        .isEmpty
                                                    ? 'any'
                                                    : _counselorController.text
                                                          .trim(),
                                              },
                                            }).future,
                                          );

                                          if (mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.check_circle,
                                                      color: Colors.white,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      'Session booked successfully!',
                                                    ),
                                                  ],
                                                ),
                                                backgroundColor: Colors.green,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            );

                                            ref.refresh(
                                              myCounselingSessionsProvider({
                                                'per_page': 15,
                                              }),
                                            );

                                            _resetForm();
                                          }
                                        } catch (e) {
                                          if (mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.error,
                                                      color: Colors.white,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Text('Error: $e'),
                                                    ),
                                                  ],
                                                ),
                                                backgroundColor: Colors.red,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
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
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                              ),
                              child: _isSubmitting
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  AppTheme.richBlack,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Booking Session...',
                                          style: TextStyle(
                                            color: AppTheme.richBlack,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.calendar_month_outlined,
                                          color: AppTheme.richBlack,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Book My Session',
                                          style: TextStyle(
                                            color: AppTheme.richBlack,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
