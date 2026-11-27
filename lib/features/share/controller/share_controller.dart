import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/share_link_model.dart';
import '../data/services/share_api_service.dart';

class ShareController extends GetxController {
  final ShareApiService _apiService;

  ShareController(this._apiService);

  final RxList<ShareItemRequest> selectedItems = <ShareItemRequest>[].obs;
  final RxString selectedExpiry = '7_days'.obs;
  final RxBool isLoading = false.obs;
  final Rx<ShareLinkModel?> createdLink = Rx<ShareLinkModel?>(null);

  @override
  void onInit() {
    super.onInit();
    // Check if items were passed through arguments
    if (Get.arguments != null && Get.arguments is List<ShareItemRequest>) {
      selectedItems.assignAll(Get.arguments);
    }
  }

  void setSelectedItems(List<ShareItemRequest> items) {
    selectedItems.assignAll(items);
  }

  Future<void> createShareLink({required String title}) async {
    if (selectedItems.isEmpty) {
      Get.snackbar(
        'Error',
        'No items selected to share',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final request = CreateShareRequest(
        title: title,
        duration: selectedExpiry.value,
        items: selectedItems,
      );
      
      final result = await _apiService.createShareLink(request);
      createdLink.value = result;
      Get.snackbar(
        'Success',
        'Share link created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // Navigate to shared links list or show success
      // Get.back(); 
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create share link: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

    void updateExpiry(String value) {
      switch (value) {
        case 'One Time View':
          selectedExpiry.value = 'one_time';
          break;
        case '10 Minutes':
          selectedExpiry.value = '10_mins';
          break;
        case '1 Hour':
          selectedExpiry.value = '1_hour';
          break;
        case '24 Hours':
          selectedExpiry.value = '24_hours';
          break;
        case '7 Days':
          selectedExpiry.value = '7_days';
          break;
        default:
          selectedExpiry.value = '7_days';
      }
    }
}
