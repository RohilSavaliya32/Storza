import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_loader.dart';
import '../../photos/data/models/photo_model.dart';
import '../../photos/view/photo_preview_view.dart';
import '../../photos/widgets/photo_grid_item.dart';
import '../controller/albums_controller.dart';

class AlbumDetailsView extends StatefulWidget {
  final String albumId;
  final String albumName;
  
  const AlbumDetailsView({
    super.key, 
    required this.albumId,
    required this.albumName,
  });

  @override
  State<AlbumDetailsView> createState() => _AlbumDetailsViewState();
}

class _AlbumDetailsViewState extends State<AlbumDetailsView> {
  final albumsController = Get.find<AlbumsController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      albumsController.fetchAlbumDetails(widget.albumId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            albumsController.isSelectionMode ? Icons.close : Icons.arrow_back_ios_new, 
            color: AppColors.textPrimary, 
            size: 20
          ),
          onPressed: () {
            if (albumsController.isSelectionMode) {
              albumsController.clearSelection();
            } else {
              Get.back();
            }
          },
        ),
        title: Text(
          albumsController.isSelectionMode 
              ? '${albumsController.selectedIds.length} Selected'
              : widget.albumName,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          if (albumsController.isSelectionMode)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.red),
              onPressed: () => _showDeleteConfirmation(context),
            ),
        ],
      ),
      body: Obx(() {
        if (albumsController.isDetailsLoading.value && albumsController.currentAlbumPhotos.isEmpty) {
          return const Center(child: AppLoader(size: 80));
        }

        final List<PhotoModel> albumPhotos = albumsController.currentAlbumPhotos;

        return RefreshIndicator(
          onRefresh: () => albumsController.fetchAlbumDetails(widget.albumId),
          color: AppColors.primary,
          backgroundColor: Colors.white,
          child: albumPhotos.isEmpty
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
                                'No items in this album',
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
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: albumPhotos.length,
                  itemBuilder: (context, index) {
                    final photo = albumPhotos[index];
                    return Obx(() => PhotoGridItem(
                      imageUrl: photo.url,
                      isFavorite: photo.isFavorite,
                      type: photo.type,
                      isSelected: albumsController.selectedIds.contains(photo.id),
                      isSelectionMode: albumsController.isSelectionMode,
                      onTap: () {
                        if (albumsController.isSelectionMode) {
                          albumsController.toggleSelection(photo.id);
                        } else {
                          Get.to(() => PhotoPreviewView(
                                photos: albumPhotos,
                                initialIndex: index,
                              ));
                        }
                      },
                      onLongPress: () {
                        if (!albumsController.isSelectionMode) {
                          HapticFeedback.lightImpact();
                          albumsController.toggleSelection(photo.id);
                        }
                      },
                    ));
                  },
                ),
        );
      }),
    ));
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
                "Delete ${albumsController.selectedIds.length} items?",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Selected items will be moved to recently deleted.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: const Text("Cancel", style: TextStyle(color: AppColors.textPrimary)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        albumsController.deleteSelectedMedia();
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
