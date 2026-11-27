import 'package:get_storage/get_storage.dart';
import '../../../../core/constants/storage_keys.dart';
import '../models/login_response.dart';
import '../models/user_model.dart';
import '../services/auth_api_service.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _apiService;
  final GetStorage _storage = GetStorage();

  AuthRepositoryImpl(this._apiService);

  @override
  Future<LoginResponse> login(String email, String securityCode) async {
    final response = await _apiService.login(email, securityCode);
    if (response.accessToken != null) {
      await saveToken(response.accessToken!);
    }
    return response;
  }

  @override
  Future<LoginResponse> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? referralCode,
  }) async {
    final response = await _apiService.register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
      referralCode: referralCode,
    );
    if (response.accessToken != null) {
      await saveToken(response.accessToken!);
    }
    return response;
  }

  @override
  Future<LoginResponse> verifyOtp(String email, String otp) async {
    final response = await _apiService.verifyOtp(email, otp);
    if (response.accessToken != null) {
      await saveToken(response.accessToken!);
    }
    return response;
  }

  @override
  Future<void> resendOtp(String email) async {
    await _apiService.resendOtp(email);
  }

  @override
  Future<UserResponse> getUserInfo() async {
    return await _apiService.getUserInfo();
  }

  @override
  Future<void> logout() async {
    await _apiService.logout();
    await clearSession();
  }

  @override
  Future<void> saveToken(String token) async {
    await _storage.write(StorageKeys.token, token);
  }

  @override
  String? getToken() {
    return _storage.read(StorageKeys.token);
  }

  @override
  Future<void> clearSession() async {
    await _storage.remove(StorageKeys.token);
  }
}
