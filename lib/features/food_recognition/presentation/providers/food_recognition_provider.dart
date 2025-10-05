import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // Fungsi untuk menangani aksi button
    void handleImagePicking(ImageSource source) async {
      // Panggil service melalui provider
      final imageService = ref.read(imageServiceProvider);
      final selectedImage = await imageService.pickAndCropImage(source);

      if (selectedImage != null && context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(imageFile: selectedImage),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Food Recognizer App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.photo_library),
              label: const Text('Pilih dari Galeri'),
              onPressed: () => handleImagePicking(ImageSource.gallery),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Ambil dari Kamera'),
              onPressed: () => handleImagePicking(ImageSource.camera),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.stream),
              label: const Text('Buka Live Feed'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CameraFeedPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}