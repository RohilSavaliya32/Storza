import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/share_helper.dart';
import '../../../core/widgets/app_loader.dart';
import '../../photos/data/models/photo_model.dart';
import '../../photos/controller/photos_controller.dart';

class VideoPlayerView extends StatefulWidget {
  final PhotoModel? video;
  const VideoPlayerView({super.key, this.video});

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isError = false;
  PhotoModel? _videoData;
  bool _showControls = true;
  String _errorMsg = "Loading...";

  @override
  void initState() {
    super.initState();
    _videoData = widget.video ?? (Get.arguments is PhotoModel ? Get.arguments as PhotoModel : null);
    
    if (_videoData != null) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _initializePlayer();
      });
    } else {
      _isError = true;
      _errorMsg = "No video data found";
    }
  }

  void _videoListener() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _initializePlayer() async {
    if (_videoData == null) return;
    final String url = _videoData!.url;
    
    try {
      if (url.startsWith('http')) {
        _controller = VideoPlayerController.networkUrl(Uri.parse(url));
      } else {
        String path = url;
        if (path.startsWith('file:')) {
          path = Uri.parse(path).toFilePath();
        }
        
        final file = File(path);
        if (!await file.exists()) {
          throw Exception("File not found");
        }
        _controller = VideoPlayerController.file(file);
      }

      await _controller!.initialize();
      _controller!.addListener(_videoListener);
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _isError = false;
        });
        _controller!.play();
        _controller!.setLooping(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isError = true;
          _errorMsg = "Could not play video.";
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
    _controller?.pause();
    _controller?.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  void _confirmDelete() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.delete_outline, color: AppColors.red, size: 48),
              const SizedBox(height: 16),
              const Text("Delete Video?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("This video will be moved to trash.", textAlign: TextAlign.center),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        if (_videoData != null) {
                          Get.find<PhotosController>().deleteMedia(_videoData!);
                          Get.back(); 
                          Get.back();
                        }
                      },
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
              width: 40, height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
            ),
            _buildMenuOption(Icons.info_outline, 'Details', () => Get.back()),
            _buildMenuOption(Icons.share_outlined, 'Share', () {
              Get.back();
              if (_videoData != null) {
                ShareHelper.shareMedia(_videoData!.url);
              }
            }),
            _buildMenuOption(Icons.file_download_outlined, 'Download', () {
              Get.back();
              if (_videoData != null) {
                Get.find<PhotosController>().downloadMedia(_videoData!.url);
              }
            }),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: _showControls 
        ? AppBar(
            backgroundColor: Colors.black.withOpacity(0.5),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              onPressed: () => Get.back(),
            ),
            title: null,
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: _showMoreOptions,
              ),
            ],
          )
        : null,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => setState(() => _showControls = !_showControls),
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: _isError 
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.white54, size: 60),
                        const SizedBox(height: 16),
                        Text(_errorMsg, style: const TextStyle(color: Colors.white70)),
                        const SizedBox(height: 20),
                        ElevatedButton(onPressed: _initializePlayer, child: const Text("Retry")),
                      ],
                    )
                  : (_isInitialized && _controller != null)
                    ? AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      )
                    : const AppLoader(size: 80),
              ),
            ),
          ),

          if (_showControls && _isInitialized) ...[
            Center(
              child: GestureDetector(
                onTap: () => setState(() => _controller!.value.isPlaying ? _controller!.pause() : _controller!.play()),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.black38, shape: BoxShape.circle),
                  child: Icon(
                    _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow, 
                    color: Colors.white, 
                    size: 64
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter, 
                    end: Alignment.topCenter, 
                    colors: [Colors.black.withOpacity(0.9), Colors.transparent]
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(_controller!.value.position),
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            _formatDuration(_controller!.value.duration),
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    VideoProgressIndicator(
                      _controller!, 
                      allowScrubbing: true, 
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      colors: const VideoProgressColors(
                        playedColor: AppColors.primary,
                        bufferedColor: Colors.white24,
                        backgroundColor: Colors.white12,
                      ),
                    ),
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildAction(Icons.share_outlined, 'Share', () {
                              if (_videoData != null) {
                                ShareHelper.shareMedia(_videoData!.url);
                              }
                            }),
                            _buildAction(Icons.file_download_outlined, 'Download', () {
                              if (_videoData != null) {
                                Get.find<PhotosController>().downloadMedia(_videoData!.url);
                              }
                            }),
                            _buildAction(Icons.delete_outline, 'Delete', _confirmDelete),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAction(IconData icon, String label, [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}
