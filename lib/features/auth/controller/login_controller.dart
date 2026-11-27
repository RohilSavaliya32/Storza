import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../data/repositories/auth_repository.dart';
import '../../albums/controller/albums_controller.dart';
import '../../photos/controller/photos_controller.dart';
import '../../videos/controller/video_controller.dart';
import 'auth_controller.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository;
  
  final formKey = GlobalKey<FormState>(debugLabel: 'login_form');
  final emailController = TextEditingController();
  final securityCodeController = TextEditingController();
  final obscurePassword = true.obs;
  final isLoading = false.obs;
  
  final emailError = RxnString();
  final securityCodeError = RxnString();

  final _authController = Get.find<AuthController>();

  LoginController(this._authRepository);

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(() {
      if (emailError.value != null) emailError.value = null;
    });
    securityCodeController.addListener(() {
      if (securityCodeError.value != null) securityCodeError.value = null;
    });
  }

  void togglePasswordVisibility() => obscurePassword.value = !obscurePassword.value;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validateSecurityCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your security code';
    }
    return null;
  }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        final response = await _authRepository.login(
          emailController.text.trim(),
          securityCodeController.text.trim(),
        );

        if (response.status == 'success') {
          _authController.setUser(response.user);
          
          try {
            if (Get.isRegistered<AlbumsController>()) {
              Get.find<AlbumsController>().fetchAlbums();
            }
            if (Get.isRegistered<PhotosController>()) {
              Get.find<PhotosController>().fetchPhotos();
            }
            if (Get.isRegistered<VideoController>()) {
              Get.find<VideoController>().fetchVideos();
            }
          } catch (e) {
            debugPrint('Error pre-fetching data: $e');
          }

          SnackbarUtils.success(response.message ?? 'Login successful');
          Get.offAllNamed(Routes.MAIN_NAVIGATION);
        } else {
          // SnackbarUtils.error(response.message ?? 'Login failed');
        }
      } catch (e) {
        String errorMessage = 'An error occurred';
        if (e is DioException) {
          errorMessage = e.response?.data['message'] ?? e.message ?? 'Network error';
        }
        // SnackbarUtils.error(errorMessage);
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    securityCodeController.dispose();
    super.onClose();
  }
}
