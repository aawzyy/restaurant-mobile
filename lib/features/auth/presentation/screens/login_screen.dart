import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../../../core/di/injection_container.dart';
import '../mobx/auth_store.dart';
import 'otp_screen.dart';

import '../../../home/presentation/screens/main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authStore = sl<AuthStore>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Kita pakai List untuk menampung beberapa Reaction sekaligus
  final List<ReactionDisposer> _disposers = [];

  @override
  void initState() {
    super.initState();

    // --- REACTION 1: LOGIN EMAIL (Menunggu OTP) ---
    _disposers.add(
      reaction((_) => _authStore.isOtpSent, (bool isSent) {
        if (isSent) {
          _authStore.isOtpSent = false;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OtpScreen(email: _emailController.text),
            ),
          );
        }
      }),
    );

    // --- REACTION 2: LOGIN GOOGLE (Langsung Masuk) ---
    // Ini logika yang HILANG sebelumnya.
    // Kita pantau: Jika isAuthenticated jadi TRUE -> Pindah ke Menu Utama
    _disposers.add(
      reaction((_) => _authStore.isAuthenticated, (bool isAuth) {
        if (isAuth) {
          // Gunakan pushReplacement agar user tidak bisa back ke login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              // Pastikan ini mengarah ke Dashboard/Menu List kamu
              builder: (_) => const MainNavigationScreen(),
            ),
          );
        }
      }),
    );
  }

  @override
  void dispose() {
    // Matikan semua pemantau memory
    for (final d in _disposers) {
      d();
    }
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Welcome back,",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const Text(
                "Pondok\nNusantara.",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 50),

              // --- EMAIL INPUT ---
              _buildInputLabel("Email Address"),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration("e.g. fauzi@osama.com"),
              ),
              const SizedBox(height: 25),

              // --- PASSWORD INPUT ---
              _buildInputLabel("Password"),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: _inputDecoration("••••••••"),
              ),
              const SizedBox(height: 40),

              // --- SIGN IN BUTTON (EMAIL) ---
              Observer(
                builder: (_) => SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _authStore.isLoading
                        ? null
                        : () {
                            if (_emailController.text.isEmpty ||
                                _passwordController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Email dan Password wajib diisi",
                                  ),
                                ),
                              );
                              return;
                            }
                            _authStore.login(
                              _emailController.text,
                              _passwordController.text,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: _authStore.isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Sign In",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // --- DIVIDER OR ---
              const Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "OR",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey)),
                ],
              ),

              const SizedBox(height: 30),

              // --- GOOGLE SIGN IN BUTTON ---
              Observer(
                builder: (_) => SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton(
                    onPressed: _authStore.isLoading
                        ? null
                        : () => _authStore.loginWithGoogle(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // LOGO GOOGLE (Network + Fallback Icon)
                        Image.network(
                          "https://freepnglogo.com/images/all_img/1657952440google-logo-png-transparent.png",
                          height: 24,
                          // Fallback jika internet mati / gambar error
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.g_mobiledata,
                              color: Colors.red,
                              size: 30,
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const SizedBox(
                              width: 24,
                              height: 24,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Sign in with Google",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // --- ERROR MESSAGE ---
              Observer(
                builder: (_) => _authStore.errorMessage != null
                    ? Container(
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.red[100]!),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _authStore.errorMessage!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---
  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black26),
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    );
  }
}
