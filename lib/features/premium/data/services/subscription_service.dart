import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/plan_model.dart';

class SubscriptionService {
  final DioClient _dioClient;
  final GetStorage _storage = GetStorage();

  SubscriptionService(this._dioClient);

  Future<PlanResponseModel> getSubscriptionPlans() async {
    try {
      final token = _storage.read(StorageKeys.token);
      final response = await _dioClient.dio.get(
        ApiEndpoints.subscriptionPlans,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return PlanResponseModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
