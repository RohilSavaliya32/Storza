class ShareLinkModel {
  final String token;
  final String shareUrl;
  final String duration;
  final DateTime? expiresAt;
  final bool isOneTime;
  final int totalItems;

  ShareLinkModel({
    required this.token,
    required this.shareUrl,
    required this.duration,
    this.expiresAt,
    required this.isOneTime,
    required this.totalItems,
  });

  factory ShareLinkModel.fromJson(Map<String, dynamic> json) {
    return ShareLinkModel(
      token: json['token'] ?? '',
      shareUrl: json['share_url'] ?? '',
      duration: json['duration'] ?? '',
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at']) : null,
      isOneTime: json['is_one_time'] ?? false,
      totalItems: json['total_items'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'share_url': shareUrl,
      'duration': duration,
      'expires_at': expiresAt?.toIso8601String(),
      'is_one_time': isOneTime,
      'total_items': totalItems,
    };
  }
}

class ShareItemRequest {
  final int mediaId;
  final String mediaType; // 'photo' or 'video'

  ShareItemRequest({required this.mediaId, required this.mediaType});

  Map<String, dynamic> toJson() {
    return {
      'media_id': mediaId,
      'media_type': mediaType,
    };
  }
}

class CreateShareRequest {
  final String title;
  final String duration;
  final List<ShareItemRequest> items;

  CreateShareRequest({
    required this.title,
    required this.duration,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'duration': duration,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}
