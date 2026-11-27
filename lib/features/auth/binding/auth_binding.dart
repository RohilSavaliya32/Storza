import 'package:get/get.dart';
import '../../../../core/network/dio_client.dart';
import '../controller/auth_controller.dart';
import '../controller/login_controller.dart';
import '../controller/register_controller.dart';
import '../controller/forgot_password_controller.dart';
import '../controller/otp_controller.dart';
import '../controller/reset_password_controller.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/services/auth_api_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Core
    Get.lazyPut<DioClient>(() => DioClient(), fenix: true);

    // Services
    Get.lazyPut<AuthApiService>(() => AuthApiService(Get.find<DioClient>()), fenix: true);

    // Repositories
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(Get.find<AuthApiService>()), fenix: true);

    // Controllers
    Get.put(AuthController(Get.find<AuthRepository>()), permanent: true);

    Get.lazyPut<LoginController>(() => LoginController(Get.find<AuthRepository>()));
    Get.lazyPut<RegisterController>(() => RegisterController());
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
    Get.lazyPut<OtpController>(() => OtpController());
    Get.lazyPut<ResetPasswordController>(() => ResetPasswordController());
  }
}
