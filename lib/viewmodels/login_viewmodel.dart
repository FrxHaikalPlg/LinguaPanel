import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  Future<bool> login() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    final error = await AuthService().login(
      email: emailController.text.trim(),
      password: passwordController.text,
    );
    isLoading = false;
    errorMessage = error;
    notifyListeners();
    return error == null;
  }

  Future<bool> loginWithGoogle() async {
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
} 