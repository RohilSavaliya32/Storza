import 'package:get/get.dart';
import '../controller/splash_controller.dart';
import '../../auth/data/repositories/auth_repository.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController(Get.find<AuthRepository>()));
  }
}
