import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../../photos/controller/photos_controller.dart';
import '../../videos/controller/video_controller.dart';
import '../../videos/data/services/video_api_service.dart';
import '../../favorites/controller/favorites_controller.dart';
import '../../recently_deleted/controller/recently_deleted_controller.dart';
import '../../photos/data/services/photo_api_service.dart';
import '../../../../core/network/dio_client.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    
    if (!Get.isRegistered<PhotoApiService>()) {
      Get.lazyPut<PhotoApiService>(() => PhotoApiService(Get.find<DioClient>()), fenix: true);
    }
    
    if (!Get.isRegistered<VideoApiService>()) {
      Get.lazyPut<VideoApiService>(() => VideoApiService(Get.find<DioClient>()), fenix: true);
    }
    
    Get.lazyPut<PhotosController>(() => PhotosController(Get.find<PhotoApiService>()));
    Get.lazyPut<VideoController>(() => VideoController(Get.find<VideoApiService>()));
    Get.lazyPut<FavoritesController>(() => FavoritesController());
    Get.lazyPut<RecentlyDeletedController>(() => RecentlyDeletedController());
  }
}
