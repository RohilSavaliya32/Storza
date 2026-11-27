import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/privacy_policy_model.dart';

class PrivacyPolicyService {
  final DioClient _dioClient;

  PrivacyPolicyService(this._dioClient);

  Future<PrivacyPolicyModel> getPrivacyPolicy() async {
    try {
      final response = await _dioClient.dio.get(ApiEndpoints.privacyPolicy);
      if (response.statusCode == 200) {
        return PrivacyPolicyModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load privacy policy');
      }
    } catch (e) {
      rethrow;
    }
  }
}
