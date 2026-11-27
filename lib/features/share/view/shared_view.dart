import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';

class SharedView extends StatelessWidget {
  final bool showBackButton;

  const SharedView({
    super.key,
    this.showBackButton = true,
  });

  // Show delete confirmation dialog
  void _showDeleteConfirmation(
      BuildContext context,
      String itemName,
      ) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.red,
                  size: 32,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Delete Shared Item?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Are you sure you want to delete '$itemName'? "
                    'This action cannot be undone.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 28),

              Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        side: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Delete button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // App bar
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,

        leading: showBackButton
            ? IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Get.back(),
        )
            : null,

        title: const Text(
          'Shared Links',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      // Shared items list
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 70),
        itemCount: 8,
        itemBuilder: (context, index) {
          final bool isFolder = index % 3 == 0;

          final String itemName = isFolder
              ? 'Work Documents'
              : 'Vacation_Photo_$index.jpg';

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.surface.withOpacity(0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),

            child: Row(
              children: [
                // File or folder icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (
                        isFolder
                            ? AppColors.primary
                            : AppColors.orange
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    isFolder
                        ? Icons.folder_rounded
                        : Icons.image_rounded,
                    color: isFolder
                        ? AppColors.primary
                        : AppColors.orange,
                    size: 26,
                  ),
                ),

                const SizedBox(width: 16),

                // Item details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        itemName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      const SizedBox(height: 4),

                      const Text(
                        'Expires in 2 hours',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Item options
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: AppColors.textSecondary,
                    size: 22,
                  ),
                  padding: EdgeInsets.zero,
                  surfaceTintColor: Colors.white,
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),

                  onSelected: (value) {
                    if (value == 'delete') {
                      _showDeleteConfirmation(
                        context,
                        itemName,
                      );
                    }
                  },

                  itemBuilder: (context) => [
                    // Share again option
                    PopupMenuItem<String>(
                      value: 'share',
                      height: 40,
                      child: Row(
                        children: [
                          Icon(
                            Icons.share_outlined,
                            size: 18,
                            color: Colors.blue.shade700,
                          ),

                          const SizedBox(width: 12),

                          const Text(
                            'Share Again',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const PopupMenuDivider(height: 1),

                    // Delete option
                    const PopupMenuItem<String>(
                      value: 'delete',
                      height: 40,
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline_rounded,
                            size: 18,
                            color: AppColors.red,
                          ),

                          SizedBox(width: 12),

                          Text(
                            'Delete',
                            style: TextStyle(
                              color: AppColors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),

      // Create share link button
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'sharedFAB',
        onPressed: () => Get.toNamed(Routes.CREATE_SHARE),
        backgroundColor: AppColors.primary,

        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),

        label: const Text(
          'Create Link',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}