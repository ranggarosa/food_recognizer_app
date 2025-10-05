import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraFeedPage extends StatefulWidget {
  const CameraFeedPage({super.key});

  @override
  State<CameraFeedPage> createState() => _CameraFeedPageState();
}

class _CameraFeedPageState extends State<CameraFeedPage> {
  CameraController? _controller;
  bool _isPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;
    if (_isPermissionGranted) {
      _initializeCamera();
    }
    setState(() {});
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    // Gunakan kamera belakang
    final firstCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
    );

    _controller = CameraController(firstCamera, ResolutionPreset.high);

    try {
      await _controller!.initialize();
      if (!mounted) return;

      // Memulai stream gambar
      _controller!.startImageStream((CameraImage image) {
        // -----------------------------------------------------------------
        // TODO: Kriteria 2 - Implementasikan logika inferensi ML di sini
        // Anda akan mendapatkan data gambar dari variabel 'image'
        // Proses ini akan berjalan untuk setiap frame dari kamera.
        // -----------------------------------------------------------------
      });
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isPermissionGranted) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Izin kamera ditolak.'),
              ElevatedButton(
                onPressed: _requestCameraPermission,
                child: const Text('Minta Izin Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Live Identification')),
      body: CameraPreview(_controller!),
    );
  }
}
