import 'create_album_response.dart';

class AlbumsListResponse {
  final String? status;
  final AlbumsPaginatedData? data;

  AlbumsListResponse({this.status, this.data});

  factory AlbumsListResponse.fromJson(Map<String, dynamic> json) => AlbumsListResponse(
        status: json["status"],
        data: json["data"] == null ? null : AlbumsPaginatedData.fromJson(json["data"]),
      );
}

class AlbumsPaginatedData {
  final int? currentPage;
  final List<AlbumData>? data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<Link>? links;
  final String? nextPageUrl;
  final String? path;
  final int? perPage;
  final String? prevPageUrl;
  final int? to;
  final int? total;

  AlbumsPaginatedData({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory AlbumsPaginatedData.fromJson(Map<String, dynamic> json) => AlbumsPaginatedData(
        currentPage: json["current_page"],
        data: json["data"] == null ? null : List<AlbumData>.from(json["data"].map((x) => AlbumData.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: json["links"] == null ? null : List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );
}

class Link {
  final String? url;
  final String? label;
  final bool? active;

  Link({this.url, this.label, this.active});

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );
}
