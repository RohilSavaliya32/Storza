import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../photos/data/models/photo_model.dart';
import '../../photos/widgets/photo_grid_item.dart';
import '../../photos/controller/photos_controller.dart';
import '../controller/favorites_controller.dart';
import '../../photos/view/photo_preview_view.dart';

class FavoritesView extends GetView<FavoritesController> {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure FavoritesController is initialized if not already
    if (!Get.isRegistered<FavoritesController>()) {
      Get.put(FavoritesController());
    }
    
    final photosController = Get.find<PhotosController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Favorites',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.favoritePhotos.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 64, color: AppColors.lightGrey),
                SizedBox(height: 16),
                Text(
                  'No favorites yet',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: controller.favoritePhotos.length,
          itemBuilder: (context, index) {
            final photo = controller.favoritePhotos[index];
            return PhotoGridItem(
              imageUrl: photo.url,
              isFavorite: true,
              type: photo.type,
              onFavoriteTap: () => photosController.toggleFavorite(photo.id),
              onTap: () {
                if (photo.type == MediaType.video) {
                  Get.toNamed(Routes.VIDEO_PLAYER, arguments: photo);
                } else {
                  Get.to(() => PhotoPreviewView(
                    photos: controller.favoritePhotos.toList(),
                    initialIndex: index,
                  ));
                }
              },
            );
          },
        );
      }),
    );
  }
}
