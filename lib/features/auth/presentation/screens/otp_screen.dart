import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import '../../../../core/di/injection_container.dart';
import '../../../home/presentation/screens/main_navigation_screen.dart';
import '../mobx/auth_store.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _authStore = sl<AuthStore>();
  final _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    reaction((_) => _authStore.isAuthenticated, (bool auth) {
      if (auth) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Menggunakan AppBar transparan agar tidak menambah sesak layar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        // SingleChildScrollView mencegah overflow saat keyboard muncul
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Verification,",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                "Check your email.",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black38,
                    fontSize: 14,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(
                      text: "We've sent a 6-digit verification code to ",
                    ),
                    TextSpan(
                      text: widget.email,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),

              // OTP Input Field
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 6,
                  autofocus: true,
                  style: const TextStyle(
                    fontSize: 32,
                    letterSpacing: 15,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    counterText: "", // Menghilangkan tulisan 0/6
                    border: InputBorder.none,
                    hintText: "000000",
                    hintStyle: TextStyle(color: Colors.black12),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Error Message
              Observer(
                builder: (_) => _authStore.errorMessage != null
                    ? Center(
                        child: Text(
                          _authStore.errorMessage!,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : const SizedBox(height: 13),
              ),

              const SizedBox(height: 30),

              // Verify Button
              Observer(
                builder: (_) => SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _authStore.isLoading
                        ? null
                        : () => _authStore.verifyOtp(
                            widget.email,
                            _otpController.text,
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.black, // Konsisten dengan tombol login
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
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
                            "Verify Account",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Resend Code Option
              Center(
                child: TextButton(
                  onPressed: () {
                    // Logika resend bisa ditambahkan di AuthStore nanti
                  },
                  child: const Text(
                    "Resend Code",
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
