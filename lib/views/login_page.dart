import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LoginViewModel>(context);
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
              // 2. Email Field
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
              // 3. Password Field
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
              // 4. Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: vm.isLoading
                      ? null
                      : () async {
                          final success = await vm.login();
                          if (success && context.mounted) {
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        },
                  child: vm.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Login'),
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
                          final success = await vm.loginWithGoogle();
                          if (success && context.mounted) {
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        },
                ),
              ),
              const SizedBox(height: 16),
              // 5. Register Button
              TextButton(
                onPressed: vm.isLoading
                    ? null
                    : () {
                        Navigator.pushNamed(context, '/register');
                      },
                child: const Text('Belum punya akun? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 