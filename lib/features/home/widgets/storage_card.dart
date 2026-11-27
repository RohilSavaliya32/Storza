import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../profile/controller/profile_controller.dart';

class StorageCard extends StatelessWidget {
  const StorageCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Accessing ProfileController for API-driven storage stats
    final profileController = Get.find<ProfileController>();

    return Obx(() {
      final data = profileController.storageStats.value?.data;
      
      // Using API data directly as requested, defaulting to 0 to avoid forced decimal
      final usedGB = data?.usedGb ?? 0;
      final totalGB = data?.totalQuotaGb ?? 0;
      final usedPercentage = data?.usedPercentage ?? 0;
      
      // Progress for the indicator (needs to be 0.0 to 1.0)
      double progress = (usedPercentage is num) ? (usedPercentage / 100).toDouble() : 0.0;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.cardBgLight,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 52,
              height: 52,
              child: Icon(Icons.cloud_outlined, color: AppColors.primary, size: 45),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Storage',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '$usedGB GB of $totalGB GB used',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress.clamp(0.0, 1.0),
                            minHeight: 6,
                            backgroundColor: AppColors.lightGrey,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '$usedPercentage%',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
