import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/salvation.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../services/api_service.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../inbox/inbox_screen.dart';
import '../testimonies/testimonies_screen.dart';
import '../testimonies/submit_testimony_screen.dart';
import '../testimonies/my_testimonies_screen.dart';

enum SalvationType { giveLifeToChrist, rededicateLifeToChrist, testimony }

class SalvationCornerScreen extends ConsumerStatefulWidget {
  final SalvationType? initialSelection;
  final VoidCallback? onSelectionUsed;
  
  const SalvationCornerScreen({super.key, this.initialSelection, this.onSelectionUsed});

  @override
  ConsumerState<SalvationCornerScreen> createState() =>
      _SalvationCornerScreenState();
}

class _SalvationCornerScreenState extends ConsumerState<SalvationCornerScreen>
    with TickerProviderStateMixin {
  SalvationType? selectedSalvationType;
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;
  final int _testimonyCount = 5; // Number of testimonies
  final ApiService _apiService = ApiService();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isSubmittingLifeDecision = false;
  bool _isSubmittingRededication = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoSlide();
    
    // Set initial selection if provided (for FAB navigation)
    if (widget.initialSelection != null) {
      selectedSalvationType = widget.initialSelection;
    }
  }

  @override
  void didUpdateWidget(SalvationCornerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if initialSelection has changed
    if (widget.initialSelection != oldWidget.initialSelection && widget.initialSelection != null) {
      setState(() {
        selectedSalvationType = widget.initialSelection;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentPage < _testimonyCount - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(),
            const SizedBox(height: 24),
            _buildSalvationDropdown(context),
            const SizedBox(height: 24),
            if (selectedSalvationType != null) _buildSelectedForm(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGold.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Clean image section with info button
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              border: Border.all(
                color: AppTheme.primaryGold.withOpacity(0.3),
                width: 1,
              ),
              image: const DecorationImage(
                image: AssetImage('assets/images/salvation corner.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Stack(
              children: [
                // Info button overlay (preserved functionality)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => _showInfoDialog(),
                      icon: const Icon(
                        Icons.info_outline,
                        color: AppTheme.primaryGold,
                      ),
                      tooltip: 'About Salvation Corner',
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Separate text content section with modern design
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.charcoalBlack, AppTheme.richBlack],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              border: Border.all(
                color: AppTheme.primaryGold.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Description
                const Text(
                  'Begin or Renew Your Journey with Christ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Take the first step in your spiritual journey or renew your commitment',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Feature highlights in single row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildFeatureChip('Salvation'),
                      const SizedBox(width: 8),
                      _buildFeatureChip('Rededication'),
                      const SizedBox(width: 8),
                      _buildFeatureChip('Testimony'),
                      const SizedBox(width: 8),
                      _buildStatsButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryGold.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppTheme.primaryGold.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          color: AppTheme.primaryGold,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatsButton() {
    return GestureDetector(
      onTap: _showSalvationStats,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.successGreen.withOpacity(0.15),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: AppTheme.successGreen.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.analytics, size: 12, color: AppTheme.successGreen),
            const SizedBox(width: 4),
            Text(
              'Stats',
              style: TextStyle(
                fontSize: 10,
                color: AppTheme.successGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalvationDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Choose Your Journey',
          subtitle: 'Select how you want to connect with Christ',
        ),
        const SizedBox(height: 12),
        CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<SalvationType>(
                value: selectedSalvationType,
                hint: Text(
                  'Select an option',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black54,
                  ),
                ),
                decoration: InputDecoration(
                  labelText: 'Salvation Journey',
                  labelStyle: const TextStyle(color: AppTheme.primaryGold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppTheme.primaryGold),
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: SalvationType.giveLifeToChrist,
                    child: Text('Give My Life to Christ'),
                  ),
                  DropdownMenuItem(
                    value: SalvationType.rededicateLifeToChrist,
                    child: Text('Rededicate My Life to Christ'),
                  ),
                  DropdownMenuItem(
                    value: SalvationType.testimony,
                    child: Text('Testimony'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedSalvationType = value;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedForm(BuildContext context) {
    switch (selectedSalvationType!) {
      case SalvationType.giveLifeToChrist:
        return _buildGiveLifeToChristForm(context);
      case SalvationType.rededicateLifeToChrist:
        return _buildRededicateLifeToChristForm(context);
      case SalvationType.testimony:
        return _buildTestimonyForm(context);
    }
  }

  Widget _buildGiveLifeToChristForm(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController ageController = TextEditingController();
    String selectedGender = 'male';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Give My Life to Christ',
          subtitle: 'Take the first step in your journey with Jesus',
        ),
        const SizedBox(height: 12),
        CustomCard(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: const TextStyle(color: AppTheme.primaryGold),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppTheme.primaryGold),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    labelStyle: const TextStyle(color: AppTheme.primaryGold),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppTheme.primaryGold),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(value: 'male', child: Text('Male')),
                    DropdownMenuItem(value: 'female', child: Text('Female')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      selectedGender = value;
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your gender';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    labelStyle: const TextStyle(color: AppTheme.primaryGold),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppTheme.primaryGold),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    final age = int.tryParse(value);
                    if (age == null || age < 1 || age > 120) {
                      return 'Please enter a valid age';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmittingLifeDecision ? null : () async {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          _isSubmittingLifeDecision = true;
                        });
                        
                        try {
                          print('🚀 Making API call to submitLifeToChrist...');
                          print('📤 Form data: name=${nameController.text}, age=${ageController.text}, gender=$selectedGender');
                          print('📤 API Request data: age=${ageController.text}, gender=$selectedGender (Note: API only accepts age and gender)');
                          
                          final response = await _apiService.submitLifeToChrist(
                            age: int.parse(ageController.text),
                            gender: selectedGender,
                          );

                          print('✅ API Response received:');
                          print('📥 Response: $response');

                          if (mounted) {
                            setState(() {
                              _isSubmittingLifeDecision = false;
                            });
                            print('🔍 Parsing salvation_decision from response...');
                            
                            final salvationDecisionData = response['salvation_decision'];
                            print('📋 Salvation decision data: $salvationDecisionData');
                            
                            if (salvationDecisionData != null) {
                              final salvationDecision = SalvationDecisionResponse.fromJson(salvationDecisionData);
                              print('✨ Parsed salvation decision: ${salvationDecision.toJson()}');
                              print('🙏 Prayer data: ${salvationDecision.prayer?.toJson()}');
                              
                              if (salvationDecision.prayer != null) {
                                print('🎵 Showing prayer dialog with audio: ${salvationDecision.prayer!.audioPath}');
                                _showPrayerDialog(context, salvationDecision.prayer!);
                              } else {
                                print('⚠️ No prayer data found, showing success message');
                                _showSuccessMessage(
                                  context,
                                  'Your decision has been recorded! An audio prayer from Rev Julian Kyula will be available in your inbox soon.',
                                  false,
                                );
                              }
                            } else {
                              print('❌ No salvation_decision found in response');
                              _showSuccessMessage(
                                context,
                                'Your decision has been recorded! An audio prayer from Rev Julian Kyula will be available in your inbox soon.',
                                false,
                              );
                            }
                          }

                          nameController.clear();
                          ageController.clear();
                          selectedGender = 'male';
                        } catch (e) {
                          print('❌ Error during API call: $e');
                          if (mounted) {
                            setState(() {
                              _isSubmittingLifeDecision = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 5),
                              ),
                            );
                          }
                        }
                      } else {
                        print('❌ Form validation failed');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGold,
                      foregroundColor: AppTheme.richBlack,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isSubmittingLifeDecision
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.richBlack),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Submitting...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            'Submit Decision',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRededicateLifeToChristForm(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController ageController = TextEditingController();
    String selectedGender = 'male';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Rededicate My Life to Christ',
          subtitle: 'Renew your commitment and strengthen your faith',
        ),
        const SizedBox(height: 12),
        CustomCard(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: const TextStyle(color: AppTheme.primaryGold),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppTheme.primaryGold),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    labelStyle: const TextStyle(color: AppTheme.primaryGold),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppTheme.primaryGold),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(value: 'male', child: Text('Male')),
                    DropdownMenuItem(value: 'female', child: Text('Female')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      selectedGender = value;
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your gender';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    labelStyle: const TextStyle(color: AppTheme.primaryGold),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppTheme.primaryGold),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    final age = int.tryParse(value);
                    if (age == null || age < 1 || age > 120) {
                      return 'Please enter a valid age';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmittingRededication ? null : () async {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          _isSubmittingRededication = true;
                        });
                        
                        try {
                          print('🚀 Making API call to resubmitLifeToChrist...');
                          print('📤 Form data: name=${nameController.text}, age=${ageController.text}, gender=$selectedGender');
                          print('📤 API Request data: age=${ageController.text}, gender=$selectedGender (Note: API only accepts age and gender)');
                          
                          final response = await _apiService
                              .resubmitLifeToChrist(
                                age: int.parse(ageController.text),
                                gender: selectedGender,
                              );

                          print('✅ API Response received:');
                          print('📥 Response: $response');

                          if (mounted) {
                            setState(() {
                              _isSubmittingRededication = false;
                            });
                            print('🔍 Parsing salvation_decision from response...');
                            
                            final salvationDecisionData = response['salvation_decision'];
                            print('📋 Salvation decision data: $salvationDecisionData');
                            
                            if (salvationDecisionData != null) {
                              final salvationDecision = SalvationDecisionResponse.fromJson(salvationDecisionData);
                              print('✨ Parsed salvation decision: ${salvationDecision.toJson()}');
                              print('🙏 Prayer data: ${salvationDecision.prayer?.toJson()}');
                              
                              if (salvationDecision.prayer != null) {
                                print('🎵 Showing prayer dialog with audio: ${salvationDecision.prayer!.audioPath}');
                                _showPrayerDialog(context, salvationDecision.prayer!);
                              } else {
                                print('⚠️ No prayer data found, showing success message');
                                _showSuccessMessage(
                                  context,
                                  'Your rededication has been recorded! An audio prayer from Rev Julian Kyula will be available in your inbox soon.',
                                  false,
                                );
                              }
                            } else {
                              print('❌ No salvation_decision found in response');
                              _showSuccessMessage(
                                context,
                                'Your rededication has been recorded! An audio prayer from Rev Julian Kyula will be available in your inbox soon.',
                                false,
                              );
                            }
                          }

                          nameController.clear();
                          ageController.clear();
                          selectedGender = 'male';
                        } catch (e) {
                          print('❌ Error during rededication API call: $e');
                          if (mounted) {
                            setState(() {
                              _isSubmittingRededication = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 5),
                              ),
                            );
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGold,
                      foregroundColor: AppTheme.richBlack,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isSubmittingRededication
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.richBlack),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Submitting...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            'Submit Rededication',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTestimonyForm(BuildContext context) {
    return Column(
      children: [
        _buildTestimonySlides(context),
        const SizedBox(height: 24),
        const SectionHeader(
          title: 'Testimonies Community',
          subtitle: 'Share your story and read testimonies of God\'s goodness',
        ),
        const SizedBox(height: 12),
        CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.favorite, color: AppTheme.primaryGold, size: 24),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Join Our Testimonies Community',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryGold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Share your testimony of how God has worked in your life and read inspiring stories from our community members.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              // Quick actions grid
              Row(
                children: [
                  Expanded(
                    child: _buildTestimonyActionCard(
                      context,
                      'View All\nTestimonies',
                      Icons.visibility,
                      Colors.blue,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TestimoniesScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTestimonyActionCard(
                      context,
                      'Share Your\nTestimony',
                      Icons.add,
                      Colors.green,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SubmitTestimonyScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTestimonyActionCard(
                      context,
                      'My\nTestimonies',
                      Icons.person,
                      Colors.orange,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MyTestimoniesScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.grey.shade500,
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Learn More',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.primaryGold.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: AppTheme.primaryGold, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'All testimonies are reviewed before being published to ensure they align with our community guidelines.',
                        style: TextStyle(
                          color: AppTheme.primaryGold,
                          fontSize: 12,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTestimonyActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestimonySlides(BuildContext context) {
    final testimoniesToShow = ref.watch(allTestimoniesProvider);

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Testimonies from Our Community',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.primaryGold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TestimoniesScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View All',
                        style: TextStyle(
                          color: AppTheme.primaryGold,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: AppTheme.primaryGold,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          testimoniesToShow.when(
            data: (testimonies) {
              if (testimonies.isEmpty) {
                return _buildEmptyTestimoniesSlide(context);
              }

              // Show only first 5 testimonies for the carousel
              final displayTestimonies = testimonies.take(5).toList();

              return SizedBox(
                height: 220,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: displayTestimonies.length,
                  itemBuilder: (context, index) {
                    final testimony = displayTestimonies[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TestimoniesScreen(),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.primaryGold.withOpacity(0.15),
                              AppTheme.primaryGold.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.primaryGold.withOpacity(0.3),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.format_quote,
                                    color: AppTheme.primaryGold,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      testimony.displayTitle,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: AppTheme.primaryGold,
                                            fontWeight: FontWeight.w600,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Expanded(
                                child: Text(
                                  testimony.displayExcerpt,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color:
                                            Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white70
                                            : Colors.black87,
                                        height: 1.4,
                                      ),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '- ${testimony.displayUserName}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppTheme.primaryGold,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w500,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Row(
                                    children: List.generate(
                                      displayTestimonies.length,
                                      (dotIndex) => Container(
                                        width: 8,
                                        height: 8,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: dotIndex == index
                                              ? AppTheme.primaryGold
                                              : AppTheme.primaryGold
                                                    .withOpacity(0.3),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => _buildLoadingTestimoniesSlide(context),
            error: (_, __) => _buildEmptyTestimoniesSlide(context),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTestimoniesSlide(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.withOpacity(0.1), Colors.grey.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'No Testimonies Yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to share your testimony!',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingTestimoniesSlide(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryGold.withOpacity(0.1),
            AppTheme.primaryGold.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryGold.withOpacity(0.3)),
      ),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGold),
        ),
      ),
    );
  }

  void _showSuccessMessage(
    BuildContext context,
    String message, [
    bool hasPrayer = false,
  ]) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              const SizedBox(width: 8),
              Text(
                'Success!',
                style: TextStyle(
                  color: AppTheme.primaryGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message, style: Theme.of(context).textTheme.bodyMedium),
              if (hasPrayer || !hasPrayer) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.primaryGold.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.inbox, color: AppTheme.primaryGold, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          hasPrayer
                              ? 'Check your inbox now for your prayer!'
                              : 'Watch your inbox for the prayer notification.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.primaryGold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  selectedSalvationType = null;
                });
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  selectedSalvationType = null;
                });
                // Navigate to inbox
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InboxScreen()),
                );
              },
              icon: Icon(Icons.inbox, size: 16, color: AppTheme.richBlack),
              label: Text(
                'Go to Inbox',
                style: TextStyle(
                  color: AppTheme.richBlack,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGold,
                foregroundColor: AppTheme.richBlack,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPrayerDialog(BuildContext context, SalvationPrayer prayer) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.charcoalBlack, AppTheme.richBlack],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.primaryGold.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Success Icon and Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGold.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.primaryGold.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.celebration,
                          color: AppTheme.primaryGold,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Success Message
                      ShaderMask(
                        shaderCallback: (bounds) => AppTheme.primaryGoldGradient.createShader(bounds),
                        child: Text(
                          'Praise the Lord!',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Your decision has been recorded successfully',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      
                      // Prayer Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGold.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.primaryGold.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.auto_awesome,
                                  color: AppTheme.primaryGold,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    prayer.title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.primaryGold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              height: 180,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                  width: 1,
                                ),
                              ),
                              child: SingleChildScrollView(
                                child: Text(
                                  prayer.message,
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Audio Player Section
                      if (prayer.audioPath.isNotEmpty) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.successGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.successGreen.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.headphones,
                                    color: AppTheme.successGreen,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Listen to Rev Julian Kyula',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.successGreen,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppTheme.successGreen.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      onPressed: () => _togglePlayPause(prayer.audioPath, setDialogState),
                                      icon: Icon(
                                        _isPlaying ? Icons.pause : Icons.play_arrow,
                                        color: AppTheme.successGreen,
                                        size: 32,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        LinearProgressIndicator(
                                          value: _totalDuration.inSeconds > 0
                                              ? _currentPosition.inSeconds / _totalDuration.inSeconds
                                              : 0.0,
                                          backgroundColor: Colors.white.withOpacity(0.2),
                                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.successGreen),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              _formatDuration(_currentPosition),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white.withOpacity(0.6),
                                              ),
                                            ),
                                            Text(
                                              _formatDuration(_totalDuration),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white.withOpacity(0.6),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                _audioPlayer.stop();
                                Navigator.of(context).pop();
                                setState(() {
                                  selectedSalvationType = null;
                                });
                              },
                              icon: Icon(Icons.close, size: 18, color: Colors.white.withOpacity(0.7)),
                              label: Text(
                                'Close',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.white.withOpacity(0.3)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _audioPlayer.stop();
                                Navigator.of(context).pop();
                                setState(() {
                                  selectedSalvationType = null;
                                });
                                // Navigate to inbox
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const InboxScreen()),
                                );
                              },
                              icon: Icon(Icons.inbox, size: 18, color: AppTheme.richBlack),
                              label: Text(
                                'Go to Inbox',
                                style: TextStyle(
                                  color: AppTheme.richBlack,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryGold,
                                foregroundColor: AppTheme.richBlack,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _togglePlayPause(String audioUrl, StateSetter setDialogState) async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        setDialogState(() {
          _isPlaying = false;
        });
      } else {
        await _audioPlayer.play(UrlSource(audioUrl));
        
        // Listen to player state changes
        _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
          if (mounted) {
            setDialogState(() {
              _isPlaying = state == PlayerState.playing;
            });
          }
        });
        
        // Listen to position changes
        _audioPlayer.onPositionChanged.listen((Duration position) {
          if (mounted) {
            setDialogState(() {
              _currentPosition = position;
            });
          }
        });
        
        // Listen to duration changes
        _audioPlayer.onDurationChanged.listen((Duration? duration) {
          if (mounted && duration != null) {
            setDialogState(() {
              _totalDuration = duration;
            });
          }
        });
        
        setDialogState(() {
          _isPlaying = true;
        });
      }
    } catch (e) {
      print('Error playing audio: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error playing audio')),
        );
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  void _showSalvationStats() async {
    try {
      final stats = await _apiService.getSalvationStats();

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.successGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.analytics,
                    color: AppTheme.successGreen,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Salvation Statistics',
                  style: TextStyle(
                    color: AppTheme.primaryGold,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildStatRow(
                    'Total Salvation Decisions',
                    stats['total_salvation']?.toString() ?? '0',
                    Icons.favorite,
                    Colors.red,
                  ),
                  const SizedBox(height: 12),
                  _buildStatRow(
                    'Life Dedications',
                    stats['salvation_count']?.toString() ?? '0',
                    Icons.volunteer_activism,
                    AppTheme.primaryGold,
                  ),
                  const SizedBox(height: 12),
                  _buildStatRow(
                    'Life Re-dedications',
                    stats['rededication_count']?.toString() ?? '0',
                    Icons.refresh,
                    AppTheme.successGreen,
                  ),
                  const SizedBox(height: 12),
                  _buildStatRow(
                    'Testimonies Shared',
                    stats['testimony_count']?.toString() ?? '0',
                    Icons.message,
                    Colors.blue,
                  ),
                  if (stats['recent_activity'] != null) ...[
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      'Recent Activity',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryGold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      stats['recent_activity'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Close',
                  style: TextStyle(color: AppTheme.primaryGold),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load statistics: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildStatRow(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Salvation Corner'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Salvation Corner is your place to begin or renew your spiritual journey with Christ. Here you can:',
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: 12),
              Text('• Give your life to Christ for the first time'),
              Text('• Rededicate your life to strengthen your faith'),
              Text('• Share testimonies of God\'s work in your life'),
              Text('• Connect with an audio prayer from Rev Julian Kyula'),
              SizedBox(height: 12),
              Text(
                'Every decision you make here connects you with our spiritual community and provides you with personalized prayers and guidance.',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class SalvationDecisionList extends StatefulWidget {
  final List<SalvationDecision> decisions;
  final String searchQuery;
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(String) onSearchChanged;
  final Function(BuildContext, bool) onDateSelected;

  const SalvationDecisionList({
    super.key,
    required this.decisions,
    required this.searchQuery,
    required this.startDate,
    required this.endDate,
    required this.onSearchChanged,
    required this.onDateSelected,
  });

  @override
  State<SalvationDecisionList> createState() => _SalvationDecisionListState();
}

class _SalvationDecisionListState extends State<SalvationDecisionList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Past Decisions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.primaryGold,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search by type',
                  labelStyle: const TextStyle(color: AppTheme.primaryGold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppTheme.primaryGold),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppTheme.primaryGold,
                  ),
                ),
                onChanged: widget.onSearchChanged,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.filter_list, color: AppTheme.primaryGold),
              onPressed: () => _showFilterDialog(context),
            ),
          ],
        ),
        const SizedBox(height: 16),
        widget.decisions.isEmpty
            ? const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'No decisions found.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.decisions.length,
                itemBuilder: (context, index) =>
                    _buildDecisionCard(context, widget.decisions[index]),
              ),
      ],
    );
  }

  Widget _buildDecisionCard(BuildContext context, SalvationDecision decision) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: AppTheme.primaryGold.withOpacity(0.3)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          decision.type.label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.primaryGold,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${decision.submittedAt}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black87,
              ),
            ),
            Text(
              'Audio Included: ${decision.audioSent ? 'Yes' : 'No'}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black87,
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: AppTheme.primaryGold,
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => _buildDecisionDetails(context, decision),
          );
        },
      ),
    );
  }

  Widget _buildDecisionDetails(
    BuildContext context,
    SalvationDecision decision,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            decision.type.label,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.primaryGold,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Date: ${decision.submittedAt}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Audio Testimony: ${decision.audioSent ? 'Included' : 'Not Included'}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Close',
                style: TextStyle(color: AppTheme.primaryGold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Decisions'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Start Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                readOnly: true,
                controller: TextEditingController(
                  text: widget.startDate != null
                      ? '${widget.startDate!.year}-${widget.startDate!.month.toString().padLeft(2, '0')}-${widget.startDate!.day.toString().padLeft(2, '0')}'
                      : '',
                ),
                onTap: () => widget.onDateSelected(context, true),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'End Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                readOnly: true,
                controller: TextEditingController(
                  text: widget.endDate != null
                      ? '${widget.endDate!.year}-${widget.endDate!.month.toString().padLeft(2, '0')}-${widget.endDate!.day.toString().padLeft(2, '0')}'
                      : '',
                ),
                onTap: () => widget.onDateSelected(context, false),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                widget.onDateSelected(context, true);
                widget.onDateSelected(context, false);
                Navigator.pop(context);
              },
              child: const Text('Clear Filters'),
            ),
          ],
        );
      },
    );
  }
}
