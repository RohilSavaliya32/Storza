import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../home/controller/home_controller.dart';

class NavigationController extends GetxController {
  final _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  void changeIndex(int index) {
    // Premium tab (index 3) ko ab IndexedStack ke andar handle karenge
    _currentIndex.value = index;
    
    // Clear search bar when tab changes
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().clearSearch();
    }
  }
}
