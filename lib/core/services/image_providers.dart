import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'image_service.dart';

// Provider ini hanya bertugas "menyediakan" instance dari ImageService
final imageServiceProvider = Provider<ImageService>((ref) {
  return ImageService();
});