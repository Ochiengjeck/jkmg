import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/api_providers.dart';
import '../screens/home.dart';
import 'forgot_password.dart';
import 'sign_up.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _termsAccepted = false;
  bool _receiveMarketing = false;
  String? _selectedCountry;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final List<String> _countries = [
    'Kenya',
    'United States',
    'United Kingdom',
    'France',
    'Spain',
    'Other',
  ];

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final params = {
        'phone': _phoneController.text,
        'password': _passwordController.text,
      };

      try {
        final user = await ref.read(loginProvider(params).future);
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Welcome back, ${user.name}!')));
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
            content: Text('Login failed: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
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
                    'Welcome Back to JKMG',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFFB8860B),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      hint: Text("+254712345678"),
                      hintStyle: TextStyle(
                        color: const Color.fromARGB(255, 86, 85, 85),
                        fontStyle: FontStyle.italic,
                      ),
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
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Row(
                  //   children: [
                  //     Checkbox(
                  //       value: _termsAccepted,
                  //       onChanged: (value) {
                  //         setState(() {
                  //           _termsAccepted = value ?? false;
                  //         });
                  //       },
                  //       activeColor: Color(0xFFB8860B),
                  //     ),
                  //     Expanded(
                  //       child: Text(
                  //         'I agree to the Terms and Conditions',
                  //         style: Theme.of(context).textTheme.bodyMedium,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Row(
                  //   children: [
                  //     Checkbox(
                  //       value: _receiveMarketing,
                  //       onChanged: (value) {
                  //         setState(() {
                  //           _receiveMarketing = value ?? false;
                  //         });
                  //       },
                  //       activeColor: Color(0xFFB8860B),
                  //     ),
                  //     Expanded(
                  //       child: Text(
                  //         'I want to receive marketing information',
                  //         style: Theme.of(context).textTheme.bodyMedium,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: Theme.of(context).elevatedButtonTheme.style
                        ?.copyWith(
                          minimumSize: WidgetStateProperty.all(
                            Size(double.infinity, 50),
                          ),
                        ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Log In'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Color(0xFFB8860B)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don’t have an account? ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign Up',
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
