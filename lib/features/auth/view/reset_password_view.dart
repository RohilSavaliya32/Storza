import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../controller/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Reset Password',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Create a new password for your account.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'New Password',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => AppTextField(
                controller: controller.passwordController,
                hintText: 'Enter new password',
                obscureText: !controller.showPassword.value,
                prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.showPassword.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () => controller.showPassword.toggle(),
                ),
                validator: controller.validatePassword,
              )),
              const SizedBox(height: 20),
              const Text(
                'Confirm Password',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => AppTextField(
                controller: controller.confirmPasswordController,
                hintText: 'Confirm new password',
                obscureText: !controller.showConfirmPassword.value,
                prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.showConfirmPassword.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () => controller.showConfirmPassword.toggle(),
                ),
                validator: controller.validateConfirmPassword,
              )),
              Obx(() => controller.errorMessage.value != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        controller.errorMessage.value!,
                        style: const TextStyle(color: AppColors.red, fontSize: 13),
                      ),
                    )
                  : const SizedBox.shrink()),
              const SizedBox(height: 40),
              Obx(() => AppButton(
                text: 'Reset Password',
                isLoading: controller.isLoading.value,
                onPressed: controller.resetPassword,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
