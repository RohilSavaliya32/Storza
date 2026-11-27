import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../core/utils/share_helper.dart';
import '../data/models/photo_model.dart';
import '../controller/photos_controller.dart';

class PhotoPreviewView extends StatefulWidget {
  final List<PhotoModel>? photos;
  final int initialIndex;

  const PhotoPreviewView({
    super.key,
    this.photos,
    this.initialIndex = 0,
  });

  @override
  State<PhotoPreviewView> createState() => _PhotoPreviewViewState();
}

class _PhotoPreviewViewState extends State<PhotoPreviewView> {
  late PageController _pageController;
  late int _currentIndex;
  late List<PhotoModel> _photoList;
  bool _showUI = true;

  @override
  void initState() {
    super.initState();
    
    if (widget.photos != null) {
      _photoList = List.from(widget.photos!);
      _currentIndex = widget.initialIndex;
    } else if (Get.arguments != null && Get.arguments is Map) {
      _photoList = List.from(Get.arguments['photos'] as List<PhotoModel>? ?? []);
      _currentIndex = Get.arguments['index'] ?? 0;
    } else {
      _photoList = [];
      _currentIndex = 0;
    }
    
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _toggleUI() {
    setState(() {
      _showUI = !_showUI;
    });
  }

  void _confirmDelete() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.delete_outline, color: AppColors.red, size: 48),
              const SizedBox(height: 16),
              const Text(
                "Delete Media?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "This item will be moved to recently deleted.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: const Text("Cancel", style: TextStyle(color: AppColors.textPrimary)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        final itemToDelete = _photoList[_currentIndex];
                        Get.find<PhotosController>().deleteMedia(itemToDelete);
                        
                        setState(() {
                          _photoList.removeAt(_currentIndex);
                          if (_photoList.isEmpty) {
                            Get.back();
                          } else if (_currentIndex >= _photoList.length) {
                            _currentIndex = _photoList.length - 1;
                            _pageController.jumpToPage(_currentIndex);
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Delete", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            _buildMenuOption(Icons.info_outline, 'Details', () => Get.back()),
            _buildMenuOption(Icons.edit_outlined, 'Edit', () => Get.back()),
            _buildMenuOption(Icons.share_outlined, 'Share', () {
              Get.back();
              ShareHelper.shareMedia(_photoList[_currentIndex].url);
            }),
            _buildActionMenuOption(Icons.file_download_outlined, 'Download', () {
              Get.back();
              Get.find<PhotosController>().downloadMedia(_photoList[_currentIndex].url);
            }),
            _buildMenuOption(Icons.wallpaper, 'Set as wallpaper', () => Get.back()),
            _buildMenuOption(Icons.print_outlined, 'Print', () => Get.back()),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 10),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  Widget _buildActionMenuOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_photoList.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: Text('No images to display', style: TextStyle(color: Colors.white))),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: _showUI 
        ? AppBar(
            backgroundColor: Colors.black.withOpacity(0.5),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              '${_currentIndex + 1} / ${_photoList.length}',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: _showMoreOptions,
              ),
            ],
          )
        : null,
      body: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: _toggleUI,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _photoList.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Center(
                    child: AppNetworkImage(
                      imageUrl: _photoList[index].url,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                );
              },
            ),
          ),
          
          if (_showUI) ...[
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildAction(Icons.share_outlined, 'Share', () {
                          ShareHelper.shareMedia(_photoList[_currentIndex].url);
                        }),
                        _buildAction(Icons.file_download_outlined, 'Download', () {
                          Get.find<PhotosController>().downloadMedia(_photoList[_currentIndex].url);
                        }),
                        _buildAction(Icons.delete_outline, 'Delete', _confirmDelete),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
