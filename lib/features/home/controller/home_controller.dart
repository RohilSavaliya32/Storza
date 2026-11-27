import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final searchController = TextEditingController();

  Future<void> refreshData() async {
    // Add your data fetching logic here
    // For example:
    // await fetchStorageStats();
    // await fetchRecentFiles();
    
    // Simulating a delay for now
    await Future.delayed(const Duration(seconds: 1));
    update(); // Triggers UI update if using GetBuilder
  }

  void clearSearch() {
    searchController.clear();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
