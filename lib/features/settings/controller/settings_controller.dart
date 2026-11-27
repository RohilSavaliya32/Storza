import 'package:get/get.dart';

class SettingsController extends GetxController {
  final backupSync = true.obs;
  final wifiOnly = false.obs;
  final appLock = true.obs;
  final twoFactor = false.obs;

  void toggleBackupSync(bool value) => backupSync.value = value;
  void toggleWifiOnly(bool value) => wifiOnly.value = value;
  void toggleAppLock(bool value) => appLock.value = value;
  void toggleTwoFactor(bool value) => twoFactor.value = value;
}
