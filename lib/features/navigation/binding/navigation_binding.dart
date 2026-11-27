import 'package:get/get.dart';
import '../controller/navigation_controller.dart';
import '../../home/controller/home_controller.dart';
import '../../photos/controller/photos_controller.dart';
import '../../videos/controller/video_controller.dart';
import '../../videos/data/services/video_api_service.dart';
import '../../favorites/controller/favorites_controller.dart';
import '../../recently_deleted/controller/recently_deleted_controller.dart';
import '../../albums/controller/albums_controller.dart';
import '../../albums/data/services/album_api_service.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/data/repositories/auth_repository.dart';
import '../../photos/data/services/photo_api_service.dart';
import '../../profile/controller/profile_controller.dart';
import '../../profile/data/repositories/profile_repository.dart';
import '../../profile/data/repositories/profile_repository_impl.dart';
import '../../profile/data/services/profile_api_service.dart';
import '../../../../core/network/dio_client.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    // AuthController is required by ProfileView inside MainNavigation
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController(Get.find<AuthRepository>()), permanent: true);
    }

    Get.lazyPut<NavigationController>(() => NavigationController());
    Get.lazyPut<HomeController>(() => HomeController());
    
    // Check if PhotoApiService is registered
    if (!Get.isRegistered<PhotoApiService>()) {
      Get.lazyPut<PhotoApiService>(() => PhotoApiService(Get.find<DioClient>()), fenix: true);
    }

    // Check if VideoApiService is registered
    if (!Get.isRegistered<VideoApiService>()) {
      Get.lazyPut<VideoApiService>(() => VideoApiService(Get.find<DioClient>()), fenix: true);
    }
    
    Get.put(PhotosController(Get.find<PhotoApiService>()));
    Get.put(VideoController(Get.find<VideoApiService>()));
    Get.put(FavoritesController());
    Get.put(RecentlyDeletedController());
    
    // Check if AlbumApiService is registered
    if (!Get.isRegistered<AlbumApiService>()) {
      Get.lazyPut<AlbumApiService>(
        () => AlbumApiService(Get.find<DioClient>(), Get.find<AuthRepository>()),
        fenix: true,
      );
    }
    
    Get.put(AlbumsController(Get.find<AlbumApiService>()));

    // Register Profile dependencies for StorageCard and ProfileView
    if (!Get.isRegistered<ProfileApiService>()) {
      Get.lazyPut<ProfileApiService>(() => ProfileApiService(Get.find<DioClient>()));
    }
    if (!Get.isRegistered<ProfileRepository>()) {
      Get.lazyPut<ProfileRepository>(() => ProfileRepositoryImpl(Get.find<ProfileApiService>()));
    }
    if (!Get.isRegistered<ProfileController>()) {
      Get.put(ProfileController(Get.find<ProfileRepository>()));
    }
  }
}
