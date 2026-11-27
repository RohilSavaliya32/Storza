import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../data/models/login_response.dart';
import '../data/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;
  final Rxn<User> user = Rxn<User>();
  final RxBool isLoading = false.obs;

  AuthController(this._authRepository);

  @override
  void onInit() {
    super.onInit();
    if (_authRepository.getToken() != null) {
      fetchUserInfo();
    }
  }

  Future<void> fetchUserInfo() async {
    try {
      isLoading.value = true;
      final response = await _authRepository.getUserInfo();
      if (response.user != null) {
        final u = response.user!;
        user.value = User(
          id: u.id,
          name: u.name,
          email: u.email,
          storageQuotaGb: u.storageQuotaGb,
          emailVerifiedAt: u.emailVerifiedAt,
          currentTeamId: u.currentTeamId,
          profilePhotoPath: u.profilePhotoPath,
          createdAt: u.createdAt,
          updatedAt: u.updatedAt,
          securityCode: u.securityCode,
          userRole: u.userRole,
          mobile: u.mobile,
          status: u.status,
          customerId: u.customerId,
          subscribedToEmails: u.subscribedToEmails,
          walletBalance: u.walletBalance,
          profilePhotoUrl: u.profilePhotoUrl,
        );
      }
    } catch (e) {
      // Error handled by Interceptor
    } finally {
      isLoading.value = false;
    }
  }

  void updateProfile({String? name, String? photoPath}) {
    if (user.value != null) {
      user.value = User(
        id: user.value!.id,
        name: name ?? user.value!.name,
        email: user.value!.email,
        storageQuotaGb: user.value!.storageQuotaGb,
        emailVerifiedAt: user.value!.emailVerifiedAt,
        twoFactorConfirmedAt: user.value!.twoFactorConfirmedAt,
        currentTeamId: user.value!.currentTeamId,
        profilePhotoPath: photoPath ?? user.value!.profilePhotoPath,
        createdAt: user.value!.createdAt,
        updatedAt: user.value!.updatedAt,
        uuid: user.value!.uuid,
        securityCode: user.value!.securityCode,
        userRole: user.value!.userRole,
        mobile: user.value!.mobile,
        status: user.value!.status,
        customerId: user.value!.customerId,
        subscribedToEmails: user.value!.subscribedToEmails,
        unsubscribeToken: user.value!.unsubscribeToken,
        unsubscribedAt: user.value!.unsubscribedAt,
        referralCode: user.value!.referralCode,
        referredBy: user.value!.referredBy,
        walletBalance: user.value!.walletBalance,
        profilePhotoUrl: user.value!.profilePhotoUrl,
      );
      user.refresh();
    }
  }

  void setUser(User? newUser) {
    user.value = newUser;
  }

  bool get isLoggedIn => user.value != null || _authRepository.getToken() != null;

  Future<void> logout() async {
    try {
      isLoading.value = true;
      // API logout call
      await _authRepository.logout();
    } catch (e) {
      // Even if API fails, we should clear local session
      await _authRepository.clearSession();
    } finally {
      user.value = null;
      isLoading.value = false;
      // Navigate to Login and clear route history
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
