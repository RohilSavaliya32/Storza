class ApiEndpoints {
  // Auth
  static const String login = 'login';
  static const String register = 'register-user';
  static const String verifyOtp = 'verify-otp';
  static const String resendOtp = 'resend-otp';
  static const String getUserInfo = 'get_user_info';
  static const String logout = 'logout';

  // Profile & Storage
  static const String storageStats = 'storage/stats';
  static const String updateProfile = 'update-profile';

  // Photos
  static const String photos = 'photos';
  static String getPhoto(String id) => 'photos/$id';
  static String deletePhoto(String id) => 'photos/$id';

  // Videos
  static const String videos = 'videos';
  static String getVideo(String id) => 'videos/$id';
  static String deleteVideo(String id) => 'videos/$id';

  // Albums
  static const String albums = 'albums';
  static const String albumsList = 'albums-list';
  static String getAlbum(String id) => 'albums/$id';
  static String deleteAlbum(String id) => 'albums/$id';
  static String addItemsToAlbum(String albumId) => 'albums/$albumId/items';

  // Share
  static const String shareCreate = 'create';
  static const String shareList = 'share/list';
  static String shareRemove(String token) => 'share/remove/$token';
  static String shareView(String token) => 'share/view/$token';

  // Subscription
  static const String subscriptionPlans = 'subscription/plans';

  // Settings / Support
  static const String privacyPolicy = 'privacy-policy';
  static const String termsConditions = 'terms-conditions';
}
