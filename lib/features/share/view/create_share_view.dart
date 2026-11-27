import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../controller/share_controller.dart';
import '../../../core/widgets/app_text_field.dart';

class CreateShareView extends GetView<ShareController> {
  const CreateShareView({super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: 'Weekend Highlights');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create Share Link',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Selected Items Summary
            Obx(() => Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.collections_outlined, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${controller.selectedItems.length} items selected',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Text(
                          'Photos and videos from your gallery',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Change', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 25),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Link Title',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ),
            const SizedBox(height: 10),
            AppTextField(
              controller: titleController,
              hintText: 'e.g. Vacation Memories',
            ),
            const SizedBox(height: 25),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Expires After:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() => ListView(
                children: [
                  _buildExpiryOption('One Time View', 'Link expires after it will be viewed'),
                  _buildExpiryOption('10 Minutes'),
                  _buildExpiryOption('1 Hour'),
                  _buildExpiryOption('24 Hours'),
                  _buildExpiryOption('7 Days'),
                ],
              )),
            ),
            Obx(() => SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: controller.isLoading.value || controller.selectedItems.isEmpty
                  ? null 
                  : () => controller.createShareLink(title: titleController.text.trim()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: AppColors.lightGrey,
                ),
                child: controller.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
                      'Create Share Link',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              ),
            )),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildExpiryOption(String title, [String? subtitle]) {
    String internalValue;
    switch (title) {
      case 'One Time View': internalValue = 'one_time'; break;
      case '10 Minutes': internalValue = '10_mins'; break;
      case '1 Hour': internalValue = '1_hour'; break;
      case '24 Hours': internalValue = '24_hours'; break;
      case '7 Days': internalValue = '7_days'; break;
      default: internalValue = '7_days';
    }

    final isSelected = controller.selectedExpiry.value == internalValue;
    
    return InkWell(
      onTap: () => controller.updateExpiry(title),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: subtitle != null ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.primary : AppColors.lightGrey,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
