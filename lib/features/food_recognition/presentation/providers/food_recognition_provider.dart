import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final selectedImageProvider = StateProvider<File?>((ref) => null);

final imagePickerProvider = Provider<ImagePicker>((ref) => ImagePicker());

final imagePickerControllerProvider = Provider((ref) {
  final imagePicker = ref.watch(imagePickerProvider);
  final imageNotifier = ref.read(selectedImageProvider.notifier);

  return ImagePickerController(
      imagePicker: imagePicker,
      imageNotifier: imageNotifier
  );
});

class ImagePickerController {
  final ImagePicker _imagePicker;
  final StateController<File?> _imageNotifier;

  ImagePickerController({
    required ImagePicker imagePicker,
    required StateController<File?> imageNotifier,
  }) : _imagePicker = imagePicker, _imageNotifier = imageNotifier;

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      _imageNotifier.state = File(pickedFile.path);
    }
  }
}