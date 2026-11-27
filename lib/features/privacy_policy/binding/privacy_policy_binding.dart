import 'package:get/get.dart';
import '../controller/privacy_policy_controller.dart';
import '../data/services/privacy_policy_service.dart';
import '../../../../core/network/dio_client.dart';

class PrivacyPolicyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PrivacyPolicyService(Get.find<DioClient>()));
    Get.lazyPut(() => PrivacyPolicyController(Get.find<PrivacyPolicyService>()));
  }
}
