import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();

  // Register
  Future<String?> register({
    required String username,
    required String email,
    required String password,
  }) async {
    if (username.trim().isEmpty) return 'Username tidak boleh kosong';
    if (!_isValidEmail(email)) return 'Format email tidak valid';
    if (password.length < 6) return 'Password minimal 6 karakter';
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.updateDisplayName(username);
      // Tidak langsung buat dokumen user di Firestore, tunggu sampai user login dan verifikasi email
      return null;
    } on FirebaseAuthException catch (e) {
      return _firebaseErrorToMessage(e);
    } catch (e) {
      return 'Terjadi kesalahan. Coba lagi.';
    }
  }

  // Login
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    if (!_isValidEmail(email)) return 'Format email tidak valid';
    if (password.length < 6) return 'Password minimal 6 karakter';
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final user = userCredential.user;
      if (user != null && user.emailVerified) {
        await _userService.createOrUpdateUser(
          uid: user.uid,
          username: user.displayName ?? '',
          email: user.email ?? '',
          photoUrl: user.photoURL,
        );
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return _firebaseErrorToMessage(e);
    } catch (e) {
      return 'Terjadi kesalahan. Coba lagi.';
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Helper validasi email
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailRegex.hasMatch(email);
  }

  // Helper error message
  String _firebaseErrorToMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email sudah terdaftar.';
      case 'user-not-found':
        return 'User tidak ditemukan.';
      case 'wrong-password':
        return 'Password salah.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'weak-password':
        return 'Password terlalu lemah.';
      default:
        return 'Autentikasi gagal. Coba lagi.';
    }
  }

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Kirim email verifikasi
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  // Google Sign-In
  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return 'Login dengan Google dibatalkan.';
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user != null) {
        await _userService.createOrUpdateUser(
          uid: user.uid,
          username: user.displayName ?? '',
          email: user.email ?? '',
          photoUrl: user.photoURL,
        );
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return _firebaseErrorToMessage(e);
    } catch (e) {
      return 'Login dengan Google gagal.';
    }
  }
} 