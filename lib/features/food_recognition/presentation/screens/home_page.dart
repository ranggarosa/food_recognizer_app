import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'camera_feed_page.dart';
import 'result_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Fungsi utama untuk mengambil dan memotong gambar
  Future<void> _pickAndCropImage(ImageSource source) async {
    // 1. Meminta Izin terlebih dahulu
    final permission = source == ImageSource.camera
        ? Permission.camera
        : Permission.photos;
    final status = await permission.request();

    if (status.isGranted) {
      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(source: source);

      if (pickedFile != null) {
        final cropper = ImageCropper();
        final croppedFile = await cropper.cropImage(
          sourcePath: pickedFile.path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Potong Gambar',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
              aspectRatioPresets: [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9,
              ],
            ),
            IOSUiSettings(
              title: 'Potong Gambar',
              aspectRatioPresets: [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9,
              ],
            ),
          ],
        );

        if (croppedFile != null && mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ResultPage(imageFile: File(croppedFile.path)),
            ),
          );
        }
      }
    } else if (status.isPermanentlyDenied) {
      // Jika pengguna menolak permanen, buka pengaturan aplikasi
      openAppSettings();
    } else {
      // Tampilkan pesan jika izin ditolak
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${permission.toString()} permission denied')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Food Recognizer App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.photo_library),
              label: const Text('Pilih dari Galeri'),
              onPressed: () => _pickAndCropImage(ImageSource.gallery),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Ambil dari Kamera'),
              onPressed: () => _pickAndCropImage(ImageSource.camera),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.stream),
              label: const Text('Buka Live Feed'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CameraFeedPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
