import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/photo_upload_response.dart';

class PhotoApiService {
  final DioClient _dioClient;
  final GetStorage _storage = GetStorage();

  PhotoApiService(this._dioClient);

  Future<PhotoUploadResponse> uploadMedia({
    required String userId,
    required String albumTitle,
    required String priority,
    required String completedAt,
    required List<String> filePaths,
    bool isVideo = false,
    Function(int sent, int total)? onSendProgress,
  }) async {
    try {
      final token = _storage.read(StorageKeys.token);
      final endpoint = isVideo ? ApiEndpoints.videos : ApiEndpoints.photos;
      
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
        endpoint,
        data: formData,
        onSendProgress: onSendProgress,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PhotoUploadResponse.fromJson(response.data);
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

  Future<PhotoListResponse> getPhotos() async {
    try {
      final token = _storage.read(StorageKeys.token);
      final response = await _dioClient.dio.get(
        ApiEndpoints.photos,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return PhotoListResponse.fromJson(response.data);
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

  Future<PhotoListResponse> getVideos() async {
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
        return PhotoListResponse.fromJson(response.data);
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

  Future<PhotoUploadResponse> getSinglePhoto(String photoId) async {
    try {
      final token = _storage.read(StorageKeys.token);
      final response = await _dioClient.dio.get(
        ApiEndpoints.getPhoto(photoId),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return PhotoUploadResponse.fromJson(response.data);
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

  Future<bool> deletePhoto(String photoId) async {
    try {
      final token = _storage.read(StorageKeys.token);
      final response = await _dioClient.dio.delete(
        ApiEndpoints.deletePhoto(photoId),
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
}
