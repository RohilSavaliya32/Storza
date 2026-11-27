import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_loader.dart';
import '../../upload/view/upload_view.dart';
import '../widgets/quick_access_section.dart';
import '../widgets/recent_section.dart';
import '../widgets/storage_card.dart';
import '../controller/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: const Text(
            'Home',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            //   child: Container(
            //     height: 52,
            //     decoration: BoxDecoration(
            //       color: AppColors.surface,
            //       borderRadius: BorderRadius.circular(28),
            //     ),
            //     child: TextField(
            //       controller: homeController.searchController,
            //       autofocus: false,
            //       textAlignVertical: TextAlignVertical.center,
            //       style: const TextStyle(
            //         color: AppColors.textPrimary,
            //         fontSize: 14,
            //       ),
            //       decoration: InputDecoration(
            //         filled: true,
            //         fillColor: AppColors.surface,
            //         hintText: 'Search photos, videos...',
            //         hintStyle: const TextStyle(
            //           color: AppColors.textSecondary,
            //           fontSize: 14,
            //         ),
            //         prefixIcon: const Icon(
            //           Icons.search_rounded,
            //           color: AppColors.textSecondary,
            //           size: 25,
            //         ),
            //         prefixIconConstraints: const BoxConstraints(
            //           minWidth: 52,
            //           minHeight: 52,
            //         ),
            //         suffixIconConstraints: const BoxConstraints(
            //           minWidth: 52,
            //           minHeight: 52,
            //         ),
            //         contentPadding: const EdgeInsets.symmetric(
            //           horizontal: 8,
            //         ),
            //         border: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(28),
            //           borderSide: BorderSide.none,
            //         ),
            //         enabledBorder: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(28),
            //           borderSide: BorderSide.none,
            //         ),
            //         focusedBorder: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(28),
            //           borderSide: BorderSide.none,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: homeController.refreshData,
                color: AppColors.primary,
                backgroundColor: AppColors.surface,
                child: const SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StorageCard(),
                      SizedBox(height: 25),
                      QuickAccessSection(),
                      SizedBox(height: 25),
                      RecentSection(),
                      SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'homeFAB',
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();

            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) => const UploadView(),
            );
          },
          backgroundColor: AppColors.primary,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}
