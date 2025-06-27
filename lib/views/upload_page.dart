import 'package:flutter/material.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Gambar Komik'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Judul
            const Text(
              'Upload Komik Digital',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            // 2. Preview Gambar (dummy)
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('Preview Gambar'),
              ),
            ),
            const SizedBox(height: 24),
            // 3. Tombol Pilih Gambar
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.image_search),
                label: const Text('Pilih Gambar'),
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 16),
            // 4. Tombol Upload
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.cloud_upload),
                label: const Text('Upload'),
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 24),
            // 5. Info Status
            const Text(
              'Status: Belum ada gambar diupload',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
} 