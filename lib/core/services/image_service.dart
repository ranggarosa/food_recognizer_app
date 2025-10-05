import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart'; // Dibutuhkan untuk Color

class ImageService {
  final ImagePicker _picker = ImagePicker();
  final ImageCropper _cropper = ImageCropper();

  Future<File?> pickAndCropImage(ImageSource source) async {
    // 1. Meminta Izin
    final permission = source == ImageSource.camera ? Permission.camera : Permission.photos;
    final status = await permission.request();

    if (!status.isGranted) {
      // Jika izin ditolak, kita bisa minta buka pengaturan atau return null
      if (status.isPermanentlyDenied) {
        openAppSettings();
      }
      return null;
    }

    // 2. Mengambil Gambar
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null) return null;

    // 3. Memotong Gambar
    final croppedFile = await _cropper.cropImage(
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
              CropAspectRatioPreset.ratio4x3,
            ]),
        IOSUiSettings(
            title: 'Potong Gambar',
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
            ])
      ],
    );

    if (croppedFile == null) return null;

    return File(croppedFile.path);
  }
}