class CreateAlbumResponse {
  final String? status;
  final String? message;
  final AlbumData? data;

  CreateAlbumResponse({
    this.status,
    this.message,
    this.data,
  });

  factory CreateAlbumResponse.fromJson(Map<String, dynamic> json) => CreateAlbumResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : AlbumData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class AlbumData {
  final String? userId;
  final String? title;
  final String? priority;
  final String? completedAt;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int? id;
  final int? itemsCount;
  final List<AlbumItem>? items;

  AlbumData({
    this.userId,
    this.title,
    this.priority,
    this.completedAt,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.itemsCount,
    this.items,
  });

  factory AlbumData.fromJson(Map<String, dynamic> json) => AlbumData(
        userId: json["user_id"]?.toString(),
        title: json["title"],
        priority: json["priority"],
        completedAt: json["completed_at"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"],
        itemsCount: json["items_count"],
        items: json["items"] == null ? [] : List<AlbumItem>.from(json["items"]!.map((x) => AlbumItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "title": title,
        "priority": priority,
        "completed_at": completedAt,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
        "items_count": itemsCount,
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class AlbumItem {
  final int? id;
  final int? albumId;
  final int? mediaId;
  final String? mediaType;
  final String? mediaUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AlbumItem({
    this.id,
    this.albumId,
    this.mediaId,
    this.mediaType,
    this.mediaUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory AlbumItem.fromJson(Map<String, dynamic> json) {
    // Media URL extraction from various possible keys
    String? url = json["media_url"] ?? json["full_url"] ?? json["url"] ?? json["file_path"];
    
    // Check for nested media or photo object if not found at root
    if (url == null && json["media"] != null) {
      url = json["media"]["full_url"] ?? json["media"]["media_url"] ?? json["media"]["file_path"];
    } else if (url == null && json["photo"] != null) {
      url = json["photo"]["full_url"] ?? json["photo"]["media_url"] ?? json["photo"]["file_path"];
    }

    return AlbumItem(
      id: json["id"],
      albumId: json["album_id"],
      mediaId: json["media_id"],
      mediaType: json["media_type"],
      mediaUrl: url,
      createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "album_id": albumId,
        "media_id": mediaId,
        "media_type": mediaType,
        "media_url": mediaUrl,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
