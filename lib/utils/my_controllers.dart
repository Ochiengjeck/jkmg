import 'package:flutter/material.dart';

class MyControllers {
  // Login page controllers
  static TextEditingController loginUsernameController() => TextEditingController();
  static TextEditingController loginPasswordController() => TextEditingController();

  // Sign-up page controllers
  static TextEditingController signUpFirstNameController() => TextEditingController();
  static TextEditingController signUpLastNameController() => TextEditingController();
  static TextEditingController signUpUsernameController() => TextEditingController();
  static TextEditingController signUpEmailController() => TextEditingController();
  static TextEditingController signUpPhoneController() => TextEditingController();
  static TextEditingController signUpPasswordController() => TextEditingController();
  static TextEditingController signUpConfirmPasswordController() => TextEditingController();

  // Forgot password page controller
  static TextEditingController forgotPasswordEmailController() => TextEditingController();

  // Dispose controllers to prevent memory leaks
  static void disposeControllers(List<TextEditingController> controllers) {
    for (var controller in controllers) {
      controller.dispose();
    }
  }
}
