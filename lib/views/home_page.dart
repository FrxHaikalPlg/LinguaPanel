import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../viewmodels/home_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final vm = Provider.of<HomeViewModel>(context, listen: false);
      vm.fetchUsername();
    });
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
      await AuthService().signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeViewModel>(context);
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
                vm.fetchUsername();
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
              vm.isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                      'Halo, ${vm.username ?? 'User'}!',
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
              // 4. List Riwayat Terakhir dari Firestore
              const Text(
                'Riwayat Terakhir:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseAuth.instance.currentUser == null
                      ? null
                      : FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('history')
                          .orderBy('timestamp', descending: true)
                          .limit(2)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('Belum ada riwayat.'));
                    }
                    final docs = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;
                        final imagePath = data['originalImageUrl'] as String?;
                        final status = data['status'] as String? ?? '-';
                        return ListTile(
                          leading: imagePath != null && imagePath.isNotEmpty
                              ? (imagePath.startsWith('http')
                                  ? Image.network(imagePath, width: 40, height: 40, fit: BoxFit.cover)
                                  : Image.file(File(imagePath), width: 40, height: 40, fit: BoxFit.cover))
                              : const Icon(Icons.image),
                          title: Text(imagePath?.split('/').last ?? 'Gambar'),
                          subtitle: Text('Status: $status'),
                          trailing: IconButton(
                            icon: const Icon(Icons.visibility),
                            onPressed: () {},
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 