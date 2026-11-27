import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';

class ForgotPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>(debugLabel: 'forgot_password_form');
  final emailController = TextEditingController();
  final isLoading = false.obs;
  final errorMessage = RxnString();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email address';
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
        // Proceed to OTP with a flag indicating it's from Forgot Password
        Get.toNamed(Routes.OTP, arguments: {
          'email': emailController.text,
          'isFromForgot': true,
        });
      });
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
