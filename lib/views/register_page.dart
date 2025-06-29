import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/register_viewmodel.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final vm = Provider.of<RegisterViewModel>(context, listen: false);
      vm.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RegisterViewModel>(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Logo
              Image.asset('assets/logo.png', width: 80, height: 80),
              const SizedBox(height: 32),
              // 2. Username Field
              TextField(
                controller: vm.usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                enabled: !vm.isLoading,
              ),
              const SizedBox(height: 16),
              // 3. Email Field
              TextField(
                controller: vm.emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                enabled: !vm.isLoading,
              ),
              const SizedBox(height: 16),
              // 4. Password Field
              TextField(
                controller: vm.passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                enabled: !vm.isLoading,
              ),
              const SizedBox(height: 16),
              // 5. Konfirmasi Password Field
              TextField(
                controller: vm.confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Konfirmasi Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
                enabled: !vm.isLoading,
              ),
              const SizedBox(height: 24),
              // Error Message
              if (vm.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    vm.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              // 6. Register Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: vm.isLoading
                      ? null
                      : () async {
                          final success = await vm.register();
                          if (success && context.mounted) {
                            await vm.sendEmailVerification();
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => AlertDialog(
                                title: const Text('Verifikasi Email'),
                                content: const Text('Registrasi berhasil! Silakan cek email untuk verifikasi sebelum login.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); // tutup dialog
                                      Navigator.pushReplacementNamed(context, '/login');
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                  child: vm.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Register'),
                ),
              ),
              const SizedBox(height: 12),
              // Google Sign-In Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: Image.asset('assets/google_logo.png', width: 20, height: 20),
                  label: const Text('Sign in with Google'),
                  onPressed: vm.isLoading
                      ? null
                      : () async {
                          final success = await vm.registerWithGoogle();
                          if (success && context.mounted) {
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        },
                ),
              ),
              const SizedBox(height: 16),
              // Tombol ke Login
              TextButton(
                onPressed: vm.isLoading
                    ? null
                    : () {
                        Navigator.pop(context);
                      },
                child: const Text('Sudah punya akun? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 