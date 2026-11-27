import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/login_response.dart';
import '../models/user_model.dart';

class AuthApiService {
  final DioClient _dioClient;
  final GetStorage _storage = GetStorage();

  AuthApiService(this._dioClient);

  Future<LoginResponse> login(String email, String securityCode) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'security_code': securityCode,
        },
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
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

  Future<LoginResponse> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? referralCode,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          if (referralCode != null && referralCode.isNotEmpty) 'referral_code': referralCode,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LoginResponse.fromJson(response.data);
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

  Future<LoginResponse> verifyOtp(String email, String otp) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.verifyOtp,
        data: {
          'email': email,
          'otp': otp,
        },
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
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

  Future<Response> resendOtp(String email) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.resendOtp,
        data: {
          'email': email,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserResponse> getUserInfo() async {
    try {
      final token = _storage.read(StorageKeys.token);
      final response = await _dioClient.dio.get(
        ApiEndpoints.getUserInfo,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return UserResponse.fromJson(response.data);
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

  Future<void> logout() async {
    try {
      final token = _storage.read(StorageKeys.token);
      await _dioClient.dio.post(
        ApiEndpoints.logout,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
