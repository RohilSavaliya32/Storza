import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_loader.dart';
import '../../albums/controller/albums_controller.dart';
import '../../photos/controller/photos_controller.dart';
import '../../photos/widgets/photo_grid_item.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../share/data/models/share_link_model.dart';

class VideosView extends GetView<PhotosController> {
  const VideosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            controller.isSelectionMode ? Icons.close : Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () {
            if (controller.isSelectionMode) {
              controller.clearSelection();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          controller.isSelectionMode 
              ? '${controller.selectedIds.length} Selected' 
              : 'Videos',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          if (controller.isSelectionMode) ...[
            IconButton(
              icon: const Icon(Icons.share_outlined, color: AppColors.primary),
              onPressed: () {
                final selectedItems = controller.getSelectedMediaForApi().map((e) => ShareItemRequest(
                  mediaId: int.tryParse(e['media_id'].toString()) ?? 0,
                  mediaType: e['media_type'],
                )).toList();
                
                // Pass selected items via arguments to avoid "ShareController not found" error
                Get.toNamed(Routes.CREATE_SHARE, arguments: selectedItems);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.red),
              onPressed: () => _showDeleteConfirmation(context),
            ),
          ] else
            Obx(() => controller.isUploading.value
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: AppLoader(size: 24),
                    ),
                  )
                : const SizedBox.shrink()),
        ],
      ),
      body: Obx(() {
        final videos = controller.onlyVideos;
        
        if (videos.isEmpty && controller.isLoading.value) {
           return const Center(child: AppLoader(size: 80));
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchPhotos(),
          color: AppColors.primary,
          child: videos.isEmpty
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
                              Icon(Icons.video_library_outlined, size: 60, color: AppColors.textSecondary),
                              SizedBox(height: 16),
                              Text(
                                'No videos found',
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
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    return Obx(() => PhotoGridItem(
                      imageUrl: video.url,
                      type: video.type,
                      isSelected: controller.selectedIds.contains(video.id),
                      isSelectionMode: controller.isSelectionMode,
                      onTap: () {
                        if (controller.isSelectionMode) {
                          controller.toggleSelection(video.id);
                        } else {
                          Get.toNamed(Routes.VIDEO_PLAYER, arguments: video);
                        }
                      },
                      onLongPress: () {
                        if (!controller.isSelectionMode) {
                          HapticFeedback.lightImpact();
                          controller.toggleSelection(video.id);
                        }
                      },
                    ));
                  },
                ),
        );
      }),
      floatingActionButton: controller.isSelectionMode
          ? FloatingActionButton.extended(
              onPressed: () => _showAddToAlbumBottomSheet(context),
              label: const Text('Add to Album', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              icon: const Icon(Icons.add_photo_alternate_outlined, color: Colors.white),
              backgroundColor: AppColors.primary,
              elevation: 4,
            )
          : null,
    ));
  }

  void _showAddToAlbumBottomSheet(BuildContext context) {
    final albumsController = Get.find<AlbumsController>();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
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
                color: Colors.grey,
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
              child: Obx(() => ListView.builder(
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
                        image: album.imageUrl != null 
                            ? DecorationImage(image: NetworkImage(album.imageUrl!), fit: BoxFit.cover)
                            : null,
                        color: Colors.grey[200],
                      ),
                      child: album.imageUrl == null ? const Icon(Icons.album) : null,
                    ),
                    title: Text(album.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('${album.photoCount} items'),
                    onTap: () {
                      Navigator.pop(context); // Close bottom sheet
                      albumsController.addMediaToAlbum(album.id, controller.getSelectedMediaForApi());
                      controller.clearSelection();
                    },
                  );
                },
              )),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Icon(Icons.add, color: Colors.white),
              ),
              title: const Text('Create New Album', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context); // Close bottom sheet
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
                      text: albumsController.isLoading.value ? 'Creating...' : 'Create',
                      height: 50,
                      onPressed: albumsController.isLoading.value
                        ? null
                        : () async {
                            final name = textController.text.trim();
                            if (name.isNotEmpty) {
                              final newAlbumId = await albumsController.createAlbum(name);
                              
                              if (newAlbumId != null) {
                                // Add selected videos to the new album
                                await albumsController.addMediaToAlbum(newAlbumId, controller.getSelectedMediaForApi());
                                controller.clearSelection();
                                
                                // Direct pop to close the dialog
                                if (context.mounted) {
                                  Navigator.of(context, rootNavigator: true).pop();
                                }
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
              Text(
                "Delete ${controller.selectedIds.length} videos?",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Selected videos will be moved to recently deleted.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel", style: TextStyle(color: AppColors.textPrimary)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        controller.deleteSelectedMedia();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
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
}
