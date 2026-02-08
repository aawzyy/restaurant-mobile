import '../entities/user_entity.dart';

abstract class AuthRepository {
  // Tahap 1: Kirim Email & Password untuk dapat OTP
  Future<void> login(String email, String password);

  // Tahap 2: Kirim OTP untuk dapat Token & Data User
  Future<UserEntity> verifyOtp(String email, String otp);

  Future<UserEntity> loginWithGoogle(String accessToken);
}
