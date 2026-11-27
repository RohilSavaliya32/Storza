import 'package:flutter/material.dart';

class UploadProgressWidget extends StatelessWidget {
  final double progress;
  const UploadProgressWidget({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(value: progress);
  }
}
