import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/widgets/app_button.dart';
import '../../auth/controller/auth_controller.dart';

class AccountInfoView extends StatefulWidget {
  const AccountInfoView({super.key});

  @override
  State<AccountInfoView> createState() => _AccountInfoViewState();
}

class _AccountInfoViewState extends State<AccountInfoView> {
  final authController = Get.find<AuthController>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  File? _selectedImage;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    final user = authController.user.value;
    nameController = TextEditingController(text: user?.name ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _showImageSourceOptions() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Profile Photo',
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.camera_alt, color: AppColors.primary),
              ),
              title: const Text('Take a Photo', style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                Get.back();
                _handleImagePick(ImageSource.camera);
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.photo_library, color: AppColors.primary),
              ),
              title: const Text('Choose from Gallery', style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                Get.back();
                _handleImagePick(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _handleImagePick(ImageSource source) async {
    PermissionStatus status;
    
    if (source == ImageSource.camera) {
      status = await Permission.camera.request();
    } else {
      // For Gallery
      if (Platform.isAndroid) {
        // Android 13+ uses photos permission, older uses storage
        final androidInfo = await Permission.photos.status;
        if (androidInfo.isDenied || androidInfo.isPermanentlyDenied) {
           status = await Permission.photos.request();
           if (status.isPermanentlyDenied) {
             status = await Permission.storage.request();
           }
        } else {
           status = await Permission.photos.status;
        }
      } else {
        status = await Permission.photos.request();
      }
    }

    if (status.isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } else if (status.isPermanentlyDenied) {
      _showPermissionDialog();
    } else {
      // SnackbarUtils.error(
      //   'We need permission to access your ${source == ImageSource.camera ? 'camera' : 'gallery'} to update your profile photo.',
      //   title: 'Permission Denied',
      // );
    }
  }

  void _showPermissionDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Permission Required'),
        content: const Text('Permissions were permanently denied. Please enable them in settings to update your profile photo.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: const Text('Open Settings', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _saveProfile() async {
    if (nameController.text.trim().isEmpty) {
      // SnackbarUtils.error('Name cannot be empty');
      return;
    }

    setState(() => _isUpdating = true);

    try {
      // Profile update call
      authController.updateProfile(
        name: nameController.text.trim(),
        photoPath: _selectedImage?.path,
      );

      SnackbarUtils.success('Profile updated successfully');

      // Navigate back after short delay
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          Get.back();
        }
      });
    } catch (e) {
      // SnackbarUtils.error('Failed to update profile');
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Account Information',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Picture Section
            Center(
              child: GestureDetector(
                onTap: _showImageSourceOptions,
                child: Obx(() {
                  final user = authController.user.value;
                  return Stack(
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary.withOpacity(0.1), width: 4),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(55),
                          child: _selectedImage != null
                              ? Image.file(_selectedImage!, fit: BoxFit.cover)
                              : (user?.profilePhotoPath != null && user!.profilePhotoPath!.isNotEmpty
                                  ? (user.profilePhotoPath!.startsWith('http')
                                      ? Image.network(user.profilePhotoPath!, fit: BoxFit.cover)
                                      : Image.file(File(user.profilePhotoPath!), fit: BoxFit.cover))
                                  : Image.asset('lib/Assets/Logo.jpeg', fit: BoxFit.cover)),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: 35),

            // Input Fields
            _buildInfoField(
              label: 'Full Name',
              controller: nameController,
              icon: Icons.person_outline,
              hint: 'Enter your name',
            ),
            const SizedBox(height: 20),
            _buildInfoField(
              label: 'Email Address',
              controller: emailController,
              icon: Icons.email_outlined,
              enabled: false,
              hint: 'Your email address',
            ),
            const SizedBox(height: 60),

            AppButton(
              text: 'Save Changes',
              isLoading: _isUpdating,
              onPressed: _saveProfile,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool enabled = true,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: enabled ? Colors.white : AppColors.surface,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            controller: controller,
            enabled: enabled,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
            ),
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon, color: AppColors.primary, size: 22),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            ),
          ),
        ),
      ],
    );
  }
}
