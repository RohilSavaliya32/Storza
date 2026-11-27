import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../data/models/plan_model.dart';
import '../data/repositories/premium_repository.dart';

class PremiumController extends GetxController {
  final PremiumRepository _premiumRepository;

  PremiumController(this._premiumRepository);

  final RxList<PlanModel> plans = <PlanModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedPlanId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPlans();
  }

  Future<void> fetchPlans() async {
    try {
      isLoading.value = true;
      final response = await _premiumRepository.getSubscriptionPlans();
      if (response.data != null) {
        plans.assignAll(response.data!);
        if (plans.isNotEmpty && selectedPlanId.isEmpty) {
          selectedPlanId.value = plans.first.planId;
        }
      }
    } catch (e) {
      // SnackbarUtils.error('Failed to fetch subscription plans');
    } finally {
      isLoading.value = false;
    }
  }

  void selectPlan(String planId) {
    if (kDebugMode) {
      print('Selecting plan: $planId');
    }
    selectedPlanId.value = planId;
  }

  void upgrade() {
    if (selectedPlanId.isEmpty) {
      // SnackbarUtils.pending('Please select a plan first');
      return;
    }
    
    // Updated as per user request to use bottom position and colors
    // Since this is a "coming soon" placeholder, using success/pending style
    // SnackbarUtils.success('Payment integration for plan ${selectedPlanId.value} will be available soon.');
  }
}
