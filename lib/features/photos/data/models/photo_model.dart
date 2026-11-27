enum MediaType { image, video }

class PhotoModel {
  final String id;
  final String? photoId;
  final String url;
  final String? title;
  final bool isFavorite;
  final MediaType type;

  PhotoModel({
    required this.id,
    this.photoId,
    required this.url,
    this.title,
    this.isFavorite = false,
    this.type = MediaType.image,
  });

  PhotoModel copyWith({
    String? id,
    String? photoId,
    String? url,
    String? title,
    bool? isFavorite,
    MediaType? type,
  }) {
    return PhotoModel(
      id: id ?? this.id,
      photoId: photoId ?? this.photoId,
      url: url ?? this.url,
      title: title ?? this.title,
      isFavorite: isFavorite ?? this.isFavorite,
      type: type ?? this.type,
    );
  }

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['id'],
      photoId: json['photoId'],
      url: json['url'],
      title: json['title'],
      isFavorite: json['isFavorite'] ?? false,
      type: MediaType.values.firstWhere(
        (e) => e.toString() == 'MediaType.${json['type']}',
        orElse: () => MediaType.image,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'photoId': photoId,
      'url': url,
      'title': title,
      'isFavorite': isFavorite,
      'type': type.name,
    };
  }
}
