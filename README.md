# 📱 Pondok Nusantara - Mobile App

Aplikasi mobile untuk pelanggan restoran Pondok Nusantara. Memungkinkan pengguna login, melihat menu, dan melakukan pemesanan secara realtime. Dibangun dengan **Flutter** dan **MobX**.

## 📱 Fitur Aplikasi

- **Google Sign-In:** Login instan tanpa password.
- **Menu Browsing:** Tampilan menu interaktif dengan kategori.
- **Cart & Checkout:** Manajemen keranjang belanja.
- **Order History:** Melacak status pesanan (Pending -> Cooking -> Served).

## 🛠️ Prasyarat

- Flutter SDK (Latest Stable)
- Android Studio / VS Code
- Android Emulator / Physical Device

## 📦 Panduan Instalasi

1. **Clone Repository**
    git clone https://github.com/aawzyy/restaurant-mobile.git
    cd restaurant-mobile

2. **Install Dependencies**
    flutter pub get

3. **Generate MobX Code Jalankan ini setiap kali ada perubahan pada file Store (.g.dart)**
    flutter pub run build_runner build --delete-conflicting-outputs

## ⚙️ Konfigurasi API

Buka file lib/core/constants/api_constants.dart (atau file konfigurasi Anda) dan sesuaikan URL Backend:

    class ApiConstants {
        // Ganti dengan IP Address Laptop Anda (bukan localhost) jika pakai Emulator/HP
        // Contoh: 192.168.1.5
        static const String baseUrl = "http://10.0.2.2:8000/api"; 
    }

## 🔑 Setup Google Sign-In (Firebase/OAuth)

Agar Google Login berfungsi di Android:
    
1. **Dapatkan SHA-1 Fingerprint dari keystore debug Anda:**
    flutter create .
    cd android
    chmod +x gradlew
    ./gradlew signingReport

2. **Daftarkan SHA-1 tersebut di Google Cloud Console (Credentials > OAuth 2.0 Client IDs > Android)**

## 🏃‍♂️ Menjalankan Aplikasi
Pastikan Emulator menyala atau HP terhubung.

    flutter run

## 📂 Struktur Project

    lib/core: Konfigurasi global, DI (GetIt), Network client.

    lib/features: Modul fitur (Auth, Menu, Order).

        presentation: UI (Screens, Widgets) & State Management (MobX).

        domain: UseCases & Entities.

        data: Repositories & API Services.

**Dibuat oleh Muhammad Fauzi Osama.**