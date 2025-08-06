import 'package:flutter/material.dart';
import 'onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _particleController;
  late AnimationController _pulseController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutBack),
      ),
    );

    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const OnboardingScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _particleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [Color(0xFF1A1A1A), Color(0xFF000000)],
          ),
        ),
        child: Stack(
          children: [
            // Background particles
            ...List.generate(20, (index) => _buildFloatingParticle(index)),

            // Animated golden rings
            Center(
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer ring
                      Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: 350,
                          height: 350,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFD4AF37).withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      // Middle ring
                      Transform.scale(
                        scale: _pulseAnimation.value * 0.8,
                        child: Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFB8860B).withOpacity(0.4),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      // Inner ring
                      Transform.scale(
                        scale: _pulseAnimation.value * 0.6,
                        child: Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFFFD700).withOpacity(0.6),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Main content
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo with glassmorphism effect
                          Hero(
                            tag: 'app_logo',
                            child: Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    const Color(0xFFFFD700).withOpacity(0.2),
                                    const Color(0xFFB8860B).withOpacity(0.1),
                                    Colors.transparent,
                                  ],
                                ),
                                border: Border.all(
                                  color: const Color(
                                    0xFFD4AF37,
                                  ).withOpacity(0.3),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFFFD700,
                                    ).withOpacity(0.2),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  "assets/icon/icon.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // App title with modern typography
                          Transform.translate(
                            offset: Offset(0, _slideAnimation.value),
                            child: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Color(0xFFFFD700),
                                  Color(0xFFD4AF37),
                                  Color(0xFFB8860B),
                                ],
                              ).createShader(bounds),
                              child: const Text(
                                'DIVINE',
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 8,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 2),
                                      blurRadius: 8,
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Subtitle with elegant styling
                          Transform.translate(
                            offset: Offset(0, _slideAnimation.value * 0.5),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(
                                    0xFFD4AF37,
                                  ).withOpacity(0.3),
                                  width: 1,
                                ),
                                color: Colors.black.withOpacity(0.3),
                              ),
                              child: Text(
                                'Transforming Lives Through God\'s Word',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: const Color(
                                    0xFFFFD700,
                                  ).withOpacity(0.9),
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),

                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingParticle(int index) {
    final random = (index * 0.1);
    return AnimatedBuilder(
      animation: _particleAnimation,
      builder: (context, child) {
        return Positioned(
          left: (MediaQuery.of(context).size.width * (0.1 + random * 0.8)),
          top:
              (MediaQuery.of(context).size.height *
              ((0.1 + random * 0.8 + _particleAnimation.value * 0.3) % 1.0)),
          child: Opacity(
            opacity: ((0.3 + (random * 0.4)) * _fadeAnimation.value).clamp(
              0.0,
              1.0,
            ),
            child: Icon(
              Icons.auto_awesome,
              size: 12 + (random * 8),
              color: Color(0xFFFFD700),
            ),
          ),
        );
      },
    );
  }
}
