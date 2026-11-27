class AlbumModel {
  final String id;
  final String title;
  final String? description;
  final int photoCount;
  final String? imageUrl;
  final List<String> photoIds;

  AlbumModel({
    required this.id,
    required this.title,
    this.description,
    this.photoCount = 0,
    this.imageUrl,
    this.photoIds = const [],
  });

  AlbumModel copyWith({
    String? id,
    String? title,
    String? description,
    int? photoCount,
    String? imageUrl,
    List<String>? photoIds,
  }) {
    return AlbumModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      photoCount: photoCount ?? this.photoCount,
      imageUrl: imageUrl ?? this.imageUrl,
      photoIds: photoIds ?? this.photoIds,
    );
  }

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      photoCount: json['photoCount'] ?? 0,
      imageUrl: json['imageUrl'],
      photoIds: List<String>.from(json['photoIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'photoCount': photoIds.length,
      'imageUrl': imageUrl,
      'photoIds': photoIds,
    };
  }
}
