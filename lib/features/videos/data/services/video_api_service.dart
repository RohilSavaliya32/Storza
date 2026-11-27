import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/video_list_response.dart';

class VideoApiService {
  final DioClient _dioClient;
  final GetStorage _storage = GetStorage();

  VideoApiService(this._dioClient);

  Future<VideoListResponse> getVideos() async {
    try {
      final token = _storage.read(StorageKeys.token);
      final response = await _dioClient.dio.get(
        ApiEndpoints.videos,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return VideoListResponse.fromJson(response.data);
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

  Future<bool> deleteVideo(String videoId) async {
    try {
      final token = _storage.read(StorageKeys.token);
      final response = await _dioClient.dio.delete(
        ApiEndpoints.deleteVideo(videoId),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> uploadVideos({
    required String userId,
    required String albumTitle,
    required String priority,
    required String completedAt,
    required List<String> filePaths,
  }) async {
    try {
      final token = _storage.read(StorageKeys.token);
      
      List<MultipartFile> multipartFiles = [];
      for (String path in filePaths) {
        multipartFiles.add(await MultipartFile.fromFile(
          path,
          filename: path.split('/').last,
        ));
      }

      FormData formData = FormData.fromMap({
        'user_id': userId,
        'album_title': albumTitle,
        'priority': priority,
        'completed_at': completedAt,
        'attachments[]': multipartFiles,
      });

      final response = await _dioClient.dio.post(
        ApiEndpoints.videos,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
