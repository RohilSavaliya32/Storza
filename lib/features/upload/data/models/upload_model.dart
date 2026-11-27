class UploadModel {
  final String id;
  final String fileName;
  final double progress;

  UploadModel({required this.id, required this.fileName, this.progress = 0.0});
}
