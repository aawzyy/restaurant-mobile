import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import '../../../../core/di/injection_container.dart';
import '../../../home/presentation/screens/main_navigation_screen.dart';
import '../mobx/auth_store.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthStore _authStore = sl<AuthStore>();

  @override
  void initState() {
    super.initState();
    // 1. Jalankan pengecekan token
    _authStore.checkLoginStatus();

    // 2. Tunggu hasilnya, lalu navigasi
    // Kita kasih delay dikit biar logonya sempat kelihatan (estetika)
    Future.delayed(const Duration(seconds: 2), () {
      if (_authStore.isAuthenticated) {
        // Kalau ada token -> Ke Menu Utama
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
        );
      } else {
        // Kalau tidak ada -> Ke Login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Sesuaikan warna brand
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ganti Icon ini dengan Logo Gambar kamu nanti
            const Icon(
              Icons.restaurant_menu_rounded,
              size: 100,
              color: Colors.deepOrange,
            ),
            const SizedBox(height: 20),
            const Text(
              "Pondok Nusantara",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 40),
            // Loading kecil di bawah
            const CircularProgressIndicator(color: Colors.deepOrange),
          ],
        ),
      ),
    );
  }
}
