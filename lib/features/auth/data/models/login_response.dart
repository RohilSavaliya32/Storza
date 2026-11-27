class LoginResponse {
  final String? status;
  final String? message;
  final String? accessToken;
  final String? tokenType;
  final String? customerId;
  final User? user;
  final User? dataUser; // Renamed to avoid confusion with the raw data map

  LoginResponse({
    this.status,
    this.message,
    this.accessToken,
    this.tokenType,
    this.customerId,
    this.user,
    this.dataUser,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    String? token = json['access_token'];
    User? userObj;
    
    // Handle structure where token is inside 'data' (like in verify-otp)
    if (json['data'] is Map<String, dynamic>) {
      if (json['data'].containsKey('token')) {
        token = json['data']['token'];
      }
      if (json['data'].containsKey('user')) {
        userObj = User.fromJson(json['data']['user']);
      } else {
        // Sometimes 'data' itself is the user object
        userObj = User.fromJson(json['data']);
      }
    }

    return LoginResponse(
      status: json['status'],
      message: json['message'],
      accessToken: token,
      tokenType: json['token_type'],
      customerId: json['customer_id'],
      user: json['user'] != null ? User.fromJson(json['user']) : userObj,
      dataUser: userObj,
    );
  }
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final int? storageQuotaGb;
  final String? emailVerifiedAt;
  final dynamic twoFactorConfirmedAt;
  final int? currentTeamId;
  final String? profilePhotoPath;
  final String? createdAt;
  final String? updatedAt;
  final String? uuid;
  final String? securityCode;
  final String? userRole;
  final String? mobile;
  final String? status;
  final String? customerId;
  final int? subscribedToEmails;
  final String? unsubscribeToken;
  final dynamic unsubscribedAt;
  final String? referralCode;
  final dynamic referredBy;
  final String? walletBalance;
  final String? profilePhotoUrl;

  User({
    this.id,
    this.name,
    this.email,
    this.storageQuotaGb,
    this.emailVerifiedAt,
    this.twoFactorConfirmedAt,
    this.currentTeamId,
    this.profilePhotoPath,
    this.createdAt,
    this.updatedAt,
    this.uuid,
    this.securityCode,
    this.userRole,
    this.mobile,
    this.status,
    this.customerId,
    this.subscribedToEmails,
    this.unsubscribeToken,
    this.unsubscribedAt,
    this.referralCode,
    this.referredBy,
    this.walletBalance,
    this.profilePhotoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      storageQuotaGb: json['storage_quota_gb'],
      emailVerifiedAt: json['email_verified_at'],
      twoFactorConfirmedAt: json['two_factor_confirmed_at'],
      currentTeamId: json['current_team_id'],
      profilePhotoPath: json['profile_photo_path'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      uuid: json['uuid'],
      securityCode: json['security_code'],
      userRole: json['user_role'],
      mobile: json['mobile'],
      status: json['status']?.toString(),
      customerId: json['customer_id'],
      subscribedToEmails: json['subscribed_to_emails'],
      unsubscribeToken: json['unsubscribe_token'],
      unsubscribedAt: json['unsubscribed_at'],
      referralCode: json['referral_code'],
      referredBy: json['referred_by'],
      walletBalance: json['wallet_balance'],
      profilePhotoUrl: json['profile_photo_url'],
    );
  }
}
