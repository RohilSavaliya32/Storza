import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/controller/auth_controller.dart';
import '../../navigation/controller/navigation_controller.dart';
// import '../../favorites/controller/favorites_controller.dart';
import '../../recently_deleted/controller/recently_deleted_controller.dart';
import '../../albums/controller/albums_controller.dart';
import '../controller/profile_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // final favoritesController = Get.find<FavoritesController>();
    final deletedController = Get.find<RecentlyDeletedController>();
    final authController = Get.find<AuthController>();
    final albumsController = Get.find<AlbumsController>();
    final profileController = Get.find<ProfileController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: RefreshIndicator(
          onRefresh: () => profileController.fetchStorageStats(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.ACCOUNT_INFO),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 10, 20, 22),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF6752E8), Color(0xFF7459E8)],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(28),
                        bottomRight: Radius.circular(28),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Obx(() {
                          final user = authController.user.value;
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 68,
                                height: 68,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(34),
                                  child: user?.profilePhotoUrl != null
                                      ? Image.network(
                                          user!.profilePhotoUrl!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) =>
                                              Image.asset('lib/Assets/Logo.jpeg', fit: BoxFit.cover),
                                        )
                                      : Image.asset('lib/Assets/Logo.jpeg', fit: BoxFit.cover),
                                ),
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user?.name ?? 'Guest User',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      user?.email ?? 'Not Logged In',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Text(
                                  'Free Plan',
                                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Obx(() {
                        final data = profileController.storageStats.value?.data;
                        // Displaying raw API values directly
                        final usedGB = data?.usedGb ?? 0;
                        final totalGB = data?.totalQuotaGb ?? 0;
                        
                        return _buildMenuItem(
                          icon: Icons.cloud_outlined,
                          label: 'Storage',
                          trailingText: '$usedGB GB of $totalGB GB used',
                          iconColor: Colors.teal,
                          onTap: () => Get.toNamed(Routes.STORAGE),
                        );
                      }),
                      _buildMenuItem(
                        icon: Icons.subscriptions_outlined,
                        label: 'Subscription',
                        trailingText: 'Free Plan',
                        iconColor: Colors.orange,
                        onTap: () => Get.toNamed(Routes.PREMIUM),
                      ),
                      _buildMenuItem(
                        icon: Icons.link_outlined,
                        label: 'Shared Links',
                        trailingText: '12 Links',
                        iconColor: Colors.green,
                        onTap: () {
                          Get.find<NavigationController>().changeIndex(2);
                        },
                      ),
                      Obx(() => _buildMenuItem(
                        icon: Icons.folder_open_outlined,
                        label: 'Albums',
                        trailingText: '${albumsController.albums.length} Albums',
                        iconColor: Colors.purple,
                        onTap: () {
                          Get.find<NavigationController>().changeIndex(1);
                        },
                      )),
                      // Obx(() => _buildMenuItem(
                      //   icon: Icons.favorite_border,
                      //   label: 'Favorites',
                      //   trailingText: '${favoritesController.favoritePhotos.length} Items',
                      //   iconColor: Colors.red,
                      //   onTap: () => Get.toNamed(Routes.FAVORITES),
                      // )),
                      Obx(() => _buildMenuItem(
                        icon: Icons.delete_outline,
                        label: 'Recently Deleted',
                        trailingText: '${deletedController.deletedItems.length} Items',
                        iconColor: Colors.grey,
                        onTap: () => Get.toNamed(Routes.RECENTLY_DELETED),
                      )),

                      _buildMenuItem(
                        icon: Icons.settings_outlined,
                        label: 'Settings',
                        iconColor: Colors.blue,
                        onTap: () => Get.toNamed(Routes.SETTINGS),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    String? trailingText,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.surface),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            ),
            if (trailingText != null)
              Text(trailingText, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary, size: 14),
          ],
        ),
      ),
    );
  }
}
