import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/storage_stats_model.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../core/constants/storage_keys.dart';

class ProfileApiService {
  final DioClient _dioClient;
  final GetStorage _storage = GetStorage();

  ProfileApiService(this._dioClient);

  Future<StorageStatsModel> getStorageStats() async {
    try {
      final token = _storage.read(StorageKeys.token);
      final response = await _dioClient.dio.get(
        ApiEndpoints.storageStats,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return StorageStatsModel.fromJson(response.data);
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
