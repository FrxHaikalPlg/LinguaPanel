import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> createOrUpdateUser({
    required String uid,
    required String username,
    required String email,
    String? photoUrl,
  }) async {
    await users.doc(uid).set({
      'username': username,
      'email': email,
      'photoUrl': photoUrl,
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getUser(String uid) async {
    final doc = await users.doc(uid).get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    }
    return null;
  }
} 