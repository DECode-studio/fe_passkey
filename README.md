# Passkey Auth POC (Flutter)

Implementasi Proof of Concept untuk autentikasi **Passkey** menggunakan Flutter dan Clean Architecture.

## Arsitektur
Project ini mengikuti prinsip **Clean Architecture** dengan pemisahan layer sebagai berikut:
- **Core**: Konfigurasi environment, networking (Dio), secure storage, dan dependensi dasar.
- **Data**: Implementasi datasource (Remote & Native Passkey), repository implementation, dan model-model data.
- **Domain**: Business logic murni berupa Entity (diwakili model), Repository interface, dan Use Cases.
- **Presentation**: State management menggunakan BLoC dan UI menggunakan Material 3.

## Fitur Utama
- **Passkey Registration**: Membuat credential baru menggunakan biometrik perangkat.
- **Passkey Login**: Autentikasi aman tanpa password.
- **Secure Session**: Token JWT disimpan di `flutter_secure_storage`.
- **Automatic Token Refresh**: Menggunakan interceptor Dio untuk menangani token kadaluwarsa secara otomatis.
- **Capability Check**: Mendeteksi dukungan passkey pada perangkat user.

## Persyaratan
- Flutter SDK 3.10.0+
- Dart 3.0.0+
- Android API 23+ (Direkomendasikan 28+)
- iOS 15.0+ (Associated Domains required for production)

## Cara Menjalankan
1. Clone repository.
2. Jalankan `flutter pub get`.
3. Jalankan code generation:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
4. Jalankan aplikasi:
   ```bash
   flutter run
   ```

## Konfigurasi Platform
Untuk menjalankan passkey secara real, Anda perlu mengonfigurasi:
- **Android**: Digital Asset Links (`assetlinks.json`) pada domain backend.
- **iOS**: Associated Domains di Xcode dan `apple-app-site-association` pada domain backend.

---
Dikembangkan oleh Antigravity untuk POC Passkey Staffinc.
