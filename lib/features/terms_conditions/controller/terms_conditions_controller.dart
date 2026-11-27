import 'package:get/get.dart';
import '../data/models/terms_conditions_model.dart';
import '../data/services/terms_conditions_service.dart';

class TermsConditionsController extends GetxController {
  final TermsConditionsService _service;

  TermsConditionsController(this._service);

  final Rxn<TermsConditionsModel> termsConditions = Rxn<TermsConditionsModel>();
  final RxBool isLoading = true.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchTermsConditions();
  }

  Future<void> fetchTermsConditions() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      final result = await _service.getTermsConditions();
      termsConditions.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
