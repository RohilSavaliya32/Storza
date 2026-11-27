import 'package:get/get.dart';
import '../controller/video_controller.dart';
import '../data/services/video_api_service.dart';
import '../../../../core/network/dio_client.dart';

class VideosBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<VideoApiService>()) {
      Get.lazyPut<VideoApiService>(() => VideoApiService(Get.find<DioClient>()), fenix: true);
    }
    Get.lazyPut<VideoController>(
      () => VideoController(Get.find<VideoApiService>()),
    );
  }
}
