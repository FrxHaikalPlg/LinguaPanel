import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../viewmodels/upload_viewmodel.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? _selectedImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadDummy() async {
    setState(() {
      _isLoading = true;
    });
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _selectedImage != null) {
      await UserService().addHistory(
        uid: user.uid,
        originalImageUrl: _selectedImage!.path,
        translatedImageUrl: null,
        status: 'Selesai',
      );
      setState(() {
        _selectedImage = null;
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload dummy berhasil! Masuk ke history.')),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<UploadViewModel>(context);
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
            // 2. Preview Gambar
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: vm.selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(vm.selectedImage!, fit: BoxFit.cover),
                    )
                  : const Center(child: Text('Preview Gambar')),
            ),
            const SizedBox(height: 24),
            // 3. Tombol Pilih Gambar
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.image_search),
                label: const Text('Pilih Gambar'),
                onPressed: vm.isLoading ? null : vm.pickImage,
              ),
            ),
            const SizedBox(height: 16),
            // 4. Tombol Upload (dummy, disable jika belum pilih gambar)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.cloud_upload),
                label: const Text('Upload'),
                onPressed: vm.selectedImage == null || vm.isLoading
                    ? null
                    : () async {
                        final success = await vm.uploadDummy();
                        if (success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Upload dummy berhasil! Masuk ke history.')),
                          );
                        }
                      },
              ),
            ),
            const SizedBox(height: 24),
            // 5. Info Status
            Text(
              vm.selectedImage == null
                  ? 'Status: Belum ada gambar diupload'
                  : 'Status: Gambar siap diupload',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
} 