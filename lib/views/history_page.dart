import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import '../services/user_service.dart';
import 'package:provider/provider.dart';
import '../viewmodels/history_viewmodel.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final vm = Provider.of<HistoryViewModel>(context, listen: false);
      vm.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('User tidak ditemukan.')),
      );
    }
    final historyRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('history')
        .orderBy('timestamp', descending: true);

    final vm = Provider.of<HistoryViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Translasi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Search Bar (dummy, belum implementasi search)
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari riwayat...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              enabled: false,
            ),
            const SizedBox(height: 16),
            // 2. Filter Dropdown (dummy, belum implementasi filter)
            Row(
              children: [
                const Text('Filter:'),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: 'Semua',
                  items: const [
                    DropdownMenuItem(value: 'Semua', child: Text('Semua')),
                    DropdownMenuItem(value: 'Selesai', child: Text('Selesai')),
                    DropdownMenuItem(value: 'Proses', child: Text('Proses')),
                  ],
                  onChanged: null,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 3. Judul List
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Daftar Riwayat:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            // 4. List History dari Firestore
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: historyRef.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('Belum ada riwayat translasi.'));
                  }
                  final docs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      final imagePath = data['originalImageUrl'] as String?;
                      final status = data['status'] as String? ?? '-';
                      final timestamp = (data['timestamp'] as Timestamp?)?.toDate();
                      return ListTile(
                        leading: imagePath != null && imagePath.isNotEmpty
                            ? (imagePath.startsWith('http')
                                ? Image.network(imagePath, width: 40, height: 40, fit: BoxFit.cover)
                                : Image.file(File(imagePath), width: 40, height: 40, fit: BoxFit.cover))
                            : const Icon(Icons.image),
                        title: Text(imagePath?.split('/').last ?? 'Gambar'),
                        subtitle: Text('Status: $status\n${timestamp != null ? timestamp.toString() : ''}'),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: vm.isLoading
                              ? null
                              : () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Hapus Riwayat'),
                                      content: const Text('Yakin ingin menghapus riwayat ini?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          child: const Text('Hapus'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await vm.deleteHistory(docs[index].id);
                                    if (context.mounted && vm.errorMessage == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Riwayat berhasil dihapus!')),
                                      );
                                    }
                                  }
                                },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            // 5. Tombol Kembali
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