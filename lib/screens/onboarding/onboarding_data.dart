import 'package:flutter/material.dart';

import 'onboarding.dart';

final List<OnboardingData> onboardingData = [
  OnboardingData(
    title: "Welcome to JKMG",
    subtitle: "Grow in God's Word",
    description:
        "Join a global community to deepen your faith through prayer, teachings, and fellowship led by Rev. Julian Kyula.",
    imagePath: "assets/icon/icon.png",
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF000000), Color(0xFFB8860B)],
    ),
    particles: [
      ParticleData(Icons.favorite, const Offset(0.1, 0.2), 2.0),
      ParticleData(Icons.book, const Offset(0.8, 0.1), 1.5),
      ParticleData(Icons.star, const Offset(0.2, 0.7), 1.8),
      ParticleData(Icons.church, const Offset(0.9, 0.6), 2.2),
    ],
  ),
  OnboardingData(
    title: "Rhema Prayer Plan",
    subtitle: "Pray with Purpose",
    description:
        "Engage in daily prayer every 6 hours and join powerful midnight sessions for spiritual growth.",
    imagePath: "assets/icon/icon.png",
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF000000), Color(0xFFB8860B)],
    ),
    particles: [
      ParticleData(Icons.handshake, const Offset(0.15, 0.3), 1.8),
      ParticleData(Icons.book, const Offset(0.7, 0.2), 2.1),
      ParticleData(Icons.favorite, const Offset(0.3, 0.8), 1.6),
      ParticleData(Icons.church, const Offset(0.85, 0.7), 1.9),
    ],
  ),
  OnboardingData(
    title: "Salvation & Discipleship",
    subtitle: "Find Your Path",
    description:
        "Accept Christ, rededicate your life, or grow through resources and counseling in the Salvation Corner.",
    imagePath: "assets/icon/icon.png",
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF000000), Color(0xFFB8860B)],
    ),
    particles: [
      ParticleData(Icons.star, const Offset(0.1, 0.25), 2.0),
      ParticleData(Icons.book, const Offset(0.8, 0.15), 1.7),
      ParticleData(Icons.favorite, const Offset(0.25, 0.75), 1.9),
      ParticleData(Icons.light, const Offset(0.9, 0.65), 2.3),
    ],
  ),
  OnboardingData(
    title: "Global Community",
    subtitle: "Connect & Serve",
    description:
        "Participate in Rhema Feast, RXP, and share testimonies to unite with believers worldwide.",
    imagePath: "assets/icon/icon.png",
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF000000), Color(0xFFB8860B)],
    ),
    particles: [
      ParticleData(Icons.calendar_today, const Offset(0.12, 0.28), 1.8),
      ParticleData(Icons.church, const Offset(0.75, 0.18), 2.0),
      ParticleData(Icons.event, const Offset(0.2, 0.72), 1.6),
      ParticleData(Icons.people, const Offset(0.88, 0.68), 2.1),
    ],
  ),
];
