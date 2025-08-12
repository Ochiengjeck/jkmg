import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jkmg/models/event.dart';
import 'package:jkmg/provider/api_providers.dart';
import '../../utils/app_theme.dart';

class EventRegistrationScreen extends ConsumerStatefulWidget {
  final Event event;

  const EventRegistrationScreen({super.key, required this.event});

  @override
  ConsumerState<EventRegistrationScreen> createState() => _EventRegistrationScreenState();
}

class _EventRegistrationScreenState extends ConsumerState<EventRegistrationScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emergencyContactController = TextEditingController();
  final TextEditingController specialRequirementsController = TextEditingController();

  bool volunteer = false;
  String attendance = 'physical';
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
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    emergencyContactController.dispose();
    specialRequirementsController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

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
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text('Registration successful!'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      Navigator.pop(context, true);

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text('Registration failed: $e')),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  Widget _buildAnimatedFormField({
    required Widget child,
    required int index,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, 0.1 + (index * 0.05)),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: Interval(index * 0.1, 1.0, curve: Curves.easeOutCubic),
      )),
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
    return Scaffold(
      backgroundColor: AppTheme.richBlack,
      appBar: AppBar(
        backgroundColor: AppTheme.richBlack,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          'Event Registration',
          style: TextStyle(
            color: AppTheme.primaryGold,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event header
                      _buildAnimatedFormField(
                        index: 0,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.primaryGold.withOpacity(0.15),
                                AppTheme.primaryGold.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppTheme.primaryGold.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryGold.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.event_available_outlined,
                                  color: AppTheme.primaryGold,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Join Event',
                                      style: TextStyle(
                                        color: AppTheme.primaryGold,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.event.displayTitle,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Form fields
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
                            controller: emergencyContactController,
                            keyboardType: TextInputType.phone,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            decoration: InputDecoration(
                              labelText: 'Emergency Contact',
                              labelStyle: TextStyle(
                                color: AppTheme.primaryGold.withOpacity(0.8),
                                fontSize: 16,
                              ),
                              prefixIcon: Icon(
                                Icons.emergency_outlined,
                                color: Colors.red.withOpacity(0.7),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: AppTheme.primaryGold.withOpacity(0.3),
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
                                borderSide: BorderSide(
                                  color: Colors.redAccent,
                                  width: 1.5,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.05),
                              enabled: !_isSubmitting,
                            ),
                            validator: (value) => (value == null || value.trim().isEmpty)
                                ? 'Please enter an emergency contact'
                                : null,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
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
                            controller: specialRequirementsController,
                            maxLines: 4,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            decoration: InputDecoration(
                              labelText: 'Special Requirements (Optional)',
                              labelStyle: TextStyle(
                                color: AppTheme.primaryGold.withOpacity(0.8),
                                fontSize: 16,
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(bottom: 60),
                                child: Icon(
                                  Icons.accessibility_new_outlined,
                                  color: Colors.blue.withOpacity(0.7),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: AppTheme.primaryGold.withOpacity(0.3),
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
                              hintText: 'Any accessibility needs or special arrangements...',
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
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
                            value: attendance,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            dropdownColor: AppTheme.charcoalBlack,
                            decoration: InputDecoration(
                              labelText: 'Attendance Mode',
                              labelStyle: TextStyle(
                                color: AppTheme.primaryGold.withOpacity(0.8),
                                fontSize: 16,
                              ),
                              prefixIcon: Icon(
                                Icons.how_to_reg_outlined,
                                color: Colors.green.withOpacity(0.7),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: AppTheme.primaryGold.withOpacity(0.3),
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
                                value: 'physical',
                                child: Row(
                                  children: [
                                    Icon(Icons.location_on, color: Colors.blue, size: 18),
                                    const SizedBox(width: 8),
                                    Text('Physical Attendance', style: TextStyle(color: Colors.white)),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'virtual',
                                child: Row(
                                  children: [
                                    Icon(Icons.videocam, color: Colors.purple, size: 18),
                                    const SizedBox(width: 8),
                                    Text('Virtual Attendance', style: TextStyle(color: Colors.white)),
                                  ],
                                ),
                              ),
                            ],
                            onChanged: _isSubmitting ? null : (val) => setState(() => attendance = val!),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      _buildAnimatedFormField(
                        index: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.05),
                                Colors.white.withOpacity(0.02),
                              ],
                            ),
                            border: Border.all(
                              color: AppTheme.primaryGold.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: CheckboxListTile(
                            value: volunteer,
                            onChanged: _isSubmitting ? null : (val) => setState(() => volunteer = val ?? false),
                            title: Text(
                              'I would like to volunteer for this event',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              'Help make this event amazing by volunteering!',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 14,
                              ),
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: AppTheme.primaryGold,
                            checkColor: AppTheme.richBlack,
                            secondary: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.volunteer_activism_outlined,
                                color: Colors.orange,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      _buildAnimatedFormField(
                        index: 5,
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
                            onPressed: _isSubmitting ? null : _submitRegistration,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            AppTheme.richBlack,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Submitting Registration...',
                                        style: TextStyle(
                                          color: AppTheme.richBlack,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check_circle_outline,
                                        color: AppTheme.richBlack,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Complete Registration',
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
                      
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}