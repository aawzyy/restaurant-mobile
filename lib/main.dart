import 'package:flutter/material.dart';
import 'core/di/injection_container.dart' as di;
import 'features/auth/presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi Service Locator (GetIt)
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        useMaterial3: true,
        // Font global biar cantik
        fontFamily: 'Poppins',
      ),
      // GANTI DARI LoginScreen() MENJADI SplashScreen()
      home: const SplashScreen(),
    );
  }
}
