import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_service.dart';

class HomeViewModel extends ChangeNotifier {
  String? username;
  bool isLoading = true;

  HomeViewModel() {
    fetchUsername();
  }

  Future<void> fetchUsername() async {
    isLoading = true;
    notifyListeners();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final data = await UserService().getUser(user.uid);
      username = data?['username'] ?? 'User';
    } else {
      username = 'User';
    }
    isLoading = false;
    notifyListeners();
  }
} 