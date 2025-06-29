import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_service.dart';

class ProfileViewModel extends ChangeNotifier {
  String? username;
  String? email;
  String? photoUrl;
  bool isLoading = true;
  String? errorMessage;

  ProfileViewModel() {
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading = true;
    notifyListeners();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final data = await UserService().getUser(user.uid);
      username = data?['username'] ?? 'User';
      email = data?['email'] ?? user.email ?? '-';
      photoUrl = data?['photoUrl'];
    } else {
      username = 'User';
      email = '-';
      photoUrl = null;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateUsername(String newUsername) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await UserService().createOrUpdateUser(
          uid: user.uid,
          username: newUsername,
          email: email ?? user.email ?? '-',
          photoUrl: photoUrl,
        );
        await user.updateDisplayName(newUsername);
        await fetchProfile();
      } catch (e) {
        errorMessage = 'Gagal update username';
      }
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> updatePhoto(String path) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await UserService().createOrUpdateUser(
          uid: user.uid,
          username: username ?? 'User',
          email: email ?? user.email ?? '-',
          photoUrl: path,
        );
        await user.updatePhotoURL(path);
        await fetchProfile();
      } catch (e) {
        errorMessage = 'Gagal update foto profil';
      }
    }
    isLoading = false;
    notifyListeners();
  }

  void reset() {
    username = null;
    email = null;
    photoUrl = null;
    errorMessage = null;
    isLoading = true;
    notifyListeners();
  }
} 