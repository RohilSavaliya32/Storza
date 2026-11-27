import '../models/plan_model.dart';
import '../services/subscription_service.dart';
import 'premium_repository.dart';

class PremiumRepositoryImpl implements PremiumRepository {
  final SubscriptionService _subscriptionService;

  PremiumRepositoryImpl(this._subscriptionService);

  @override
  Future<PlanResponseModel> getSubscriptionPlans() async {
    return await _subscriptionService.getSubscriptionPlans();
  }
}
