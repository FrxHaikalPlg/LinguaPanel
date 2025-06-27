import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LinguaPanel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {}, // Nanti untuk logout
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Greeting
            const Text(
              'Halo, User!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
    );
  }
} 