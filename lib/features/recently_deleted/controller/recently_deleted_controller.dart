import 'package:get/get.dart';
import '../../photos/data/models/photo_model.dart';

class RecentlyDeletedController extends GetxController {
  final RxList<PhotoModel> deletedItems = <PhotoModel>[].obs;

  void addMedia(PhotoModel item) {
    deletedItems.insert(0, item);
  }

  void restoreMedia(PhotoModel item) {
    deletedItems.removeWhere((p) => p.id == item.id);
  }

  void permanentlyDelete(String id) {
    deletedItems.removeWhere((p) => p.id == id);
  }

  void clearTrash() {
    deletedItems.clear();
  }
}
