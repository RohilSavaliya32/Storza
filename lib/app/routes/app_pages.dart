import 'package:get/get.dart';
import '../../features/splash/view/splash_view.dart';
import '../../features/splash/binding/splash_binding.dart';
import '../../features/navigation/view/main_navigation_view.dart';
import '../../features/navigation/binding/navigation_binding.dart';
import '../../features/settings/view/settings_view.dart';
import '../../features/settings/binding/settings_binding.dart';
import '../../features/home/view/home_view.dart';
import '../../features/home/binding/home_binding.dart';
import '../../features/albums/view/albums_view.dart';
import '../../features/albums/binding/albums_binding.dart';
import '../../features/share/view/shared_view.dart';
import '../../features/share/view/create_share_view.dart';
import '../../features/share/binding/share_binding.dart';
import '../../features/premium/view/premium_view.dart';
import '../../features/premium/binding/premium_binding.dart';
import '../../features/profile/view/profile_view.dart';
import '../../features/profile/view/account_info_view.dart';
import '../../features/profile/view/change_password_view.dart';
import '../../features/profile/view/storage_view.dart';
import '../../features/profile/binding/profile_binding.dart';
import '../../features/photos/view/photos_view.dart';
import '../../features/photos/view/recent_view.dart';
import '../../features/photos/binding/photos_binding.dart';
import '../../features/videos/view/videos_view.dart';
import '../../features/videos/binding/videos_binding.dart';
import '../../features/photos/view/photo_preview_view.dart';
import '../../features/videos/view/video_player_view.dart';
import '../../features/favorites/view/favorites_view.dart';
import '../../features/recently_deleted/view/recently_deleted_view.dart';
import '../../features/auth/view/login_view.dart';
import '../../features/auth/view/register_view.dart';
import '../../features/auth/view/forgot_password_view.dart';
import '../../features/auth/view/otp_view.dart';
import '../../features/auth/view/reset_password_view.dart';
import '../../features/auth/binding/auth_binding.dart';
import '../../features/help_support/view/help_support_view.dart';
import '../../features/help_support/binding/help_support_binding.dart';
import '../../features/about/view/about_view.dart';
import '../../features/about/binding/about_binding.dart';
import '../../features/privacy_policy/view/privacy_policy_view.dart';
import '../../features/privacy_policy/binding/privacy_policy_binding.dart';
import '../../features/terms_conditions/view/terms_conditions_view.dart';
import '../../features/terms_conditions/binding/terms_conditions_binding.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.MAIN_NAVIGATION,
      page: () => const MainNavigationView(),
      binding: NavigationBinding(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.ALBUMS,
      page: () => const AlbumsView(),
      binding: AlbumsBinding(),
    ),
    GetPage(
      name: Routes.SHARED,
      page: () => const SharedView(),
      binding: ShareBinding(),
    ),
    GetPage(
      name: Routes.CREATE_SHARE,
      page: () => const CreateShareView(),
      binding: ShareBinding(),
    ),
    GetPage(
      name: Routes.PREMIUM,
      page: () => const PremiumView(),
      binding: PremiumBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.STORAGE,
      page: () => const StorageView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.PHOTOS,
      page: () => const PhotosView(),
      binding: PhotosBinding(),
    ),
    GetPage(
      name: Routes.RECENT,
      page: () => const RecentView(),
      binding: PhotosBinding(),
    ),
    GetPage(
      name: Routes.VIDEOS,
      page: () => const VideosView(),
      binding: VideosBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.OTP,
      page: () => const OtpView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.RESET_PASSWORD,
      page: () => const ResetPasswordView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.PHOTO_PREVIEW,
      page: () => const PhotoPreviewView(),
    ),
    GetPage(
      name: Routes.VIDEO_PLAYER,
      page: () => const VideoPlayerView(),
    ),
    GetPage(
      name: Routes.FAVORITES,
      page: () => const FavoritesView(),
    ),
    GetPage(
      name: Routes.RECENTLY_DELETED,
      page: () => const RecentlyDeletedView(),
    ),
    GetPage(
      name: Routes.ACCOUNT_INFO,
      page: () => const AccountInfoView(),
    ),
    GetPage(
      name: Routes.CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
    ),
    GetPage(
      name: Routes.HELP_SUPPORT,
      page: () => const HelpSupportView(),
      binding: HelpSupportBinding(),
    ),
    GetPage(
      name: Routes.ABOUT,
      page: () => const AboutView(),
      binding: AboutBinding(),
    ),
    GetPage(
      name: Routes.PRIVACY_POLICY,
      page: () => const PrivacyPolicyView(),
      binding: PrivacyPolicyBinding(),
    ),
    GetPage(
      name: Routes.TERMS_CONDITIONS,
      page: () => const TermsConditionsView(),
      binding: TermsConditionsBinding(),
    ),
  ];
}
