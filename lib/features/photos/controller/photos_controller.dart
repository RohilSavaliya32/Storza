import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_loader.dart';
import '../../auth/controller/auth_controller.dart';
import '../data/models/photo_model.dart';
import '../data/models/photo_upload_response.dart';
import '../data/services/media_service.dart';
import '../data/services/photo_api_service.dart';
import '../../recently_deleted/controller/recently_deleted_controller.dart';

class PhotosController extends GetxController {
  final PhotoApiService _photoApiService;
  final MediaService _mediaService = MediaService();
  
  final RxList<PhotoModel> photos = <PhotoModel>[].obs;
  final RxBool isUploading = false.obs;
  final RxDouble uploadProgress = 0.0.obs;
  final RxInt uploadTotalFiles = 0.obs;
  final RxBool isDownloading = false.obs;
  final RxBool isLoading = false.obs;

  final RxList<String> selectedIds = <String>[].obs;
  bool get isSelectionMode => selectedIds.isNotEmpty;

  // Persistent counter for permissions
  int _permissionDeniedCount = 0;

  PhotosController(this._photoApiService);

  @override
  void onInit() {
    super.onInit();
    fetchPhotos();
  }

  Future<void> fetchPhotos() async {
    try {
      isLoading.value = true;
      final response = await _photoApiService.getPhotos();
      
      if (response.status == 'success' && response.data != null) {
        List<PhotoModel> fetchedPhotos = [];
        
        for (var photoData in response.data!) {
          _processPhotoData(photoData, fetchedPhotos);
        }
        
        photos.assignAll(fetchedPhotos);
      }
    } catch (e) {
      debugPrint('❌ Error fetching photos: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _processPhotoData(PhotoUploadData photoData, List<PhotoModel> targetList) {
    if (photoData.attachments != null) {
      for (var attachment in photoData.attachments!) {
        final String imageUrl = attachment.fullUrl ?? attachment.fileUrl ?? '';
        
        if (imageUrl.isNotEmpty) {
          targetList.add(PhotoModel(
            id: attachment.id.toString(),
            photoId: attachment.photoId?.toString() ?? photoData.id?.toString(),
            url: imageUrl,
            title: attachment.fileName ?? photoData.albumTitle ?? 'Photo',
            isFavorite: false,
            type: (attachment.fileType?.contains('video') ?? false) 
                ? MediaType.video 
                : MediaType.image,
          ));
        }
      }
    }
  }

  List<Map<String, dynamic>> getSelectedMediaForApi() {
    return photos
        .where((p) => selectedIds.contains(p.id))
        .map((p) => {
              'media_id': p.photoId ?? p.id,
              'media_type': p.type == MediaType.video ? 'video' : 'photo',
            })
        .toList();
  }

  Future<PhotoUploadData?> fetchSinglePhoto(String id) async {
    try {
      isLoading.value = true;
      final response = await _photoApiService.getSinglePhoto(id);
      
      if (response.status == 'success' && response.data != null) {
        return response.data;
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error fetching single photo: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  List<PhotoModel> get onlyPhotos => photos.where((p) => p.type == MediaType.image).toList();
  List<PhotoModel> get onlyVideos => photos.where((p) => p.type == MediaType.video).toList();

  Future<bool> _requestPermission(bool isVideo) async {
    PermissionStatus status;
    if (Platform.isAndroid) {
      if (isVideo) {
        status = await Permission.videos.request();
      } else {
        status = await Permission.photos.request();
      }
      
      if (status.isDenied) {
        status = await Permission.storage.request();
      }
    } else {
      status = await Permission.photos.request();
    }

    if (status.isGranted || status.isLimited) {
      _permissionDeniedCount = 0; // Reset on success
      return true;
    }

    _permissionDeniedCount++;
    
    // Check if we should show the settings dialog (after 3 denials or permanent denial)
    if (_permissionDeniedCount >= 3 || status.isPermanentlyDenied) {
      _showPermissionSettingsDialog();
      return false;
    }

    return false;
  }

  void _showPermissionSettingsDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Permission Required",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Storage access has been denied multiple times. Please enable it in the app settings to continue uploading media.",
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "Cancel",
              style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Open Settings", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> pickAndUploadMedia(ImageSource source, {bool isVideo = false}) async {
    if (!await _requestPermission(isVideo)) return;

    File? file;
    try {
      if (isVideo) {
        file = await _mediaService.pickVideo(source);
      } else {
        file = await _mediaService.pickImage(source);
      }

      if (file == null) return;

      await _uploadFiles([file.path], isVideo: isVideo);

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick media: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> pickAndUploadMultiplePhotos() async {
    if (!await _requestPermission(false)) return;

    try {
      final List<File> files = await _mediaService.pickMultipleImages();
      if (files.isEmpty) return;

      await _uploadFiles(files.map((e) => e.path).toList());
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick images: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _uploadFiles(List<String> filePaths, {bool isVideo = false}) async {
    try {
      isUploading.value = true;
      uploadProgress.value = 0.0;
      uploadTotalFiles.value = filePaths.length;
      
      final authController = Get.find<AuthController>();
      final userId = authController.user.value?.id.toString() ?? '1';
      
      final response = await _photoApiService.uploadMedia(
        userId: userId,
        albumTitle: "My Vacation Album",
        priority: "high",
        completedAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        filePaths: filePaths,
        isVideo: isVideo,
        onSendProgress: (sent, total) {
          uploadProgress.value = sent / total;
        },
      );

      if (response.status == 'success' && response.data != null) {
        fetchPhotos();

        if (isVideo) {
          Get.toNamed(Routes.VIDEOS);
        } else {
          Get.toNamed(Routes.PHOTOS);
        }
      }

    } catch (e) {
      debugPrint('❌ Upload error: $e');
      Get.snackbar(
        'Error',
        'Upload failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploading.value = false;
      uploadProgress.value = 0.0;
      uploadTotalFiles.value = 0;
    }
  }

  Future<void> downloadMedia(String url) async {
    try {
      isDownloading.value = true;
      Get.snackbar(
        'Downloading',
        'Starting download...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
      
      final result = await _mediaService.downloadMedia(url);
      
      if (result != null) {
        Get.snackbar(
          'Success',
          'Media downloaded successfully to gallery',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to download media',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Download failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isDownloading.value = false;
    }
  }

  Future<void> downloadSelectedMedia() async {
    if (selectedIds.isEmpty) return;
    
    try {
      isDownloading.value = true;
      Get.snackbar(
        'Downloading',
        'Starting download of ${selectedIds.length} items...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
      
      int successCount = 0;
      final selectedItems = photos.where((p) => selectedIds.contains(p.id)).toList();
      
      for (var item in selectedItems) {
        final result = await _mediaService.downloadMedia(item.url);
        if (result != null) successCount++;
      }
      
      if (successCount > 0) {
        Get.snackbar(
          'Success',
          '$successCount items downloaded successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to download selected items',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
      clearSelection();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Download failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isDownloading.value = false;
    }
  }

  void toggleSelection(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
  }

  void clearSelection() {
    selectedIds.clear();
  }

  Future<void> deleteSelectedMedia() async {
    if (selectedIds.isEmpty) return;
    
    final List<PhotoModel> itemsToDelete = photos.where((p) => selectedIds.contains(p.id)).toList();
    
    Get.dialog(
      const Center(child: AppLoader(size: 60)),
      barrierDismissible: false,
    );
    
    int deletedCount = 0;
    for (var item in itemsToDelete) {
      final success = await deleteMedia(item, showSnackbar: false, showLoader: false);
      if (success) deletedCount++;
    }
    
    if (Get.isDialogOpen == true) Get.back();
    
    if (deletedCount > 0) {
      Get.snackbar(
        'Deleted',
        '$deletedCount items deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to delete selected items',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    
    clearSelection();
  }

  Future<bool> deleteMedia(PhotoModel item, {bool showSnackbar = true, bool showLoader = true}) async {
    if (showLoader) {
      Get.dialog(
        const Center(child: AppLoader(size: 60)),
        barrierDismissible: false,
      );
    }
    
    final success = await _deleteMediaInternal(item);
    
    if (showLoader && Get.isDialogOpen == true) Get.back();
    
    if (success) {
      if (showSnackbar) {
        Get.snackbar(
          'Deleted',
          'Item deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
      return true;
    } else {
      if (showSnackbar) {
        Get.snackbar(
          'Error',
          'Failed to delete item from server',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
      return false;
    }
  }

  Future<bool> _deleteMediaInternal(PhotoModel item) async {
    if (item.photoId == null) {
      debugPrint('❌ Cannot delete: photoId is null for item ${item.id}');
      return false;
    }

    try {
      final success = await _photoApiService.deletePhoto(item.photoId!);
      if (success) {
        photos.removeWhere((p) => p.id == item.id);
        
        if (Get.isRegistered<RecentlyDeletedController>()) {
          Get.find<RecentlyDeletedController>().addMedia(item);
        }
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ Error in _deleteMediaInternal: $e');
      return false;
    }
  }

  void restoreMedia(PhotoModel item) {
    if (!photos.any((p) => p.id == item.id)) {
      photos.insert(0, item);
      if (Get.isRegistered<RecentlyDeletedController>()) {
        Get.find<RecentlyDeletedController>().addMedia(item);
      }
    }
  }

  // Dummy toggleFavorite to fix compilation errors in other views
  void toggleFavorite(String id) {
    // Unused but kept for compatibility
  }
}
