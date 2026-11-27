import 'package:get/get.dart';
import '../controller/albums_controller.dart';
import '../data/services/album_api_service.dart';

class AlbumsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlbumsController>(
      () => AlbumsController(Get.find<AlbumApiService>()),
    );
  }
}
