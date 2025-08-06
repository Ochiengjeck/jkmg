import 'package:flutter/material.dart';
import 'constants.dart';

void navigateToPage(int pageIndex) {
  pageController.animateToPage(
    pageIndex,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
  );
}
