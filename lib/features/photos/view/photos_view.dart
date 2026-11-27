import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/widgets/app_loader.dart';
import '../../albums/controller/albums_controller.dart';
import '../controller/photos_controller.dart';
import '../data/models/photo_model.dart';
import '../widgets/photo_grid_item.dart';
import 'photo_preview_view.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../share/data/models/share_link_model.dart';

class PhotosView extends GetView<PhotosController> {
  const PhotosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Obx(() => IconButton(
          icon: Icon(
            controller.isSelectionMode ? Icons.close : Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () {
            if (controller.isSelectionMode) {
              controller.clearSelection();
            } else {
              Get.back();
            }
          },
        )),
        title: Obx(() => Text(
          controller.isSelectionMode 
              ? '${controller.selectedIds.length} Selected' 
              : 'Photos',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        )),
        centerTitle: true,
        actions: [

          Obx(() {
            if (controller.isSelectionMode) {
              return Row(
                children: [
                  // Share selected photos/videos
                  IconButton(
                    icon: const Icon(
                      Icons.share_outlined,
                      color: AppColors.primary,
                    ),
                    onPressed: () {
                      final selectedItems = controller
                          .getSelectedMediaForApi()
                          .map(
                            (e) => ShareItemRequest(
                          mediaId: int.tryParse(
                            e['media_id'].toString(),
                          ) ??
                              0,
                          mediaType: e['media_type'],
                        ),
                      )
                          .toList();

                      // Navigate to Create Share screen
                      Get.toNamed(
                        Routes.CREATE_SHARE,
                        arguments: selectedItems,
                      );
                    },
                  ),

                  // Delete selected photos/videos
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.red,
                    ),
                    onPressed: () => _showDeleteConfirmation(context),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          })
          ,
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.photos.isEmpty) {
          return const Center(child: AppLoader(size: 50));
        }

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
                            Icon(Icons.photo_library_outlined, size: 60, color: AppColors.textSecondary),
                            SizedBox(height: 16),
                            Text(
                              'No photos found',
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
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildPhotoGrid(context, controller.photos),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
        );
      }),
      floatingActionButton: Obx(() => controller.isSelectionMode
          ? FloatingActionButton.extended(
              onPressed: () => _showAddToAlbumBottomSheet(context),
              label: const Text('Add to Album', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              icon: const Icon(Icons.add_photo_alternate_outlined, color: Colors.white),
              backgroundColor: AppColors.primary,
              elevation: 4,
            )
          : const SizedBox.shrink()),
    );
  }

  void _showAddToAlbumBottomSheet(BuildContext context) {
    final albumsController = Get.find<AlbumsController>();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 15),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Add to Album',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: Obx(() => albumsController.albums.isEmpty 
                ? const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('No albums found'),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: albumsController.albums.length,
                    itemBuilder: (context, index) {
                      final album = albumsController.albums[index];
                      return ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[200],
                          ),
                          child: album.imageUrl != null 
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(album.imageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.album)),
                                )
                              : const Icon(Icons.album),
                        ),
                        title: Text(album.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text('${album.photoCount} items'),
                        onTap: () {
                          final photosController = Get.find<PhotosController>();
                          Get.back(); // Close bottom sheet
                          albumsController.addMediaToAlbum(album.id, photosController.getSelectedMediaForApi());
                          photosController.clearSelection();
                        },
                      );
                    },
                  ),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Icon(Icons.add, color: Colors.white),
              ),
              title: const Text('Create New Album', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              onTap: () {
                Get.back(); // Close bottom sheet
                _showCreateAlbumDialog(context);
              },
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
          ],
        ),
      ),
    );
  }

  void _showCreateAlbumDialog(BuildContext context) {
    final textController = TextEditingController();
    final albumsController = Get.find<AlbumsController>();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create New Album',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              const Text('Enter a name for your new album folder.', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              AppTextField(controller: textController, hintText: 'Album Name', autofocus: true),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(() => AppButton(
                      text: 'Create',
                      isLoading: albumsController.isLoading.value,
                      height: 50,
                      onPressed: albumsController.isLoading.value
                        ? null
                        : () async {
                            final name = textController.text.trim();
                            if (name.isNotEmpty) {
                              final newAlbumId = await albumsController.createAlbum(name);
                              if (newAlbumId != null) {
                                // Close the dialog immediately
                                Get.back();
                                
                                final photosController = Get.find<PhotosController>();
                                // Add media to the newly created album
                                await albumsController.addMediaToAlbum(newAlbumId, photosController.getSelectedMediaForApi());
                                photosController.clearSelection();
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
      barrierDismissible: false,
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.delete_outline, color: AppColors.red, size: 48),
              const SizedBox(height: 16),
              Text("Delete ${controller.selectedIds.length} items?", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Selected items will be moved to recently deleted.", textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: TextButton(onPressed: () => Get.back(), child: const Text("Cancel", style: TextStyle(color: AppColors.textPrimary)))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        controller.deleteSelectedMedia();
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      child: const Text("Delete", style: TextStyle(color: Colors.white)),
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

  Widget _buildPhotoGrid(BuildContext context, List<PhotoModel> photos) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        return Obx(() => PhotoGridItem(
          imageUrl: photo.url,
          type: photo.type,
          isSelected: controller.selectedIds.contains(photo.id),
          isSelectionMode: controller.isSelectionMode,
          showPlayIcon: photo.type == MediaType.video, 
          onTap: () {
            if (controller.isSelectionMode) {
              controller.toggleSelection(photo.id);
            } else {
              if (photo.type == MediaType.video) {
                Get.toNamed(Routes.VIDEO_PLAYER, arguments: photo);
              } else {
                Get.to(() => PhotoPreviewView(photos: photos, initialIndex: index));
              }
            }
          },
          onLongPress: () {
            if (!controller.isSelectionMode) {
              HapticFeedback.lightImpact();
              controller.toggleSelection(photo.id);
            }
          },
        ));
      },
    );
  }
}
