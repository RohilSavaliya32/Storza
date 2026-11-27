import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../photos/controller/photos_controller.dart';

class UploadView extends StatelessWidget {
  const UploadView({super.key});

  @override
  Widget build(BuildContext context) {
    final photosController = Get.find<PhotosController>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bottom Sheet Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 10),
          _buildUploadOption(
            icon: Icons.image_outlined,
            title: 'Upload Photos',
            subtitle: 'From gallery',
            iconColor: const Color(0xFF4A90E2),
            onTap: () {
              Get.back();
              photosController.pickAndUploadMedia(ImageSource.gallery, isVideo: false);
            },
          ),
          const SizedBox(height: 12),
          _buildUploadOption(
            icon: Icons.videocam_outlined,
            title: 'Upload Video',
            subtitle: 'From gallery',
            iconColor: const Color(0xFF7E57C2),
            onTap: () {
              Get.back();
              photosController.pickAndUploadMedia(ImageSource.gallery, isVideo: true);
            },
          ),
          const SizedBox(height: 12),
          _buildUploadOption(
            icon: Icons.camera_alt_outlined,
            title: 'Take Photo',
            subtitle: 'From camera',
            iconColor: const Color(0xFF66BB6A),
            onTap: () {
              Get.back();
              photosController.pickAndUploadMedia(ImageSource.camera, isVideo: false);
            },
          ),
          const SizedBox(height: 12),
          _buildUploadOption(
            icon: Icons.videocam_rounded,
            title: 'Record Video',
            subtitle: 'From camera',
            iconColor: const Color(0xFFEF5350),
            onTap: () {
              Get.back();
              photosController.pickAndUploadMedia(ImageSource.camera, isVideo: true);
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildUploadOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF0F0F0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
