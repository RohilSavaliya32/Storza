import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_network_image.dart';
import '../data/models/photo_model.dart';

class PhotoGridItem extends StatelessWidget {
  final String imageUrl;
  final MediaType type;
  final bool isSelected;
  final bool isSelectionMode;
  final bool showPlayIcon;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  // These parameters are kept to avoid breaking other files during the cleanup,
  // but the Favorite Icon has been removed from the UI as requested.
  final bool? isFavorite;
  final VoidCallback? onFavoriteTap;

  const PhotoGridItem({
    super.key,
    required this.imageUrl,
    this.type = MediaType.image,
    this.isSelected = false,
    this.isSelectionMode = false,
    this.showPlayIcon = true,
    this.onTap,
    this.onLongPress,
    this.isFavorite,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: isSelected ? const EdgeInsets.all(8) : EdgeInsets.zero,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: isSelected ? AppColors.primary.withOpacity(0.2) : Colors.transparent,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(isSelected ? 10 : 16),
                child: AppNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          if (type == MediaType.video && !isSelectionMode && showPlayIcon)
            const Center(
              child: Icon(
                Icons.play_circle_fill,
                color: Colors.white70,
                size: 30,
              ),
            ),

          // Selection Checkmark
          if (isSelectionMode)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Icon(
                  Icons.check,
                  color: isSelected ? Colors.white : Colors.transparent,
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
