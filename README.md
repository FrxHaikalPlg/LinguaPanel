# LinguaPanel

## Project Overview
LinguaPanel adalah aplikasi mobile berbasis Flutter yang membantu pengguna menerjemahkan komik digital secara otomatis. Pengguna dapat mengunggah gambar komik, lalu hasil terjemahan akan muncul di aplikasi. Aplikasi ini mendukung autentikasi, riwayat translasi, dan pengelolaan profil berbasis Firebase.

## Chosen SDG & Justification
**SDG 4: Quality Education**
> LinguaPanel mendukung akses literasi lintas bahasa, membantu pembaca komik dari berbagai negara memahami konten tanpa batasan bahasa. Ini sejalan dengan tujuan SDG 4 untuk meningkatkan akses pendidikan dan literasi global.

## Tech Stack
- **Flutter** (Dart)
- **Firebase Auth** (Email/Password, Google Sign-In)
- **Cloud Firestore** (CRUD data user & history)
- **Provider** (State management, MVVM)
- **image_picker** (Pilih gambar dari galeri)

## Setup & Installation
1. **Clone repo:**
   ```bash
   git clone github.com/FrxHaikalPlg/LinguaPanel/
   cd linguapanel
   ```
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Tambahkan file `google-services.json` ke folder `android/app/`**
4. **Jalankan aplikasi:**
   ```bash
   flutter run
   ```

## How to Use
- **Register/Login** dengan email atau Google.
- **Upload gambar komik** di halaman Upload.
- **Lihat riwayat translasi** di halaman History.
- **Kelola profil** (ubah username, foto profil, logout) di halaman Profile.

## Contribution Guidelines
- Fork repo, buat branch baru, lakukan perubahan, dan ajukan pull request.
- Ikuti arsitektur MVVM (Model-View-ViewModel) dengan Provider.
- Pastikan kode clean dan teruji.

## Firebase Usage
- **Firebase Auth:**
  - Email/password & Google Sign-In
  - Email verification
- **Cloud Firestore:**
  - Data user (`users/<uid>`)
  - Riwayat upload/translasi (`users/<uid>/history`)

## APK Download
- [APK split (arm64, armeabi-v7a, x86_64)](https://github.com/FrxHaikalPlg/LinguaPanel/releases)

## More
- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Provider package](https://pub.dev/packages/provider)

---

*Customize this README as needed for your project or presentation.*
