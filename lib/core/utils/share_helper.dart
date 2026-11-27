import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import '../widgets/app_loader.dart';
import 'package:flutter/material.dart';
import 'snackbar_utils.dart';

class ShareHelper {
  static Future<void> shareMedia(String url) async {
    await shareMultipleMedia([url]);
  }

  static Future<void> shareMultipleMedia(List<String> urls) async {
    try {
      // Show loading
      Get.dialog(
        const Center(child: AppLoader(size: 60)),
        barrierDismissible: false,
      );

      List<XFile> xFiles = [];
      final documentDirectory = await getTemporaryDirectory();

      for (var url in urls) {
        if (url.startsWith('http')) {
          final response = await http.get(Uri.parse(url));
          final fileName = url.split('/').last.split('?').first;
          final file = File('${documentDirectory.path}/$fileName');
          await file.writeAsBytes(response.bodyBytes);
          xFiles.add(XFile(file.path));
        } else {
          String filePath = url;
          if (filePath.startsWith('file:')) {
            filePath = Uri.parse(filePath).toFilePath();
          }
          xFiles.add(XFile(filePath));
        }
      }

      // Close loading
      if (Get.isDialogOpen ?? false) Get.back();

      if (xFiles.isNotEmpty) {
        // Text parameter removed as requested
        await Share.shareXFiles(xFiles);
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
    }
  }
}
