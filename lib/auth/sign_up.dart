import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/api_providers.dart';
import '../screens/home.dart';
import 'log_in.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
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
  List<String> _selectedPrayerTimes = [];
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  final List<String> _countries = [
    'Kenya',
    'United States',
    'United Kingdom',
    'France',
    'Spain',
    'Other',
  ];

  final List<String> _timezones = [
    'Africa/Nairobi',
    'America/New_York',
    'Europe/London',
    'Europe/Paris',
    'Europe/Madrid',
    'UTC',
  ];

  final List<String> _prayerTimesOptions = [
    '05:00',
    '06:00',
    '12:00',
    '18:00',
    '21:00',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUp() async {
    if (_formKey.currentState!.validate() && _termsAccepted) {
      setState(() {
        _isLoading = true;
      });

      final params = {
        'name': _nameController.text,
        'phone': _phoneController.text,
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
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Welcome, ${user.name}!')));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign-up failed: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } else if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please accept the Terms and Conditions'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Hero(
                    tag: 'app_logo',
                    child: Image.asset(
                      'assets/icon/icon.png',
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Join JKMG',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFFB8860B),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person, color: Color(0xFFB8860B)),
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
                    value: _selectedCountry,
                    decoration: InputDecoration(labelText: 'Country'),
                    items: _countries.map((country) {
                      return DropdownMenuItem(
                        value: country,
                        child: Text(country),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCountry = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a country' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone, color: Color(0xFFB8860B)),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (!RegExp(r'^\+\d{10,15}$').hasMatch(value)) {
                        return 'Please enter a valid phone number (e.g., +1234567890)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email (Optional)',
                      prefixIcon: Icon(Icons.email, color: Color(0xFFB8860B)),
                    ),
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
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedTimezone,
                    decoration: InputDecoration(
                      labelText: 'Timezone (Optional)',
                    ),
                    items: _timezones.map((timezone) {
                      return DropdownMenuItem(
                        value: timezone,
                        child: Text(timezone),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTimezone = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock, color: Color(0xFFB8860B)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color(0xFFB8860B),
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock, color: Color(0xFFB8860B)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color(0xFFB8860B),
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_isConfirmPasswordVisible,
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
                  const SizedBox(height: 16),
                  Text(
                    'Preferred Prayer Times (Optional)',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Wrap(
                    spacing: 8.0,
                    children: _prayerTimesOptions.map((time) {
                      return ChoiceChip(
                        label: Text(time),
                        selected: _selectedPrayerTimes.contains(time),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedPrayerTimes.add(time);
                            } else {
                              _selectedPrayerTimes.remove(time);
                            }
                          });
                        },
                        selectedColor: Color(0xFFB8860B),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: _termsAccepted,
                        onChanged: (value) {
                          setState(() {
                            _termsAccepted = value ?? false;
                          });
                        },
                        activeColor: Color(0xFFB8860B),
                      ),
                      Expanded(
                        child: Text(
                          'I agree to the Terms and Conditions',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _receiveMarketing,
                        onChanged: (value) {
                          setState(() {
                            _receiveMarketing = value ?? false;
                          });
                        },
                        activeColor: Color(0xFFB8860B),
                      ),
                      Expanded(
                        child: Text(
                          'I want to receive marketing information',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _signUp,
                    style: Theme.of(context).elevatedButtonTheme.style
                        ?.copyWith(
                          minimumSize: WidgetStateProperty.all(
                            Size(double.infinity, 50),
                          ),
                        ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Sign Up'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Log In',
                          style: TextStyle(color: Color(0xFFB8860B)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
