class VideoModel {
  final String id;
  final String url;
  final String? title;
  final String? thumbnailUrl;

  VideoModel({
    required this.id,
    required this.url,
    this.title,
    this.thumbnailUrl,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'],
      url: json['url'],
      title: json['title'],
      thumbnailUrl: json['thumbnailUrl'],
    );
  }
}
