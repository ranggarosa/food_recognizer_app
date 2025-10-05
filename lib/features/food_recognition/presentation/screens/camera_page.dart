import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/food_recognition_provider.dart';

class CameraPage extends ConsumerWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedImage = ref.watch(selectedImageProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Food Recognizer')),
      body: Center(
        child: selectedImage == null
            ? const Text('No image selected.')
            : Image.file(selectedImage),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(imagePickerControllerProvider).pickImage(ImageSource.gallery);
        },
        child: const Icon(Icons.photo_library),
      ),
    );
  }
}