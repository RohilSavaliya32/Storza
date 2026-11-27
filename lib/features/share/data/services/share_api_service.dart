import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/constants/storage_keys.dart';
import '../models/share_link_model.dart';

class ShareApiService {
  final DioClient _dioClient;
  final GetStorage _storage = GetStorage();

  ShareApiService(this._dioClient);

  Future<ShareLinkModel> createShareLink(CreateShareRequest request) async {
    try {
      final token = _storage.read(StorageKeys.token);
      final response = await _dioClient.dio.post(
        ApiEndpoints.shareCreate,
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ShareLinkModel.fromJson(response.data['data']);
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

  Future<List<ShareLinkModel>> getShareLinks() async {
    try {
      final token = _storage.read(StorageKeys.token);
      final response = await _dioClient.dio.get(
        ApiEndpoints.shareList,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((e) => ShareLinkModel.fromJson(e)).toList();
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

  Future<bool> removeShareLink(String token) async {
    try {
      final authToken = _storage.read(StorageKeys.token);
      final response = await _dioClient.dio.delete(
        ApiEndpoints.shareRemove(token),
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }
}
