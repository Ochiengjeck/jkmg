import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/onboarding/onboarding.dart';
import '../auth/log_in.dart';
import '../screens/home.dart';
import '../services/preference_service.dart';
import '../provider/api_providers.dart';
import 'auth_wrapper.dart';

class AppInitializer extends ConsumerWidget {
  const AppInitializer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<Widget>(
      future: _determineInitialScreen(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _SplashScreen();
        }
        
        return snapshot.data ?? const OnboardingScreen();
      },
    );
  }

  Future<Widget> _determineInitialScreen(WidgetRef ref) async {
    try {
      final prefs = await PreferenceService.getInstance();
      
      // Check if this is the first launch
      if (prefs.isFirstLaunch()) {
        return const OnboardingScreen();
      }
      
      // Check if user has a valid session
      if (prefs.isLoggedIn) {
        // Try to load the user session
        await ref.read(userSessionProvider.notifier).loadUserSession();
        
        // Give a small delay to allow the state to update
        await Future.delayed(const Duration(milliseconds: 100));
        
        final user = ref.read(userSessionProvider);
        
        if (user != null) {
          return const AuthWrapper(child: HomeScreen());
        }
      }
      
      // Default to login screen
      return const LoginScreen();
      
    } catch (e) {
      // On any error, default to login screen (not onboarding since onboarding might have been completed)
      final prefs = await PreferenceService.getInstance();
      if (prefs.isFirstLaunch()) {
        return const OnboardingScreen();
      } else {
        return const LoginScreen();
      }
    }
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

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
              // App Logo
              Hero(
                tag: 'app_logo',
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Color(0xFFD4AF37),
                  child: Icon(
                    Icons.church,
                    size: 60,
                    color: Color(0xFF0A0A0A),
                  ),
                ),
              ),
              
              SizedBox(height: 32),
              
              // Loading indicator
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
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