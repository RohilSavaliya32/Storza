import 'package:flutter/material.dart';

class VideoControls extends StatelessWidget {
  const VideoControls({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.play_arrow),
        Icon(Icons.pause),
      ],
    );
  }
}
