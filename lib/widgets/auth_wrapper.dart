import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/api_providers.dart';
import '../auth/log_in.dart';
import '../services/preference_service.dart';

/// Wraps widgets that require authentication and handles unauthenticated states
class AuthWrapper extends ConsumerWidget {
  final Widget child;
  
  const AuthWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to the current user provider
    final userAsyncValue = ref.watch(currentUserProvider);
    
    return userAsyncValue.when(
      data: (user) => child,
      loading: () => const _LoadingScreen(),
      error: (error, stack) {
        // Check if this is an authentication error
        if (error.toString().contains('Unauthenticated') || 
            error.toString().contains('401')) {
          // Clear stored session and redirect to login
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _handleAuthenticationError(context, ref);
          });
          
          // Show loading while redirecting
          return const _LoadingScreen();
        }
        
        // For other errors, show the child widget
        // (individual widgets can handle their own errors)
        return child;
      },
    );
  }
  
  Future<void> _handleAuthenticationError(BuildContext context, WidgetRef ref) async {
    try {
      // Clear user session
      await ref.read(userSessionProvider.notifier).clearUserSession();
      
      // Clear stored tokens
      final prefs = await PreferenceService.getInstance();
      await prefs.clearAuthData();
      
      // Navigate to login screen and clear all previous routes
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
        
        // Show a message about session expiry
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your session has expired. Please log in again.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // If clearing fails, still navigate to login
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A0A0A),
              Color(0xFF1A1A1A),
              Color(0xFF0A0A0A),
            ],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFFD4AF37),
                child: Icon(
                  Icons.church,
                  size: 40,
                  color: Color(0xFF0A0A0A),
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}