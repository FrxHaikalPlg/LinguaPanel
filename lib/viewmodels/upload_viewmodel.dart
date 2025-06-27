import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_service.dart';

class UploadViewModel extends ChangeNotifier {
  File? selectedImage;
  bool isLoading = false;
  String? errorMessage;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<bool> uploadDummy() async {
    if (selectedImage == null) return false;
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await UserService().addHistory(
          uid: user.uid,
          originalImageUrl: selectedImage!.path,
          translatedImageUrl: null,
          status: 'Selesai',
        );
        selectedImage = null;
        isLoading = false;
        notifyListeners();
        return true;
      } catch (e) {
        errorMessage = 'Gagal upload.';
      }
    }
    isLoading = false;
    notifyListeners();
    return false;
  }
} 