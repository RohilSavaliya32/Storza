import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../auth/data/repositories/auth_repository.dart';

class SplashController extends GetxController {
  final AuthRepository _authRepository;

  SplashController(this._authRepository);

  @override
  void onInit() {
    super.onInit();
    _handleNavigation();
  }

  void _handleNavigation() async {
    await Future.delayed(const Duration(seconds: 2));
    
    final token = _authRepository.getToken();
    if (token != null && token.isNotEmpty) {
      Get.offAllNamed(Routes.MAIN_NAVIGATION);
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
