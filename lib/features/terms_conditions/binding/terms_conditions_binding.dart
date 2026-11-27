import 'package:get/get.dart';
import '../controller/terms_conditions_controller.dart';
import '../data/services/terms_conditions_service.dart';
import '../../../../core/network/dio_client.dart';

class TermsConditionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TermsConditionsService(Get.find<DioClient>()));
    Get.lazyPut(() => TermsConditionsController(Get.find<TermsConditionsService>()));
  }
}
