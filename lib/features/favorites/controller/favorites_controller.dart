import 'package:get/get.dart';
import '../../photos/data/models/photo_model.dart';

class FavoritesController extends GetxController {
  final RxList<PhotoModel> favoritePhotos = <PhotoModel>[].obs;

  void updateFavorites(PhotoModel photo) {
    if (photo.isFavorite) {
      if (!favoritePhotos.any((p) => p.id == photo.id)) {
        favoritePhotos.add(photo);
      }
    } else {
      favoritePhotos.removeWhere((p) => p.id == photo.id);
    }
  }
}
