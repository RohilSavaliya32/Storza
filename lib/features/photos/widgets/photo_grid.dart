import 'package:flutter/material.dart';

class PhotoGrid extends StatelessWidget {
  const PhotoGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (context, index) => Container(color: Colors.grey[300], margin: const EdgeInsets.all(2)),
      itemCount: 20,
    );
  }
}
