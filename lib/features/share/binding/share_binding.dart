import 'package:get/get.dart';

import '../../../core/network/dio_client.dart';
import '../controller/share_controller.dart';
import '../data/services/share_api_service.dart';

class ShareBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShareApiService>(
          () => ShareApiService(Get.find<DioClient>()),
      fenix: true,
    );

    Get.lazyPut<ShareController>(
          () => ShareController(Get.find<ShareApiService>()),
      fenix: true,
    );
  }
}