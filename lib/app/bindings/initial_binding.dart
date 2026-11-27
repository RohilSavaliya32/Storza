import 'package:get/get.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/network_controller.dart';
import '../../features/auth/controller/auth_controller.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/services/auth_api_service.dart';
import '../../features/home/controller/home_controller.dart';
import '../../features/photos/controller/photos_controller.dart';
import '../../features/favorites/controller/favorites_controller.dart';
import '../../features/albums/controller/albums_controller.dart';
import '../../features/albums/data/services/album_api_service.dart';
import '../../features/photos/data/services/photo_api_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core & Network
    Get.put(NetworkController(), permanent: true);
    Get.lazyPut<DioClient>(() => DioClient(), fenix: true);
    Get.lazyPut<AuthApiService>(() => AuthApiService(Get.find<DioClient>()), fenix: true);
    Get.lazyPut<PhotoApiService>(() => PhotoApiService(Get.find<DioClient>()), fenix: true);
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(Get.find<AuthApiService>()), fenix: true);

    // Auth
    Get.put(AuthController(Get.find<AuthRepository>()), permanent: true);

    // Services
    Get.lazyPut<AlbumApiService>(() => AlbumApiService(Get.find<DioClient>(), Get.find<AuthRepository>()), fenix: true);

    // Other Controllers
    Get.put(HomeController(), permanent: true);
    Get.put(PhotosController(Get.find<PhotoApiService>()), permanent: true);
    Get.put(FavoritesController(), permanent: true);
    Get.put(AlbumsController(Get.find<AlbumApiService>()), permanent: true);
  }
}
