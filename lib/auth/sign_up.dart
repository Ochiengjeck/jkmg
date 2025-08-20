import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jkmg/utils/app_theme.dart';

import '../provider/api_providers.dart';
import '../screens/home.dart';
import '../utils/country_codes.dart';
import '../widgets/phone_input_field.dart';
import 'log_in.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _termsAccepted = false;
  bool _receiveMarketing = false;
  String? _selectedCountry;
  String? _selectedTimezone;
  final List<String> _selectedPrayerTimes = [];
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  CountryCode _selectedCountryCode = CountryCodes.defaultCountry;

  late AnimationController _animationController;
  late AnimationController _floatingController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _floatingAnimation;

  final List<String> _countries = [
    'Afghanistan',
    'Albania',
    'Algeria',
    'Andorra',
    'Angola',
    'Argentina',
    'Armenia',
    'Australia',
    'Austria',
    'Azerbaijan',
    'Bahamas',
    'Bahrain',
    'Bangladesh',
    'Barbados',
    'Belarus',
    'Belgium',
    'Belize',
    'Benin',
    'Bhutan',
    'Bolivia',
    'Bosnia and Herzegovina',
    'Botswana',
    'Brazil',
    'Brunei',
    'Bulgaria',
    'Burkina Faso',
    'Burundi',
    'Cambodia',
    'Cameroon',
    'Canada',
    'Cape Verde',
    'Central African Republic',
    'Chad',
    'Chile',
    'China',
    'Colombia',
    'Comoros',
    'Congo',
    'Costa Rica',
    'Croatia',
    'Cuba',
    'Cyprus',
    'Czech Republic',
    'Denmark',
    'Djibouti',
    'Dominica',
    'Dominican Republic',
    'East Timor',
    'Ecuador',
    'Egypt',
    'El Salvador',
    'Equatorial Guinea',
    'Eritrea',
    'Estonia',
    'Ethiopia',
    'Fiji',
    'Finland',
    'France',
    'Gabon',
    'Gambia',
    'Georgia',
    'Germany',
    'Ghana',
    'Greece',
    'Grenada',
    'Guatemala',
    'Guinea',
    'Guinea-Bissau',
    'Guyana',
    'Haiti',
    'Honduras',
    'Hungary',
    'Iceland',
    'India',
    'Indonesia',
    'Iran',
    'Iraq',
    'Ireland',
    'Israel',
    'Italy',
    'Jamaica',
    'Japan',
    'Jordan',
    'Kazakhstan',
    'Kenya',
    'Kiribati',
    'North Korea',
    'South Korea',
    'Kuwait',
    'Kyrgyzstan',
    'Laos',
    'Latvia',
    'Lebanon',
    'Lesotho',
    'Liberia',
    'Libya',
    'Liechtenstein',
    'Lithuania',
    'Luxembourg',
    'Macedonia',
    'Madagascar',
    'Malawi',
    'Malaysia',
    'Maldives',
    'Mali',
    'Malta',
    'Marshall Islands',
    'Mauritania',
    'Mauritius',
    'Mexico',
    'Micronesia',
    'Moldova',
    'Monaco',
    'Mongolia',
    'Montenegro',
    'Morocco',
    'Mozambique',
    'Myanmar',
    'Namibia',
    'Nauru',
    'Nepal',
    'Netherlands',
    'New Zealand',
    'Nicaragua',
    'Niger',
    'Nigeria',
    'Norway',
    'Oman',
    'Pakistan',
    'Palau',
    'Panama',
    'Papua New Guinea',
    'Paraguay',
    'Peru',
    'Philippines',
    'Poland',
    'Portugal',
    'Qatar',
    'Romania',
    'Russia',
    'Rwanda',
    'Saint Kitts and Nevis',
    'Saint Lucia',
    'Saint Vincent and the Grenadines',
    'Samoa',
    'San Marino',
    'Sao Tome and Principe',
    'Saudi Arabia',
    'Senegal',
    'Serbia',
    'Seychelles',
    'Sierra Leone',
    'Singapore',
    'Slovakia',
    'Slovenia',
    'Solomon Islands',
    'Somalia',
    'South Africa',
    'South Sudan',
    'Spain',
    'Sri Lanka',
    'Sudan',
    'Suriname',
    'Swaziland',
    'Sweden',
    'Switzerland',
    'Syria',
    'Taiwan',
    'Tajikistan',
    'Tanzania',
    'Thailand',
    'Togo',
    'Tonga',
    'Trinidad and Tobago',
    'Tunisia',
    'Turkey',
    'Turkmenistan',
    'Tuvalu',
    'Uganda',
    'Ukraine',
    'United Arab Emirates',
    'United Kingdom',
    'United States',
    'Uruguay',
    'Uzbekistan',
    'Vanuatu',
    'Vatican City',
    'Venezuela',
    'Vietnam',
    'Yemen',
    'Zambia',
    'Zimbabwe',
  ];

  final List<String> _timezones = [
    'UTC-12:00 (Baker Island)',
    'UTC-11:00 (American Samoa)',
    'UTC-10:00 (Hawaii)',
    'UTC-09:30 (Marquesas)',
    'UTC-09:00 (Alaska)',
    'UTC-08:00 (Pacific)',
    'UTC-07:00 (Mountain)',
    'UTC-06:00 (Central)',
    'UTC-05:00 (Eastern)',
    'UTC-04:00 (Atlantic)',
    'UTC-03:30 (Newfoundland)',
    'UTC-03:00 (Argentina)',
    'UTC-02:00 (South Georgia)',
    'UTC-01:00 (Azores)',
    'UTC+00:00 (London)',
    'UTC+01:00 (Central Europe)',
    'UTC+02:00 (Eastern Europe)',
    'UTC+03:00 (Moscow)',
    'UTC+03:30 (Iran)',
    'UTC+04:00 (Gulf)',
    'UTC+04:30 (Afghanistan)',
    'UTC+05:00 (Pakistan)',
    'UTC+05:30 (India)',
    'UTC+05:45 (Nepal)',
    'UTC+06:00 (Bangladesh)',
    'UTC+06:30 (Myanmar)',
    'UTC+07:00 (Thailand)',
    'UTC+08:00 (China)',
    'UTC+08:30 (North Korea)',
    'UTC+09:00 (Japan)',
    'UTC+09:30 (Australia Central)',
    'UTC+10:00 (Australia Eastern)',
    'UTC+10:30 (Lord Howe)',
    'UTC+11:00 (Solomon Islands)',
    'UTC+12:00 (New Zealand)',
    'UTC+12:45 (Chatham)',
    'UTC+13:00 (Tonga)',
    'UTC+14:00 (Line Islands)',
  ];

  final List<String> _prayerTimesOptions = ['06:00', '12:00', '18:00', '00:00'];

  final Map<String, String> _prayerTimeLabels = {
    '06:00': '6 AM',
    '12:00': '12 PM',
    '18:00': '6 PM',
    '00:00': 'Deep in Prayer (12 AM)',
  };

  @override
  void initState() {
    super.initState();
    
    // Set Kenya as default country
    _selectedCountry = 'Kenya';
    
    // Auto-select all prayer times by default
    _selectedPrayerTimes.addAll(_prayerTimesOptions);
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutBack),
      ),
    );

    _floatingAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  void _signUp() async {
    if (_formKey.currentState!.validate() && _termsAccepted) {
      setState(() {
        _isLoading = true;
      });

      final params = {
        'name': _nameController.text,
        'phone': '${_selectedCountryCode.dialCode}${_phoneController.text.replaceAll(RegExp(r'^\+?\d{1,4}'), '')}',
        'country': _selectedCountry!,
        'password': _passwordController.text,
        'password_confirmation': _confirmPasswordController.text,
        if (_emailController.text.isNotEmpty) 'email': _emailController.text,
        if (_selectedTimezone != null) 'timezone': _selectedTimezone,
        if (_selectedPrayerTimes.isNotEmpty)
          'prayer_times': _selectedPrayerTimes,
      };

      try {
        final user = await ref.read(registerProvider(params).future);
        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          // Store user session persistently
          await ref.read(userSessionProvider.notifier).saveUserSession(user);

          _showSuccessSnackBar('Welcome, ${user.name}!');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          _showSmartErrorSnackBar(e.toString());
        }
      }
    } else if (!_termsAccepted) {
      _showErrorSnackBar('Please accept the Terms and Conditions');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSmartErrorSnackBar(String error) {
    String userFriendlyMessage;
    Color backgroundColor = Colors.red;
    IconData icon = Icons.error_outline;

    if (error.contains('SocketException') || 
        error.contains('Failed host lookup') || 
        error.contains('Network is unreachable') ||
        error.contains('No address associated with hostname')) {
      userFriendlyMessage = 'No internet connection. Please check your network and try again.';
      icon = Icons.wifi_off;
    } else if (error.contains('TimeoutException') || 
               error.contains('Connection timed out')) {
      userFriendlyMessage = 'Connection timeout. Please check your internet and try again.';
      icon = Icons.access_time;
    } else if (error.contains('phone has already been taken') || 
               error.contains('email has already been taken') ||
               error.contains('already exists')) {
      userFriendlyMessage = 'This phone number or email is already registered. Try logging in instead.';
      backgroundColor = Colors.orange;
      icon = Icons.person_outline;
    } else if (error.contains('validation failed') || 
               error.contains('422')) {
      userFriendlyMessage = 'Please check your information and try again.';
      backgroundColor = Colors.orange;
      icon = Icons.edit_outlined;
    } else if (error.contains('Server error') || 
               error.contains('500') || 
               error.contains('502') || 
               error.contains('503')) {
      userFriendlyMessage = 'Server temporarily unavailable. Please try again later.';
      icon = Icons.cloud_off;
    } else {
      userFriendlyMessage = 'Registration failed. Please try again.';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                userFriendlyMessage,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.richBlack,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.richBlack, Color(0xFF1A1A1A), AppTheme.richBlack],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),

                          // App Logo with floating animation
                          AnimatedBuilder(
                            animation: _floatingAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, _floatingAnimation.value),
                                child: Hero(
                                  tag: 'app_logo',
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      gradient: RadialGradient(
                                        colors: [
                                          AppTheme.primaryGold.withOpacity(0.3),
                                          AppTheme.primaryGold.withOpacity(0.1),
                                          Colors.transparent,
                                        ],
                                      ),
                                      border: Border.all(
                                        color: AppTheme.primaryGold.withOpacity(
                                          0.3,
                                        ),
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.primaryGold
                                              .withOpacity(0.2),
                                          blurRadius: 20,
                                          spreadRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(23),
                                      child: Image.asset(
                                        'assets/icon/icon.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 32),

                          // Join Title
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                AppTheme.primaryGold,
                                Color(0xFFD4AF37),
                                Color(0xFFB8860B),
                              ],
                            ).createShader(bounds),
                            child: const Text(
                              'Join JKMG',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'Create your account to begin your spiritual journey',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 32),

                          // Form Fields
                          _buildTextField(
                            controller: _nameController,
                            label: 'Full Name',
                            icon: Icons.person_outline,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your full name';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          _buildDropdownField(
                            value: _selectedCountry,
                            label: 'Country',
                            icon: Icons.public,
                            items: _countries,
                            onChanged: (value) =>
                                setState(() => _selectedCountry = value),
                            validator: (value) => value == null
                                ? 'Please select a country'
                                : null,
                          ),

                          const SizedBox(height: 20),

                          PhoneInputField(
                            controller: _phoneController,
                            onCountryChanged: (country) {
                              setState(() {
                                _selectedCountryCode = country;
                              });
                            },
                          ),

                          const SizedBox(height: 20),

                          _buildTextField(
                            controller: _emailController,
                            label: 'Email (Optional)',
                            hint: 'example@email.com',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          _buildDropdownField(
                            value: _selectedTimezone,
                            label: 'Timezone (Optional)',
                            icon: Icons.schedule,
                            items: _timezones,
                            onChanged: (value) =>
                                setState(() => _selectedTimezone = value),
                            isOptional: true,
                          ),

                          const SizedBox(height: 20),

                          _buildTextField(
                            controller: _passwordController,
                            label: 'Password',
                            icon: Icons.lock_outline,
                            obscureText: !_isPasswordVisible,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppTheme.primaryGold.withOpacity(0.7),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          _buildTextField(
                            controller: _confirmPasswordController,
                            label: 'Confirm Password',
                            icon: Icons.lock_outline,
                            obscureText: !_isConfirmPasswordVisible,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppTheme.primaryGold.withOpacity(0.7),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 32),

                          // Prayer Times Section
                          _buildPrayerTimesSection(),

                          const SizedBox(height: 32),

                          // Terms and Marketing
                          _buildCheckboxRow(
                            value: _termsAccepted,
                            onChanged: (value) =>
                                setState(() => _termsAccepted = value ?? false),
                            text: 'I agree to the Terms and Conditions',
                            isRequired: true,
                          ),

                          const SizedBox(height: 12),

                          _buildCheckboxRow(
                            value: _receiveMarketing,
                            onChanged: (value) => setState(
                              () => _receiveMarketing = value ?? false,
                            ),
                            text: 'I want to receive marketing information',
                          ),

                          const SizedBox(height: 32),

                          // Sign Up Button
                          _buildPrimaryButton(
                            onPressed: _isLoading ? null : _signUp,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppTheme.richBlack,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Create Account',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.richBlack,
                                    ),
                                  ),
                          ),

                          const SizedBox(height: 32),

                          // Login Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 14,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: AppTheme.primaryGold,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: AppTheme.primaryGold.withOpacity(0.7),
          fontSize: 14,
        ),
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.4),
          fontSize: 14,
        ),
        prefixIcon: Icon(
          icon,
          color: AppTheme.primaryGold.withOpacity(0.7),
          size: 20,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.black.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppTheme.primaryGold.withOpacity(0.3),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppTheme.primaryGold.withOpacity(0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppTheme.primaryGold, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required String label,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
    bool isOptional = false,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      dropdownColor: const Color(0xFF2A2A2A),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: AppTheme.primaryGold.withOpacity(0.7),
          fontSize: 14,
        ),
        prefixIcon: Icon(
          icon,
          color: AppTheme.primaryGold.withOpacity(0.7),
          size: 20,
        ),
        filled: true,
        fillColor: Colors.black.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppTheme.primaryGold.withOpacity(0.3),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppTheme.primaryGold.withOpacity(0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppTheme.primaryGold, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item, style: const TextStyle(color: Colors.white)),
        );
      }).toList(),
      onChanged: onChanged,
      icon: Icon(
        Icons.arrow_drop_down,
        color: AppTheme.primaryGold.withOpacity(0.7),
      ),
    );
  }

  Widget _buildPrayerTimesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryGold.withOpacity(0.2),

          width: 1,
        ),
        color: Colors.black.withOpacity(0.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.schedule,
                  color: AppTheme.primaryGold,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Prayer Time',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,

                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'All prayer times are selected by default. Tap to customize your schedule.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            children: _prayerTimesOptions.map((time) {
              final isSelected = _selectedPrayerTimes.contains(time);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedPrayerTimes.remove(time);
                    } else {
                      _selectedPrayerTimes.add(time);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [AppTheme.primaryGold, Color(0xFFD4AF37)],
                          )
                        : null,
                    color: isSelected ? null : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryGold
                          : AppTheme.primaryGold.withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppTheme.primaryGold.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? AppTheme.richBlack : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _prayerTimeLabels[time] ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? AppTheme.richBlack.withOpacity(0.7)
                              : Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxRow({
    required bool value,
    required void Function(bool?) onChanged,
    required String text,
    bool isRequired = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: AppTheme.primaryGold.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Transform.scale(
            scale: 0.9,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: AppTheme.primaryGold,
              checkColor: AppTheme.richBlack,

              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
              height: 1.4,
            ),
          ),
        ),
        if (isRequired)
          Text(
            ' *',
            style: TextStyle(fontSize: 14, color: Colors.red.withOpacity(0.7)),
          ),
      ],
    );
  }

  Widget _buildPrimaryButton({
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: onPressed != null
            ? const LinearGradient(
                colors: [AppTheme.primaryGold, Color(0xFFD4AF37)],
              )
            : null,
        color: onPressed == null ? Colors.grey.withOpacity(0.3) : null,
        boxShadow: onPressed != null
            ? [
                BoxShadow(
                  color: AppTheme.primaryGold.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: child,
      ),
    );
  }
}
