import 'package:get/get.dart';
import '../data/models/privacy_policy_model.dart';
import '../data/services/privacy_policy_service.dart';

class PrivacyPolicyController extends GetxController {
  final PrivacyPolicyService _service;

  PrivacyPolicyController(this._service);

  final Rxn<PrivacyPolicyModel> privacyPolicy = Rxn<PrivacyPolicyModel>();
  final RxBool isLoading = true.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchPrivacyPolicy();
  }

  Future<void> fetchPrivacyPolicy() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      final result = await _service.getPrivacyPolicy();
      privacyPolicy.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
