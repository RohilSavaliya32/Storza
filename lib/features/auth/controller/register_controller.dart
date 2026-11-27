import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../data/repositories/auth_repository.dart';
import '../data/models/login_response.dart';
import 'auth_controller.dart';

class RegisterController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final _authController = Get.find<AuthController>();

  final formKey = GlobalKey<FormState>(debugLabel: 'register_form');
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final referralCodeController = TextEditingController();
  
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final isLoading = false.obs;
  final Rxn<File> profilePhoto = Rxn<File>();
  
  int _permissionDeniedCount = 0;
  final _picker = ImagePicker();

  void togglePasswordVisibility() => obscurePassword.value = !obscurePassword.value;
  void toggleConfirmPasswordVisibility() => obscureConfirmPassword.value = !obscureConfirmPassword.value;

  Future<void> pickImage() async {
    try {
      PermissionStatus status;
      if (Platform.isAndroid) {
        status = await Permission.photos.request();
        if (status.isDenied && !status.isPermanentlyDenied) {
           status = await Permission.storage.request();
        }
      } else {
        status = await Permission.photos.request();
      }

      if (status.isGranted || status.isLimited) {
        _permissionDeniedCount = 0;
        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          profilePhoto.value = File(image.path);
        }
      } else {
        _permissionDeniedCount++;
        if (_permissionDeniedCount >= 3 || status.isPermanentlyDenied) {
          _showPermissionDialog();
        }
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void _showPermissionDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text("Permission Required"),
        content: const Text("Profile photo requires gallery access. Please enable it in the app settings to continue."),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel", style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text("Open Settings", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your name';
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    if (!GetUtils.isEmail(value)) return 'Please enter a valid email address';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != passwordController.text) return 'Passwords do not match';
    return null;
  }

  void clearFields() {
    usernameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    referralCodeController.clear();
    profilePhoto.value = null;
  }

  Future<void> register() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        final response = await _authRepository.register(
          name: usernameController.text,
          email: emailController.text,
          password: passwordController.text,
          passwordConfirmation: confirmPasswordController.text,
          referralCode: referralCodeController.text.isNotEmpty ? referralCodeController.text : null,
        );

        if (response.status == 'success') {
          // Use response.user or response.dataUser which are both mapped in LoginResponse
          final userData = response.user ?? response.dataUser;
          
          if (userData != null) {
            final user = User(
              id: userData.id,
              name: userData.name,
              email: userData.email,
              profilePhotoPath: profilePhoto.value?.path ?? userData.profilePhotoPath,
              referralCode: userData.referralCode,
              status: userData.status,
            );
            _authController.setUser(user);
          }

          SnackbarUtils.success(response.message ?? 'Registered successfully');

          final email = emailController.text;
          clearFields();

          Get.toNamed(Routes.OTP, arguments: {
            'email': email,
            'isFromForgot': false,
          });
        }
      } catch (e) {
        // SnackbarUtils.error(e.toString());
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    referralCodeController.dispose();
    super.onClose();
  }
}
