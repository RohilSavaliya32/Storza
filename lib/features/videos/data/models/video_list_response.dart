class VideoListResponse {
  final String? status;
  final int? totalRecords;
  final List<VideoData>? data;

  VideoListResponse({
    this.status,
    this.totalRecords,
    this.data,
  });

  factory VideoListResponse.fromJson(Map<String, dynamic> json) => VideoListResponse(
        status: json["status"],
        totalRecords: json["total_records"],
        data: json["data"] == null
            ? []
            : List<VideoData>.from(json["data"]!.map((x) => VideoData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "total_records": totalRecords,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class VideoData {
  final int? id;
  final String? uuid;
  final int? userId;
  final String? albumTitle;
  final String? priority;
  final String? completedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? deletedAt;
  final String? fileUrl;
  final List<VideoAttachment>? attachments;

  VideoData({
    this.id,
    this.uuid,
    this.userId,
    this.albumTitle,
    this.priority,
    this.completedAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.fileUrl,
    this.attachments,
  });

  factory VideoData.fromJson(Map<String, dynamic> json) => VideoData(
        id: json["id"],
        uuid: json["uuid"],
        userId: json["user_id"],
        albumTitle: json["album_title"],
        priority: json["priority"],
        completedAt: json["completed_at"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        fileUrl: json["file_url"],
        attachments: json["attachments"] == null
            ? []
            : List<VideoAttachment>.from(
                json["attachments"]!.map((x) => VideoAttachment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "user_id": userId,
        "album_title": albumTitle,
        "priority": priority,
        "completed_at": completedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "file_url": fileUrl,
        "attachments": attachments == null
            ? []
            : List<dynamic>.from(attachments!.map((x) => x.toJson())),
      };
}

class VideoAttachment {
  final int? id;
  final int? videoId;
  final String? fileName;
  final String? filePath;
  final String? fileType;
  final int? fileSize;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? fileUrl;
  final String? fullUrl;

  VideoAttachment({
    this.id,
    this.videoId,
    this.fileName,
    this.filePath,
    this.fileType,
    this.fileSize,
    this.createdAt,
    this.updatedAt,
    this.fileUrl,
    this.fullUrl,
  });

  factory VideoAttachment.fromJson(Map<String, dynamic> json) => VideoAttachment(
        id: json["id"],
        videoId: json["video_id"],
        fileName: json["file_name"],
        filePath: json["file_path"],
        fileType: json["file_type"],
        fileSize: json["file_size"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        fileUrl: json["file_url"],
        fullUrl: json["full_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "video_id": videoId,
        "file_name": fileName,
        "file_path": filePath,
        "file_type": fileType,
        "file_size": fileSize,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "file_url": fileUrl,
        "full_url": fullUrl,
      };
}
