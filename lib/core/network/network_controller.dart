import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import '../widgets/connection_lost_widget.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> connectivityResults) {
    if (connectivityResults.contains(ConnectivityResult.none) || connectivityResults.isEmpty) {
      if (Get.currentRoute != '/no-internet') {
        Get.to(
          () => ConnectionLostWidget(
            onRetry: () => _checkStatus(),
          ),
          routeName: '/no-internet',
          transition: Transition.fade,
        );
      }
    } else {
      if (Get.currentRoute == '/no-internet') {
        Get.back();
      }
    }
  }

  Future<void> _checkStatus() async {
    var result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result);
  }
}
