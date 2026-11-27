import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';

class ResetPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>(debugLabel: 'reset_password_form');
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final showPassword = false.obs;
  final showConfirmPassword = false.obs;

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a new password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void resetPassword() {
    errorMessage.value = null;
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        isLoading.value = false;
        // Success: Navigate to login
        Get.offAllNamed(Routes.LOGIN);
      });
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
