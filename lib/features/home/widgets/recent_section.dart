import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../photos/controller/photos_controller.dart';

class RecentSection extends StatelessWidget {
  const RecentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final photosController = Get.find<PhotosController>();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Obx(() => photosController.photos.isNotEmpty
                ? TextButton(
                    onPressed: () => Get.toNamed(Routes.RECENT),
                    child: const Text(
                      'See All',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  )
                : const SizedBox.shrink()),
          ],
        ),
        SizedBox(
          height: 160,
          child: Obx(() {
            final recentPhotos = photosController.photos.take(5).toList();
            if (recentPhotos.isEmpty) {
              return const Center(child: Text('No recent items'));
            }
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recentPhotos.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      Routes.PHOTO_PREVIEW,
                      arguments: {
                        'photos': recentPhotos,
                        'index': index,
                      },
                    );
                  },
                  child: Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppColors.Card_Color,
                    ),
                    child: AppNetworkImage(
                      imageUrl: recentPhotos[index].url,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
