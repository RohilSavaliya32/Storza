import '../models/plan_model.dart';

abstract class PremiumRepository {
  Future<PlanResponseModel> getSubscriptionPlans();
}
