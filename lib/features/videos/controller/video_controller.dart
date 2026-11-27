import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_loader.dart';
import '../../photos/data/models/photo_model.dart';
import '../../photos/data/services/media_service.dart';
import '../data/models/video_list_response.dart';
import '../data/services/video_api_service.dart';
import '../../auth/controller/auth_controller.dart';
import 'package:intl/intl.dart';

class VideoController extends GetxController {
  final VideoApiService _apiService;
  final MediaService _mediaService = MediaService();
  
  final RxList<PhotoModel> videos = <PhotoModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isUploading = false.obs;
  
  final RxList<String> selectedIds = <String>[].obs;
  bool get isSelectionMode => selectedIds.isNotEmpty;

  VideoController(this._apiService);

  @override
  void onInit() {
    super.onInit();
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    try {
      isLoading.value = true;
      final response = await _apiService.getVideos();
      
      // Proper clean way to print JSON response in console
        final prettyJson = const JsonEncoder.withIndent('  ').convert(response.toJson());
      debugPrint('📹 Video API Response:\n$prettyJson');
      
      if (response.status == 'success' && response.data != null) {
        List<PhotoModel> fetchedVideos = [];
        for (var videoData in response.data!) {
          if (videoData.attachments != null) {
            for (var attachment in videoData.attachments!) {
              fetchedVideos.add(PhotoModel(
                id: attachment.id.toString(),
                photoId: attachment.videoId?.toString() ?? videoData.id?.toString(),
                url: attachment.fullUrl ?? attachment.fileUrl ?? '',
                title: attachment.fileName ?? videoData.albumTitle ?? 'Video',
                isFavorite: false,
                type: MediaType.video,
              ));
            }
          }
        }
        videos.assignAll(fetchedVideos);
      }
    } catch (e) {
      debugPrint('❌ Error fetching videos: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> getSelectedMediaForApi() {
    return videos
        .where((p) => selectedIds.contains(p.id))
        .map((p) => {
              'media_id': p.photoId ?? p.id,
              'media_type': 'video',
            })
        .toList();
  }

  Future<bool> _requestPermission() async {
    int attempts = 0;
    PermissionStatus status = PermissionStatus.denied;

    while (attempts < 3) {
      if (Platform.isAndroid) {
        // Request specific media permissions for Android 13+ or storage for older
        status = await Permission.videos.request();
        if (status.isDenied) {
          status = await Permission.storage.request();
        }
      } else {
        status = await Permission.photos.request();
      }

      if (status.isGranted || status.isLimited) {
        return true;
      }

      if (status.isPermanentlyDenied) {
        break;
      }
      
      attempts++;
    }

    _showPermissionSettingsDialog();
    return false;
  }

  void _showPermissionSettingsDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Permission Required", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          "Video access has been denied multiple times. Please enable it in settings to continue uploading.",
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel", style: TextStyle(color: AppColors.textSecondary)),
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
            child: const Text("Settings", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> pickAndUploadVideo(ImageSource source) async {
    if (!await _requestPermission()) return;

    try {
      final File? file = await _mediaService.pickVideo(source);
      if (file == null) return;

      await uploadVideos([file.path]);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick video: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> uploadVideos(List<String> filePaths) async {
    try {
      isUploading.value = true;
      Get.dialog(const Center(child: AppLoader(size: 80)), barrierDismissible: false);

      final authController = Get.find<AuthController>();
      final userId = authController.user.value?.id.toString() ?? '1';

      final response = await _apiService.uploadVideos(
        userId: userId,
        albumTitle: "My Videos",
        priority: "medium",
        completedAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        filePaths: filePaths,
      );

      Get.back(); // Close loader

      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchVideos();
        Get.snackbar(
          'Success',
          'Video uploaded successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      Get.snackbar(
        'Error',
        'Failed to upload: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploading.value = false;
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
    
    Get.dialog(const Center(child: AppLoader(size: 60)), barrierDismissible: false);
    
    int deletedCount = 0;
    for (var id in List.from(selectedIds)) {
      final video = videos.firstWhereOrNull((v) => v.id == id);
      if (video != null && video.photoId != null) {
        try {
          final success = await _apiService.deleteVideo(video.photoId!);
          if (success) {
            videos.removeWhere((v) => v.id == id);
            deletedCount++;
          }
        } catch (e) {
          debugPrint('Error deleting video $id: $e');
        }
      }
    }
    
    Get.back();
    if (deletedCount > 0) {
      Get.snackbar(
        'Deleted',
        '$deletedCount videos deleted',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to delete selected videos',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    clearSelection();
  }
}
