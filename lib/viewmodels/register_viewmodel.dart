import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterViewModel extends ChangeNotifier {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  Future<bool> register() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    if (passwordController.text != confirmPasswordController.text) {
      errorMessage = 'Password dan konfirmasi password tidak sama';
      isLoading = false;
      notifyListeners();
      return false;
    }
    final error = await AuthService().register(
      username: usernameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
    );
    isLoading = false;
    errorMessage = error;
    notifyListeners();
    return error == null;
  }

  Future<void> sendEmailVerification() async {
    await AuthService().sendEmailVerification();
  }

  Future<bool> registerWithGoogle() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    final error = await AuthService().signInWithGoogle();
    isLoading = false;
    errorMessage = error;
    notifyListeners();
    return error == null;
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
} 