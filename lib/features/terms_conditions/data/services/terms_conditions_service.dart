import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/terms_conditions_model.dart';

class TermsConditionsService {
  final DioClient _dioClient;

  TermsConditionsService(this._dioClient);

  Future<TermsConditionsModel> getTermsConditions() async {
    try {
      final response = await _dioClient.dio.get(ApiEndpoints.termsConditions);
      if (response.statusCode == 200) {
        return TermsConditionsModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load terms and conditions');
      }
    } catch (e) {
      rethrow;
    }
  }
}
