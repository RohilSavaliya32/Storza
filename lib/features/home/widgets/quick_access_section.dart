import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../photos/controller/photos_controller.dart';
import '../../videos/controller/video_controller.dart';
// import '../../favorites/controller/favorites_controller.dart';
import '../../recently_deleted/controller/recently_deleted_controller.dart';

class QuickAccessSection extends StatelessWidget {
  const QuickAccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Get controllers
    final photosController = Get.find<PhotosController>();
    final videoController = Get.find<VideoController>();
    // final favoritesController = Get.find<FavoritesController>();
    final deletedController = Get.find<RecentlyDeletedController>();

    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quick Access',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.35,
          children: [
            Obx(() => QuickAccessItem(
              icon: Icons.image_outlined,
              title: 'Photos',
              subtitle: photosController.photos.length.toString(),
              iconColor: AppColors.primary,
              bgColor: AppColors.Card_Color,
              route: Routes.PHOTOS,
            )),
            Obx(() => QuickAccessItem(
              icon: Icons.videocam_outlined,
              title: 'Videos',
              subtitle: videoController.videos.length.toString(),
              iconColor: AppColors.orange,
              bgColor: AppColors.Card_Color,
              route: Routes.VIDEOS,
            )),
            // Obx(() => QuickAccessItem(
            //   icon: Icons.favorite,
            //   title: 'Favorites',
            //   subtitle: favoritesController.favoritePhotos.length.toString(),
            //   iconColor: AppColors.red,
            //   bgColor: AppColors.Card_Color,
            //   route: Routes.FAVORITES,
            // )),
            Obx(() => QuickAccessItem(
              icon: Icons.delete_outline,
              title: 'Recently Deleted',
              subtitle: deletedController.deletedItems.length.toString(),
              iconColor: AppColors.grey,
              bgColor: AppColors.Card_Color,
              route: Routes.RECENTLY_DELETED,
            )),
          ],
        ),
      ],
    );
  }
}

class QuickAccessItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final Color bgColor;
  final String route;

  const QuickAccessItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.bgColor,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(route),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 22,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
