import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../core/widgets/app_loader.dart';
import '../data/models/album_model.dart';
import '../data/services/album_api_service.dart';
import '../data/models/create_album_response.dart';
import '../data/models/album_details_response.dart';
import '../../photos/data/models/photo_model.dart';
import '../../photos/controller/photos_controller.dart';

class AlbumsController extends GetxController {
  final AlbumApiService _apiService;
  final RxList<AlbumModel> albums = <AlbumModel>[].obs;
  final RxBool isLoading = false.obs;
  
  final RxList<PhotoModel> currentAlbumPhotos = <PhotoModel>[].obs;
  final RxBool isDetailsLoading = false.obs;

  // Selection for album details
  final RxList<String> selectedIds = <String>[].obs;
  bool get isSelectionMode => selectedIds.isNotEmpty;
  
  AlbumsController(this._apiService);

  @override
  void onInit() {
    super.onInit();
    fetchAlbums();
  }

  Future<void> fetchAlbums() async {
    try {
      isLoading.value = true;
      final response = await _apiService.getAlbums();
      
      if (response.status == 'success' && response.data != null) {
        final List<AlbumModel> fetchedAlbums = response.data!.data!.map((albumData) {
          return _mapToAlbumModel(albumData);
        }).toList();
        
        albums.assignAll(fetchedAlbums);
      }
    } catch (e) {
      debugPrint('Error in AlbumsController.fetchAlbums: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAlbumDetails(String albumId) async {
    try {
      isDetailsLoading.value = true;
      currentAlbumPhotos.clear();
      clearSelection();
      
      final response = await _apiService.getAlbumDetails(albumId);
      
      if (response.status == 'success' && response.images != null) {
        final List<PhotoModel> photos = response.images!.map((img) {
          return PhotoModel(
            id: img.id.toString(),
            photoId: img.photoId?.toString(),
            url: img.fullUrl ?? '',
            title: img.fileName ?? 'Photo',
            isFavorite: false,
            type: (img.mediaType == 'video' || (img.fileType?.contains('video') ?? false))
                ? MediaType.video
                : MediaType.image,
          );
        }).toList();
        
        currentAlbumPhotos.assignAll(photos);
      }
    } catch (e) {
      debugPrint('Error in AlbumsController.fetchAlbumDetails: $e');
    } finally {
      isDetailsLoading.value = false;
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
    
    final photosController = Get.find<PhotosController>();
    final List<PhotoModel> itemsToDelete = currentAlbumPhotos.where((p) => selectedIds.contains(p.id)).toList();
    
    int deletedCount = 0;
    
    // Show a global loader for bulk delete
    Get.dialog(
      const Center(child: AppLoader(size: 80)),
      barrierDismissible: false,
    );
    
    for (var item in itemsToDelete) {
      // Using PhotosController's delete logic (which handles API + local state + Recently Deleted)
      final success = await photosController.deleteMedia(item, showSnackbar: false, showLoader: false);
      if (success) {
        currentAlbumPhotos.removeWhere((p) => p.id == item.id);
        deletedCount++;
      }
    }
    
    if (Get.isDialogOpen == true) Get.back(); // Remove loader
    
    if (deletedCount > 0) {
      Get.snackbar(
        'Deleted',
        '$deletedCount items deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
    
    clearSelection();
    // Refresh album list to update counts on the main screen
    fetchAlbums();
  }

  AlbumModel _mapToAlbumModel(AlbumData data) {
    // Get the last added item's URL to show as album preview
    String? lastAddedImageUrl;
    if (data.items != null && data.items!.isNotEmpty) {
      lastAddedImageUrl = data.items!.last.mediaUrl;
    }

    return AlbumModel(
      id: data.id.toString(),
      title: data.title ?? 'Untitled',
      photoCount: data.itemsCount ?? (data.items?.length ?? 0),
      imageUrl: lastAddedImageUrl,
      photoIds: data.items?.map((item) => item.mediaId.toString()).toList() ?? [],
    );
  }


  Future<String?> createAlbum(String title) async {
    try {
      isLoading.value = true;

      final response = await _apiService.createAlbum(
        title: title,
      );

      if (response.status != 'success') {
        Get.snackbar(
          'Error',
          response.message ?? 'Failed to create album',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return null;
      }

      if (response.data != null) {
        final newAlbum = _mapToAlbumModel(response.data!);

        albums.insert(0, newAlbum);

        return newAlbum.id;
      }

      // API succeeded but did not return album data.
      await fetchAlbums();

      return 'created';
    } catch (e) {
      debugPrint('Error in AlbumsController.createAlbum: $e');

      Get.snackbar(
        'Error',
        'Failed to create album',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }


  Future<bool> updateAlbum(String albumId, String newTitle) async {
    try {
      isLoading.value = true;
      final response = await _apiService.updateAlbum(albumId: albumId, title: newTitle);
      
      if (response.status == 'success' && response.data != null) {
        final updatedAlbum = _mapToAlbumModel(response.data!);
        final index = albums.indexWhere((a) => a.id == albumId);
        if (index != -1) {
          albums[index] = updatedAlbum;
          albums.refresh();
        }
        Get.snackbar(
          'Success',
          response.message ?? 'Album renamed successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error in AlbumsController.updateAlbum: $e');
      Get.snackbar(
        'Error',
        'Failed to rename album',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }


  Future<bool> deleteAlbum(String albumId) async {
    try {
      isLoading.value = true;

      final success = await _apiService.deleteAlbum(albumId);

      if (success) {
        albums.removeWhere((album) => album.id == albumId);
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Error in AlbumsController.deleteAlbum: $e');
      Get.snackbar(
        'Error',
        'Failed to delete album',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  Future<bool> addMediaToAlbum(String albumId, List<Map<String, dynamic>> mediaItems) async {
    try {
      isLoading.value = true;
      final response = await _apiService.addMediaToAlbum(
        albumId: albumId,
        items: mediaItems,
      );
      
      if (response.status == 'success' && response.data != null) {
        final updatedAlbum = _mapToAlbumModel(response.data!);
        
        final index = albums.indexWhere((a) => a.id == albumId);
        if (index != -1) {
          albums[index] = updatedAlbum;
        } else {
          albums.add(updatedAlbum);
        }
        
        Get.snackbar(
          'Success',
          response.message ?? 'Items added to album successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error in AlbumsController.addMediaToAlbum: $e');
      Get.snackbar(
        'Error',
        'Failed to add items to album',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
