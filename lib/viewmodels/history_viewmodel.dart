import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_service.dart';

class HistoryViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  Future<void> deleteHistory(String docId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await UserService().deleteHistory(uid: user.uid, docId: docId);
      } catch (e) {
        errorMessage = 'Gagal menghapus riwayat.';
      }
    }
    isLoading = false;
    notifyListeners();
  }
} 