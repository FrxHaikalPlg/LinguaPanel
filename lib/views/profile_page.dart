import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_service.dart';
import '../services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _username;
  String? _email;
  String? _photoUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final data = await UserService().getUser(user.uid);
      setState(() {
        _username = data?['username'] ?? 'User';
        _email = data?['email'] ?? user.email ?? '-';
        _photoUrl = data?['photoUrl'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _username = 'User';
        _email = '-';
        _photoUrl = null;
        _isLoading = false;
      });
    }
  }

  void _editUsername() async {
    final controller = TextEditingController(text: _username);
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
    if (result != null && result.isNotEmpty && result != _username) {
      setState(() {
        _isLoading = true;
      });
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await UserService().createOrUpdateUser(
          uid: user.uid,
          username: result,
          email: _email ?? user.email ?? '-',
          photoUrl: _photoUrl,
        );
        await user.updateDisplayName(result);
        await _fetchProfile();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username berhasil diupdate!')),
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _editPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _isLoading = true;
      });
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final path = pickedFile.path;
        await UserService().createOrUpdateUser(
          uid: user.uid,
          username: _username ?? 'User',
          email: _email ?? user.email ?? '-',
          photoUrl: path,
        );
        await user.updatePhotoURL(path);
        await _fetchProfile();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto profil berhasil diupdate! (dummy)')),
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _logout(BuildContext context) async {
    await AuthService().signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Widget _buildAvatar() {
    if (_photoUrl != null && _photoUrl!.isNotEmpty) {
      if (_photoUrl!.startsWith('http')) {
        return CircleAvatar(
          radius: 48,
          backgroundImage: NetworkImage(_photoUrl!),
        );
      } else {
        return CircleAvatar(
          radius: 48,
          backgroundImage: FileImage(File(_photoUrl!)),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 1. Avatar User
                  _buildAvatar(),
                  const SizedBox(height: 24),
                  // 2. Username
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _username ?? 'User',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: _editUsername,
                        tooltip: 'Ubah Username',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 3. Email
                  Text(
                    _email ?? '-',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  // 4. Tombol Ubah Foto Profil
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Ubah Foto Profil'),
                      onPressed: _editPhoto,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 5. Tombol Logout
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      onPressed: () => _logout(context),
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