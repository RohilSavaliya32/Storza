import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../theme/app_colors.dart';
import '../constants/storage_keys.dart';
import 'app_loader.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final bool useLoader;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.useLoader = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(12);
    
    // Clean the URL to avoid any whitespace issues
    final String cleanUrl = imageUrl.trim();
    
    if (cleanUrl.isEmpty) {
      return _buildPlaceholder();
    }

    bool isNetwork = cleanUrl.startsWith('http');
    bool isAsset = cleanUrl.startsWith('lib/Assets/') || cleanUrl.startsWith('assets/');
    bool isLocalFile = !isNetwork && !isAsset;
    bool isVideo = cleanUrl.toLowerCase().endsWith('.mp4') || cleanUrl.toLowerCase().endsWith('.mov');

    return Container(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      decoration: BoxDecoration(
        borderRadius: effectiveBorderRadius,
        color: AppColors.greyBg,
      ),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: isVideo && isLocalFile 
            ? _buildVideoPlaceholder() 
            : _buildImage(isNetwork, isAsset, isLocalFile, cleanUrl),
      ),
    );
  }

  Widget _buildVideoPlaceholder() {
    return Container(
      color: Colors.black87,
      child: const Center(
        child: Icon(Icons.play_circle_outline, color: Colors.white54, size: 40),
      ),
    );
  }

  Widget _buildImage(bool isNetwork, bool isAsset, bool isLocalFile, String url) {
    if (isLocalFile) {
      return Image.file(
        File(url.startsWith('file:') ? Uri.parse(url).toFilePath() : url),
        width: double.infinity,
        height: double.infinity,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    } else if (isAsset) {
      return Image.asset(
        url,
        width: double.infinity,
        height: double.infinity,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    } else if (isNetwork) {
      // Fetch token from GetStorage
      final token = GetStorage().read(StorageKeys.token);
      
      return Image.network(
        url,
        // Passing Bearer token in headers for protected images
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'Accept': '*/*',
        },
        width: double.infinity,
        height: double.infinity,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(child: AppLoader(size: useLoader ? 40 : 20));
        },
        errorBuilder: (context, error, stackTrace) {
          debugPrint('❌ Image Load Error: $error | URL: $url');
          if (token == null) debugPrint('⚠️ Warning: Authorization Token is missing in GetStorage');
          return _buildPlaceholder();
        },
      );
    } else {
      return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.greyBg,
      child: const Center(
        child: Icon(Icons.image_outlined, color: AppColors.textSecondary, size: 30),
      ),
    );
  }
}
