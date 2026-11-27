class UserResponse {
  final String? status;
  final UserModel? user;

  UserResponse({this.status, this.user});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      status: json['status'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }
}

class UserModel {
  final int? id;
  final String? name;
  final String? email;
  final int? storageQuotaGb;
  final String? emailVerifiedAt;
  final int? currentTeamId;
  final String? profilePhotoPath;
  final String? createdAt;
  final String? updatedAt;
  final String? securityCode;
  final String? userRole;
  final String? mobile;
  final String? status;
  final String? customerId;
  final int? subscribedToEmails;
  final String? walletBalance;
  final String? profilePhotoUrl;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.storageQuotaGb,
    this.emailVerifiedAt,
    this.currentTeamId,
    this.profilePhotoPath,
    this.createdAt,
    this.updatedAt,
    this.securityCode,
    this.userRole,
    this.mobile,
    this.status,
    this.customerId,
    this.subscribedToEmails,
    this.walletBalance,
    this.profilePhotoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      storageQuotaGb: json['storage_quota_gb'],
      emailVerifiedAt: json['email_verified_at'],
      currentTeamId: json['current_team_id'],
      profilePhotoPath: json['profile_photo_path'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      securityCode: json['security_code'],
      userRole: json['user_role'],
      mobile: json['mobile'],
      status: json['status'],
      customerId: json['customer_id'],
      subscribedToEmails: json['subscribed_to_emails'],
      walletBalance: json['wallet_balance'],
      profilePhotoUrl: json['profile_photo_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'storage_quota_gb': storageQuotaGb,
      'profile_photo_url': profilePhotoUrl,
      // Add other fields if needed for local storage or updates
    };
  }
}
