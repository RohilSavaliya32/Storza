import 'package:get/get.dart';
import '../controller/photos_controller.dart';
import '../data/services/photo_api_service.dart';

class PhotosBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<PhotoApiService>()) {
      Get.lazyPut<PhotoApiService>(() => PhotoApiService(Get.find()), fenix: true);
    }

    Get.lazyPut<PhotosController>(
      () => PhotosController(Get.find<PhotoApiService>()),
    );
  }
}
