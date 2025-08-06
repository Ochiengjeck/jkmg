import 'package:flutter/material.dart';
import '../../auth/log_in.dart';
import 'onboarding_data.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late AnimationController _floatingController;
  late AnimationController _particleController;
  late AnimationController _cardController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _cardAnimation;

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _particleController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _cardController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 80.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutBack),
      ),
    );

    _floatingAnimation = Tween<double>(begin: -15.0, end: 15.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );

    _cardAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.elasticOut),
    );

    _animationController.forward();
    _cardController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _floatingController.dispose();
    _particleController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOutCubic,
                    ),
                  ),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _skipToLogin() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF000000), Color(0xFF1A1A1A), Color(0xFF000000)],
          ),
        ),
        child: Stack(
          children: [
            // Background particles
            ...List.generate(15, (index) => _buildBackgroundParticle(index)),

            // Page view
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
                _animationController.reset();
                _cardController.reset();
                _animationController.forward();
                _cardController.forward();
              },
              itemCount: onboardingData.length,
              itemBuilder: (context, index) {
                return _buildOnboardingPage(onboardingData[index]);
              },
            ),

            // Skip button with glassmorphism
            Positioned(
              top: 40,
              right: 12,
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: const Color(0xFFD4AF37).withOpacity(0.3),
                          width: 1,
                        ),
                        color: Colors.black.withOpacity(0.3),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFD700).withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(25),
                          onTap: _skipToLogin,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                color: Color(0xFFD4AF37),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom navigation with modern design
            Positioned(
              bottom: 12,
              left: 24,
              right: 24,
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: const Color(0xFFD4AF37).withOpacity(0.2),
                          width: 1,
                        ),
                        color: Colors.black.withOpacity(0.4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Previous button
                          AnimatedOpacity(
                            opacity: _currentPage > 0 ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(
                                    0xFFD4AF37,
                                  ).withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: IconButton(
                                onPressed: _currentPage > 0
                                    ? _previousPage
                                    : null,
                                icon: const Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Color(0xFFD4AF37),
                                  size: 20,
                                ),
                              ),
                            ),
                          ),

                          // Page indicators
                          Row(
                            children: List.generate(
                              onboardingData.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 400),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                height: 8,
                                width: _currentPage == index ? 32 : 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  gradient: _currentPage == index
                                      ? const LinearGradient(
                                          colors: [
                                            Color(0xFFFFD700),
                                            Color(0xFFD4AF37),
                                          ],
                                        )
                                      : null,
                                  color: _currentPage == index
                                      ? null
                                      : Colors.white.withOpacity(0.3),
                                  boxShadow: _currentPage == index
                                      ? [
                                          BoxShadow(
                                            color: const Color(
                                              0xFFFFD700,
                                            ).withOpacity(0.5),
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                          ),
                                        ]
                                      : null,
                                ),
                              ),
                            ),
                          ),

                          // Next button
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFD700), Color(0xFFD4AF37)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFFFD700,
                                  ).withOpacity(0.4),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: _nextPage,
                              icon: Icon(
                                _currentPage == onboardingData.length - 1
                                    ? Icons.check_rounded
                                    : Icons.arrow_forward_ios_rounded,
                                color: Colors.black,
                                size: 22,
                              ),
                            ),
                          ),
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

  Widget _buildOnboardingPage(OnboardingData data) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const Spacer(flex: 2),

            // Image with modern card design
            AnimatedBuilder(
              animation: _cardAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _cardAnimation.value,
                  child: AnimatedBuilder(
                    animation: _floatingAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatingAnimation.value),
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            gradient: RadialGradient(
                              center: Alignment.topLeft,
                              radius: 1.5,
                              colors: [
                                const Color(0xFFFFD700).withOpacity(0.1),
                                const Color(0xFFD4AF37).withOpacity(0.05),
                                Colors.transparent,
                              ],
                            ),
                            border: Border.all(
                              color: const Color(0xFFD4AF37).withOpacity(0.3),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFFD700).withOpacity(0.2),
                                blurRadius: 30,
                                spreadRadius: 5,
                                offset: const Offset(0, 15),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(38),
                            child: Image.asset(
                              data.imagePath,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            const Spacer(flex: 1),

            // Text content with enhanced styling
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: Transform.translate(
                    offset: Offset(0, _slideAnimation.value * 0.5),
                    child: Column(
                      children: [
                        // Title with gradient text
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xFFFFD700),
                              Color(0xFFD4AF37),
                              Color(0xFFB8860B),
                            ],
                          ).createShader(bounds),
                          child: Text(
                            data.title,
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.5,
                              height: 1.1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Subtitle
                        Text(
                          data.subtitle,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFFFD700).withOpacity(0.9),
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 24),

                        // Description in a card
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFD4AF37).withOpacity(0.2),
                              width: 1,
                            ),
                            color: Colors.black.withOpacity(0.3),
                          ),
                          child: Text(
                            data.description,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                              height: 1.6,
                              letterSpacing: 0.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundParticle(int index) {
    final random = (index * 0.13);
    return AnimatedBuilder(
      animation: _particleAnimation,
      builder: (context, child) {
        return Positioned(
          left: (MediaQuery.of(context).size.width * (0.1 + random * 0.8)),
          top:
              (MediaQuery.of(context).size.height *
              ((0.1 + random * 0.8 + _particleAnimation.value * 0.2) % 1.0)),
          child: Opacity(
            opacity: (0.2 + (random * 0.3)) * _fadeAnimation.value,
            child: Icon(
              [
                Icons.auto_awesome,
                Icons.star_outline,
                Icons.fiber_manual_record,
                Icons.brightness_1_outlined,
              ][index % 4],
              size: 8 + (random * 12),
              color: Color(0xFFFFD700).withOpacity(0.4),
            ),
          ),
        );
      },
    );
  }
}

// Keep your existing OnboardingData and ParticleData classes
class OnboardingData {
  final String title;
  final String subtitle;
  final String description;
  final String imagePath;
  final LinearGradient gradient;
  final List<ParticleData> particles;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imagePath,
    required this.gradient,
    required this.particles,
  });
}

class ParticleData {
  final IconData icon;
  final Offset position;
  final double speed;

  ParticleData(this.icon, this.position, this.speed);
}
