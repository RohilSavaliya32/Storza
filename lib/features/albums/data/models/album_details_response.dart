class AlbumDetailsResponse {
  final String? status;
  final String? album;
  final List<AlbumImage>? images;
  final List<dynamic>? videos;

  AlbumDetailsResponse({
    this.status,
    this.album,
    this.images,
    this.videos,
  });

  factory AlbumDetailsResponse.fromJson(Map<String, dynamic> json) => AlbumDetailsResponse(
        status: json["status"],
        album: json["album"],
        images: json["images"] == null 
            ? [] 
            : List<AlbumImage>.from(json["images"]!.map((x) => AlbumImage.fromJson(x))),
        videos: json["videos"] == null ? [] : List<dynamic>.from(json["videos"]!),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "album": album,
        "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x.toJson())),
        "videos": videos == null ? [] : List<dynamic>.from(videos!.map((x) => x)),
      };
}

class AlbumImage {
  final int? id;
  final int? photoId;
  final String? fileName;
  final String? filePath;
  final String? fileType;
  final int? fileSize;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? fullUrl;
  final String? mediaType;

  AlbumImage({
    this.id,
    this.photoId,
    this.fileName,
    this.filePath,
    this.fileType,
    this.fileSize,
    this.createdAt,
    this.updatedAt,
    this.fullUrl,
    this.mediaType,
  });

  factory AlbumImage.fromJson(Map<String, dynamic> json) => AlbumImage(
        id: json["id"],
        photoId: json["photo_id"],
        fileName: json["file_name"],
        filePath: json["file_path"],
        fileType: json["file_type"],
        fileSize: json["file_size"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        fullUrl: json["full_url"],
        mediaType: json["media_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "photo_id": photoId,
        "file_name": fileName,
        "file_path": filePath,
        "file_type": fileType,
        "file_size": fileSize,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "full_url": fullUrl,
        "media_type": mediaType,
      };
}
