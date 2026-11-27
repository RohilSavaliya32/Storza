import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/create_album_response.dart';
import '../models/albums_list_response.dart';
import '../models/album_details_response.dart';
import '../../../auth/data/repositories/auth_repository.dart';

class AlbumApiService {
  final Dio _dio;
  final AuthRepository _authRepository;

  AlbumApiService(DioClient dioClient, this._authRepository) : _dio = dioClient.dio;

  Future<CreateAlbumResponse> createAlbum({
    required String title,
    String priority = 'high',
    String? completedAt,
  }) async {
    try {
      final token = _authRepository.getToken();
      
      final response = await _dio.post(
        ApiEndpoints.albums,
        data: {
          'title': title,
          'priority': priority,
          if (completedAt != null) 'completed_at': completedAt,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return CreateAlbumResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<AlbumsListResponse> getAlbums({int page = 1}) async {
    try {
      final token = _authRepository.getToken();
      final response = await _dio.get(
        ApiEndpoints.albumsList,
        queryParameters: {'page': page},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return AlbumsListResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<AlbumDetailsResponse> getAlbumDetails(String albumId) async {
    try {
      final token = _authRepository.getToken();
      final response = await _dio.get(
        ApiEndpoints.getAlbum(albumId),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return AlbumDetailsResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<CreateAlbumResponse> addMediaToAlbum({
    required String albumId,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final token = _authRepository.getToken();
      
      final Map<String, dynamic> formDataMap = {};
      for (int i = 0; i < items.length; i++) {
        formDataMap['items[$i][media_id]'] = items[i]['media_id'];
        formDataMap['items[$i][media_type]'] = items[i]['media_type'];
      }

      final response = await _dio.post(
        ApiEndpoints.addItemsToAlbum(albumId),
        data: FormData.fromMap(formDataMap),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return CreateAlbumResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteAlbum(String albumId) async {
    try {
      final token = _authRepository.getToken();
      final response = await _dio.delete(
        ApiEndpoints.getAlbum(albumId),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return response.statusCode == 200 || response.data['status'] == 'success';
    } catch (e) {
      rethrow;
    }
  }

  Future<CreateAlbumResponse> updateAlbum({
    required String albumId,
    required String title,
  }) async {
    try {
      final token = _authRepository.getToken();
      final response = await _dio.put(
        ApiEndpoints.getAlbum(albumId),
        data: {'title': title},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return CreateAlbumResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
