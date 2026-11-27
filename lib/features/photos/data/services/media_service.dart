import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class MediaService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  Future<List<File>> pickMultipleImages() async {
    final List<XFile> images = await _picker.pickMultiImage(
      imageQuality: 80,
    );
    return images.map((xFile) => File(xFile.path)).toList();
  }

  Future<File?> pickVideo(ImageSource source) async {
    final XFile? video = await _picker.pickVideo(
      source: source,
    );
    if (video != null) {
      return File(video.path);
    }
    return null;
  }

  // Simulate upload process (keeping for backward compatibility if needed)
  Future<String> uploadMedia(File file) async {
    await Future.delayed(const Duration(seconds: 2));
    return file.path; 
  }

  Future<String?> downloadMedia(String url) async {
    try {
      if (!url.startsWith('http')) {
        await Future.delayed(const Duration(seconds: 1));
        return url;
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getExternalStorageDirectory() ?? await getApplicationDocumentsDirectory();
        final fileName = path.basename(url);
        final file = File('${directory.path}/$fileName');
        await file.writeAsBytes(response.bodyBytes);
        return file.path;
      }
      return null;
    } catch (e) {
      print('Download error: $e');
      return null;
    }
  }
}
