import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../controller/albums_controller.dart';

class CreateAlbumCard extends StatelessWidget {
  const CreateAlbumCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AlbumsController>();

    return GestureDetector(
      onTap: () => _showCreateAlbumDialog(context, controller),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.lightGrey,
                  width: 1,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.add,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create Album',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
          const Text(
            'New Folder',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateAlbumDialog(BuildContext context, AlbumsController controller) {
    final textController = TextEditingController();
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create New Album',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter a name for your new album folder.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              AppTextField(
                controller: textController,
                hintText: 'Album Name',
                autofocus: true,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(() => AppButton(
                      text: controller.isLoading.value ? 'Creating...' : 'Create',
                      height: 50,
                      onPressed: controller.isLoading.value
                        ? null
                        : () async {
                            final name = textController.text.trim();
                            if (name.isNotEmpty) {
                              final result = await controller.createAlbum(name);
                              if (result != null) {
                                if (context.mounted) Navigator.pop(context);
                              }
                            }
                          },
                    )),
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
