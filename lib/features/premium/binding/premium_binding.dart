import 'package:get/get.dart';
import '../../../../core/network/dio_client.dart';
import '../controller/premium_controller.dart';
import '../data/repositories/premium_repository.dart';
import '../data/repositories/premium_repository_impl.dart';
import '../data/services/subscription_service.dart';

class PremiumBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubscriptionService>(() => SubscriptionService(Get.find<DioClient>()));
    Get.lazyPut<PremiumRepository>(() => PremiumRepositoryImpl(Get.find<SubscriptionService>()));
    Get.lazyPut<PremiumController>(
      () => PremiumController(Get.find<PremiumRepository>()),
    );
  }
}
