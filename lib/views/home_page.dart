import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _username;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final data = await UserService().getUser(user.uid);
      setState(() {
        _username = data?['username'] ?? 'User';
        _isLoading = false;
      });
    } else {
      setState(() {
        _username = 'User';
        _isLoading = false;
      });
    }
  }

  void _confirmExit(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar Aplikasi'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) async {
    await AuthService().signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _confirmExit(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('LinguaPanel'),
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () async {
                await Navigator.pushNamed(context, '/profile');
                _fetchUsername();
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _logout(context),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Greeting
              _isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                      'Halo, ${_username ?? 'User'}!',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
              const SizedBox(height: 24),
              // 2. Tombol Upload Image
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload Gambar'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/upload');
                  },
                ),
              ),
              const SizedBox(height: 16),
              // 3. Tombol History
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.history),
                  label: const Text('Riwayat Translasi'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/history');
                  },
                ),
              ),
              const SizedBox(height: 24),
              // 4. List Dummy History
              const Text(
                'Riwayat Terakhir:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.image),
                      title: const Text('Komik1.png'),
                      subtitle: const Text('Status: Selesai'),
                      trailing: IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: () {},
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.image),
                      title: const Text('Komik2.jpg'),
                      subtitle: const Text('Status: Proses'),
                      trailing: IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 