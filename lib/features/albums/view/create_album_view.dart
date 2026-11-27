import 'package:flutter/material.dart';

class CreateAlbumView extends StatelessWidget {
  const CreateAlbumView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Album')),
      body: const Center(child: Text('Create Album View')),
    );
  }
}
