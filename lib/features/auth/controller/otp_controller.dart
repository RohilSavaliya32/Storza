import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../data/repositories/auth_repository.dart';

class OtpController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  
  final otpControllers = List.generate(6, (index) => TextEditingController());
  final focusNodes = List.generate(6, (index) => FocusNode());
  
  final isLoading = false.obs;
  final resendTimer = 30.obs;
  final errorMessage = RxnString();
  Timer? _timer;
  
  String email = '';
  bool isFromForgot = false;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      email = args['email'] ?? '';
      isFromForgot = args['isFromForgot'] ?? false;
    } else if (args is String) {
      email = args;
    }
    startTimer();
  }

  void startTimer() {
    resendTimer.value = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        resendTimer.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> resendOtp() async {
    if (resendTimer.value == 0) {
      errorMessage.value = null;
      try {
        await _authRepository.resendOtp(email);
        startTimer();
        SnackbarUtils.success('OTP has been resent to your email');
      } catch (e) {
        errorMessage.value = e.toString();
        // SnackbarUtils.error(errorMessage.value ?? 'Failed to resend OTP');
      }
    }
  }

  Future<void> verifyOtp() async {
    errorMessage.value = null;
    String otp = otpControllers.map((e) => e.text).join();
    
    if (otp.length < 6) {
      errorMessage.value = 'Please enter the complete 6-digit code';
      return;
    }

    isLoading.value = true;

    try {
      final response = await _authRepository.verifyOtp(email, otp);
      
      if (response.status == 'success') {
        if (isFromForgot) {
          Get.toNamed(Routes.RESET_PASSWORD, arguments: {
            'email': email,
            'otp': otp,
          });
        } else {
          SnackbarUtils.success(response.message ?? 'OTP verified successfully');
          // Token is already saved in AuthRepositoryImpl.verifyOtp via saveToken
          Get.offAllNamed(Routes.MAIN_NAVIGATION);
        }
      } else {
        errorMessage.value = response.message ?? 'Verification failed';
        // SnackbarUtils.error(errorMessage.value!);
      }
    } catch (e) {
      errorMessage.value = e.toString().contains('400') || e.toString().contains('422') 
          ? 'Invalid OTP. Please try again.' 
          : 'Something went wrong. Please try again later.';
      // SnackbarUtils.error(errorMessage.value!);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}
