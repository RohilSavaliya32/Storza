import '../models/login_response.dart';
import '../models/user_model.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(String email, String securityCode);
  Future<LoginResponse> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? referralCode,
  });
  Future<LoginResponse> verifyOtp(String email, String otp);
  Future<void> resendOtp(String email);
  Future<UserResponse> getUserInfo();
  Future<void> logout();
  Future<void> saveToken(String token);
  String? getToken();
  Future<void> clearSession();
}
