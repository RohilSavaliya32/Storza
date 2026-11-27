import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../controller/photos_controller.dart';
import '../data/models/photo_model.dart';
import '../widgets/photo_grid_item.dart';
import 'photo_preview_view.dart';

class RecentView extends GetView<PhotosController> {
  const RecentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Recent',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () => controller.fetchPhotos(),
          color: AppColors.primary,
          child: controller.photos.isEmpty
              ? LayoutBuilder(
                  builder: (context, constraints) => ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      Container(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.history, size: 60, color: AppColors.textSecondary),
                              SizedBox(height: 16),
                              Text(
                                'No recent items',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: controller.photos.length,
                  itemBuilder: (context, index) {
                    final photo = controller.photos[index];
                    return PhotoGridItem(
                      imageUrl: photo.url,
                      type: photo.type,
                      onTap: () {
                        if (photo.type == MediaType.video) {
                          Get.toNamed(Routes.VIDEO_PLAYER, arguments: photo);
                        } else {
                          Get.to(() => PhotoPreviewView(
                                photos: controller.photos.toList(),
                                initialIndex: index,
                              ));
                        }
                      },
                    );
                  },
                ),
        );
      }),
    );
  }
}
