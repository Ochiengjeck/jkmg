import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/feedback.dart';
import '../services/api_service.dart';
import '../utils/app_theme.dart';

class FeedbackDialog extends ConsumerStatefulWidget {
  const FeedbackDialog({super.key});

  @override
  ConsumerState<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends ConsumerState<FeedbackDialog> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _emailController = TextEditingController();

  List<FeedbackType> _feedbackTypes = [];
  FeedbackType? _selectedType;
  int? _rating;
  bool _isLoading = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadFeedbackTypes();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadFeedbackTypes() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = ApiService();
      final types = await apiService.getFeedbackTypes();
      
      if (mounted) {
        setState(() {
          _feedbackTypes = types;
          _selectedType = types.isNotEmpty ? types.first : null;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _feedbackTypes = [
            FeedbackType(
              value: 'general_feedback',
              label: 'General Feedback',
              description: 'General comments about the app',
            ),
          ];
          _selectedType = _feedbackTypes.first;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate() || _selectedType == null) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final apiService = ApiService();
      
      final metadata = {
        'device_info': 'iPhone 14',
        'app_version': '1.0.0',
        'platform': 'ios',
        'screen': 'home',
      };

      await apiService.submitFeedback(
        type: _selectedType!.value,
        subject: _subjectController.text.trim(),
        message: _messageController.text.trim(),
        rating: _rating,
        contactEmail: _emailController.text.trim().isNotEmpty 
            ? _emailController.text.trim() 
            : null,
        metadata: metadata,
      );

      if (mounted) {
        Navigator.of(context).pop();
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit feedback: ${e.toString()}'),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.successGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.check_circle,
                color: AppTheme.successGreen,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Thank You!'),
          ],
        ),
        content: const Text(
          'Your feedback has been submitted successfully. We appreciate your input and will review it carefully.',
          style: TextStyle(height: 1.4),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: _isLoading ? _buildLoadingState() : _buildForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryGold,
            AppTheme.darkGold,
          ],
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.feedback_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Share Your Feedback',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Help us improve your experience',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(48),
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading feedback types...'),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTypeSelection(),
          const SizedBox(height: 24),
          _buildSubjectField(),
          const SizedBox(height: 20),
          _buildMessageField(),
          const SizedBox(height: 20),
          _buildRatingSection(),
          const SizedBox(height: 20),
          _buildEmailField(),
          const SizedBox(height: 32),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Feedback Type *',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.primaryGold.withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<FeedbackType>(
              value: _selectedType,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              items: _feedbackTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        type.displayLabel,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        type.displayDescription,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (type) {
                setState(() {
                  _selectedType = type;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subject *',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _subjectController,
          decoration: InputDecoration(
            hintText: 'Brief description of your feedback',
            prefixIcon: Icon(
              Icons.subject_rounded,
              color: AppTheme.primaryGold,
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a subject';
            }
            if (value.trim().length < 5) {
              return 'Subject must be at least 5 characters';
            }
            return null;
          },
          maxLength: 100,
        ),
      ],
    );
  }

  Widget _buildMessageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Message *',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _messageController,
          decoration: InputDecoration(
            hintText: 'Please share your detailed feedback...',
            prefixIcon: Icon(
              Icons.message_rounded,
              color: AppTheme.primaryGold,
            ),
            alignLabelWithHint: true,
          ),
          maxLines: 4,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your feedback message';
            }
            if (value.trim().length < 10) {
              return 'Message must be at least 10 characters';
            }
            return null;
          },
          maxLength: 500,
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rating (Optional)',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'How would you rate your overall app experience?',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starIndex = index + 1;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _rating = starIndex;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  _rating != null && starIndex <= _rating!
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color: AppTheme.primaryGold,
                  size: 32,
                ),
              ),
            );
          }),
        ),
        if (_rating != null) ...[
          const SizedBox(height: 8),
          Center(
            child: Text(
              '$_rating out of 5 stars',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.primaryGold,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Email (Optional)',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'If you\'d like us to follow up with you',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: 'your@email.com',
            prefixIcon: Icon(
              Icons.email_rounded,
              color: AppTheme.primaryGold,
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value != null && value.trim().isNotEmpty) {
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
                return 'Please enter a valid email address';
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isSubmitting ? null : _submitFeedback,
        icon: _isSubmitting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Icons.send_rounded),
        label: Text(_isSubmitting ? 'Submitting...' : 'Submit Feedback'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}