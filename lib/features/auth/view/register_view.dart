import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../controller/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Text(
          'Create Account',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    Obx(() => Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.Card_Color,
                        shape: BoxShape.circle,
                        image: controller.profilePhoto.value != null
                            ? DecorationImage(
                                image: FileImage(controller.profilePhoto.value!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: controller.profilePhoto.value == null
                          ? const Icon(Icons.person_outline, size: 50, color: AppColors.primary)
                          : null,
                    )),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                          onPressed: controller.pickImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'User name',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              const SizedBox(height: 8),
              AppTextField(
                controller: controller.usernameController,
                hintText: 'Enter your name',
                prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
                validator: controller.validateUsername,
              ),
              const SizedBox(height: 20),
              const Text(
                'Email',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              const SizedBox(height: 8),
              AppTextField(
                controller: controller.emailController,
                hintText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary),
                validator: controller.validateEmail,
              ),
              const SizedBox(height: 20),
              const Text(
                'Password',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              const SizedBox(height: 8),
              Obx(() => AppTextField(
                controller: controller.passwordController,
                hintText: 'Enter your password',
                obscureText: controller.obscurePassword.value,
                prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
                validator: controller.validatePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.obscurePassword.value ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
              )),
              const SizedBox(height: 20),
              const Text(
                'Confirm Password',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              const SizedBox(height: 8),
              Obx(() => AppTextField(
                controller: controller.confirmPasswordController,
                hintText: 'Confirm your password',
                obscureText: controller.obscureConfirmPassword.value,
                prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
                validator: controller.validateConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.obscureConfirmPassword.value ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: controller.toggleConfirmPasswordVisibility,
                ),
              )),
              const SizedBox(height: 20),
              const Text(
                'Referral Code (Optional)',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              const SizedBox(height: 8),
              AppTextField(
                controller: controller.referralCodeController,
                hintText: 'Enter referral code',
                prefixIcon: const Icon(Icons.card_giftcard, color: AppColors.primary),
              ),
              const SizedBox(height: 32),
              Obx(() => AppButton(
                text: 'Register',
                isLoading: controller.isLoading.value,
                onPressed: controller.register,
              )),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
