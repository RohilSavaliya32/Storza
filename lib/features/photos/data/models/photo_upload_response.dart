class PhotoUploadResponse {
  final String? status;
  final String? message;
  final PhotoUploadData? data;

  PhotoUploadResponse({
    this.status,
    this.message,
    this.data,
  });

  factory PhotoUploadResponse.fromJson(Map<String, dynamic> json) {
    return PhotoUploadResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? PhotoUploadData.fromJson(json['data']) : null,
    );
  }
}

class PhotoListResponse {
  final String? status;
  final int? totalRecords;
  final List<PhotoUploadData>? data;

  PhotoListResponse({
    this.status,
    this.totalRecords,
    this.data,
  });

  factory PhotoListResponse.fromJson(Map<String, dynamic> json) {
    return PhotoListResponse(
      status: json['status'],
      totalRecords: json['total_records'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => PhotoUploadData.fromJson(i)).toList()
          : null,
    );
  }
}

class PhotoUploadData {
  final String? uuid;
  final dynamic userId;
  final String? albumTitle;
  final String? priority;
  final String? completedAt;
  final String? updatedAt;
  final String? createdAt;
  final dynamic id;
  final String? fileUrl;
  final List<Attachment>? attachments;

  PhotoUploadData({
    this.uuid,
    this.userId,
    this.albumTitle,
    this.priority,
    this.completedAt,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.fileUrl,
    this.attachments,
  });

  factory PhotoUploadData.fromJson(Map<String, dynamic> json) {
    return PhotoUploadData(
      uuid: json['uuid'],
      userId: json['user_id'],
      albumTitle: json['album_title'],
      priority: json['priority'],
      completedAt: json['completed_at'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      id: json['id'],
      fileUrl: json['file_url'],
      attachments: json['attachments'] != null
          ? (json['attachments'] as List)
              .map((i) => Attachment.fromJson(i))
              .toList()
          : null,
    );
  }
}

class Attachment {
  final dynamic id;
  final dynamic photoId;
  final String? fileName;
  final String? filePath;
  final String? fileType;
  final int? fileSize;
  final String? createdAt;
  final String? updatedAt;
  final String? fullUrl;
  final String? fileUrl;

  Attachment({
    this.id,
    this.photoId,
    this.fileName,
    this.filePath,
    this.fileType,
    this.fileSize,
    this.createdAt,
    this.updatedAt,
    this.fullUrl,
    this.fileUrl,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'],
      photoId: json['photo_id'],
      fileName: json['file_name'],
      filePath: json['file_path'],
      fileType: json['file_type'],
      fileSize: json['file_size'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      fullUrl: json['full_url'],
      fileUrl: json['file_url'],
    );
  }
}
