import 'dart:io';
import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final File imageFile;

  const ResultPage({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gambar Terpilih')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(imageFile, width: 300, height: 300, fit: BoxFit.cover),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Kriteria 2 - Panggil fungsi inferensi ML di sini
              },
              child: const Text('Analisis Makanan'),
            ),
          ],
        ),
      ),
    );
  }
}
