import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_loader.dart';
import '../controller/albums_controller.dart';
import '../widgets/album_card.dart';
import '../widgets/create_album_card.dart';
import '../data/models/album_model.dart';
import 'album_details_view.dart';

class AlbumsView extends GetView<AlbumsController> {
  const AlbumsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Albums',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: AppColors.textPrimary,
            ),
            onPressed: _showCreateAlbumDialog,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.albums.isEmpty) {
          return const Center(
            child: AppLoader(size: 80),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchAlbums,
          color: AppColors.primary,
          backgroundColor: Colors.white,
          child: GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 24,
              childAspectRatio: 0.8,
            ),
            itemCount: controller.albums.length + 1,
            itemBuilder: (context, index) {
              if (index == controller.albums.length) {
                return GestureDetector(
                  onTap: _showCreateAlbumDialog,
                  child: const CreateAlbumCard(),
                );
              }

              final album = controller.albums[index];

              return GestureDetector(
                onTap: () {
                  Get.to(
                        () => AlbumDetailsView(
                      albumId: album.id,
                      albumName: album.title,
                    ),
                  );
                },
                child: AlbumCard(
                  title: album.title,
                  itemCount: '${album.photoCount} Items',
                  imageUrl: album.imageUrl ?? '',
                  onMoreTap: () {
                    _showAlbumActions(album);
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }

  // ============================================================
  // ALBUM ACTIONS BOTTOM SHEET
  // ============================================================

  void _showAlbumActions(AlbumModel album) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 16,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.blueBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.primary,
                ),
              ),
              title: const Text(
                'Rename Album',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Get.back();
                _showEditAlbumDialog(album);
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.redBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: AppColors.red,
                ),
              ),
              title: const Text(
                'Delete Album',
                style: TextStyle(
                  color: AppColors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Get.back();
                _showDeleteConfirmation(album);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // ============================================================
  // RENAME ALBUM DIALOG
  // ============================================================

  void _showEditAlbumDialog(AlbumModel album) {
    Get.dialog<void>(
      _EditAlbumDialog(album: album, controller: controller),
      barrierDismissible: false,
    );
  }

  // ============================================================
  // DELETE ALBUM CONFIRMATION DIALOG
  // ============================================================

  void _showDeleteConfirmation(AlbumModel album) {
    Get.dialog<void>(
      _DeleteAlbumDialog(album: album, controller: controller),
      barrierDismissible: false,
    );
  }

  // ============================================================
  // CREATE ALBUM DIALOG
  // ============================================================

  void _showCreateAlbumDialog() {
    Get.dialog<void>(
      _CreateAlbumDialog(controller: controller),
      barrierDismissible: false,
    );
  }
}

// ============================================================
// PRIVATE DIALOG WIDGETS
// ============================================================

class _CreateAlbumDialog extends StatefulWidget {
  final AlbumsController controller;

  const _CreateAlbumDialog({required this.controller});

  @override
  State<_CreateAlbumDialog> createState() => _CreateAlbumDialogState();
}

class _CreateAlbumDialogState extends State<_CreateAlbumDialog> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
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
                controller: _textController,
                hintText: 'Album Name',
                autofocus: true,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                    child: Obx(
                      () => AppButton(
                        text: 'Create',
                        isLoading: widget.controller.isLoading.value,
                        height: 50,
                        onPressed: widget.controller.isLoading.value 
                        ? null 
                        : () async {
                          final name = _textController.text.trim();

                          if (name.isEmpty) {
                            // SnackbarUtils.error('Please enter an album name.', title: 'Required');
                            return;
                          }

                          final result = await widget.controller.createAlbum(name);

                          if (result != null) {
                            Get.back();
                          }
                        },
                      ),
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

class _EditAlbumDialog extends StatefulWidget {
  final AlbumModel album;
  final AlbumsController controller;

  const _EditAlbumDialog({
    required this.album,
    required this.controller,
  });

  @override
  State<_EditAlbumDialog> createState() => _EditAlbumDialogState();
}

class _EditAlbumDialogState extends State<_EditAlbumDialog> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.album.title);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Rename Album',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              AppTextField(
                controller: _textController,
                hintText: 'Album Name',
                autofocus: true,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(
                      () => AppButton(
                        text: 'Save',
                        isLoading: widget.controller.isLoading.value,
                        onPressed: widget.controller.isLoading.value 
                        ? null 
                        : () async {
                          final name = _textController.text.trim();

                          if (name.isEmpty) {
                            // SnackbarUtils.error('Please enter an album name.', title: 'Required');
                            return;
                          }

                          if (name == widget.album.title) {
                            Get.back();
                            return;
                          }

                          final success = await widget.controller.updateAlbum(
                            widget.album.id,
                            name,
                          );

                          if (success) {
                            Get.back();
                          }
                        },
                      ),
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

class _DeleteAlbumDialog extends StatelessWidget {
  final AlbumModel album;
  final AlbumsController controller;

  const _DeleteAlbumDialog({
    required this.album,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                'Delete Album?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to delete '
                '\"${album.title}\"? The photos inside '
                'will not be deleted.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(
                      () => AppButton(
                        text: 'Delete',
                        backgroundColor: AppColors.red,
                        isLoading: controller.isLoading.value,
                        onPressed: controller.isLoading.value 
                        ? null 
                        : () async {
                          final success = await controller.deleteAlbum(
                            album.id,
                          );

                          if (success) {
                            Get.back();
                          }
                        },
                      ),
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
