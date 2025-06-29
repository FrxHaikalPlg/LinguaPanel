import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_service.dart';
import '../services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../viewmodels/profile_viewmodel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final vm = Provider.of<ProfileViewModel>(context, listen: false);
      vm.fetchProfile();
    });
  }

  Widget _buildAvatar(ProfileViewModel vm) {
    if (vm.photoUrl != null && vm.photoUrl!.isNotEmpty) {
      if (vm.photoUrl!.startsWith('http')) {
        return CircleAvatar(
          radius: 48,
          backgroundImage: NetworkImage(vm.photoUrl!),
        );
      } else {
        return CircleAvatar(
          radius: 48,
          backgroundImage: FileImage(File(vm.photoUrl!)),
        );
      }
    }
    return const CircleAvatar(
      radius: 48,
      backgroundImage: AssetImage('assets/avatar_placeholder.png'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProfileViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 1. Avatar User
                  _buildAvatar(vm),
                  const SizedBox(height: 24),
                  // 2. Username
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        vm.username ?? 'User',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final controller = TextEditingController(text: vm.username);
                          final result = await showDialog<String>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Ubah Username'),
                              content: TextField(
                                controller: controller,
                                decoration: const InputDecoration(labelText: 'Username'),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, controller.text.trim()),
                                  child: const Text('Simpan'),
                                ),
                              ],
                            ),
                          );
                          if (result != null && result.isNotEmpty && result != vm.username) {
                            await vm.updateUsername(result);
                            if (context.mounted && vm.errorMessage == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Username berhasil diupdate!')),
                              );
                            }
                          }
                        },
                        tooltip: 'Ubah Username',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 3. Email
                  Text(
                    vm.email ?? '-',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  // 4. Tombol Ubah Foto Profil
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Ubah Foto Profil'),
                      onPressed: () async {
                        final picker = ImagePicker();
                        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          await vm.updatePhoto(pickedFile.path);
                          if (context.mounted && vm.errorMessage == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Foto profil berhasil diupdate! (dummy)')),
                            );
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 5. Tombol Logout
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Logout'),
                            content: const Text('Yakin ingin logout?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Logout'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          final vm = Provider.of<ProfileViewModel>(context, listen: false);
                          vm.reset();
                          await AuthService().signOut();
                          if (context.mounted) {
                            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 6. Tombol Kembali
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Kembali'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
} 