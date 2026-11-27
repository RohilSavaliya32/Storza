import 'package:get/get.dart';
import '../../../../core/network/dio_client.dart';
import '../controller/profile_controller.dart';
import '../data/repositories/profile_repository.dart';
import '../data/repositories/profile_repository_impl.dart';
import '../data/services/profile_api_service.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileApiService>(() => ProfileApiService(Get.find<DioClient>()));
    Get.lazyPut<ProfileRepository>(() => ProfileRepositoryImpl(Get.find<ProfileApiService>()));
    Get.lazyPut<ProfileController>(
      () => ProfileController(Get.find<ProfileRepository>()),
    );
  }
}
