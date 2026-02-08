import 'package:mobx/mobx.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../domain/usecases/google_login_usecase.dart';
import 'package:dio/dio.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStoreBase with _$AuthStore;

abstract class _AuthStoreBase with Store {
  final LoginUseCase loginUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final AuthLocalDataSource localDataSource;
  final GoogleLoginUseCase googleLoginUseCase;

  // --- INI YANG HILANG TADI ---
  // Kita inisialisasi object GoogleSignIn di sini
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  _AuthStoreBase({
    required this.loginUseCase,
    required this.verifyOtpUseCase,
    required this.localDataSource,
    required this.googleLoginUseCase,
  });

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  bool isOtpSent = false;

  @observable
  UserEntity? user;

  @observable
  bool isAuthenticated = false;

  // --- CEK STATUS LOGIN (SATPAM) ---
  @action
  Future<void> checkLoginStatus() async {
    isLoading = true;
    try {
      final token = await localDataSource.getToken();
      if (token != null && token.isNotEmpty) {
        isAuthenticated = true;
      } else {
        isAuthenticated = false;
      }
    } catch (e) {
      isAuthenticated = false;
    } finally {
      isLoading = false;
    }
  }

  // --- LOGOUT ---
  @action
  Future<void> logout() async {
    isLoading = true;
    try {
      await _googleSignIn.signOut(); // Logout dari Google juga biar bersih
      await localDataSource.clearToken();
      isAuthenticated = false;
      user = null;
    } catch (e) {
      errorMessage = "Gagal Logout";
    } finally {
      isLoading = false;
    }
  }

  // --- LOGIN BIASA ---
  @action
  Future<void> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    try {
      await loginUseCase.execute(email, password);
      isOtpSent = true;
    } catch (e) {
      errorMessage = "Gagal Login: Silakan cek email dan password Anda.";
    } finally {
      isLoading = false;
    }
  }

  // --- VERIFIKASI OTP ---
  @action
  Future<void> verifyOtp(String email, String otp) async {
    isLoading = true;
    errorMessage = null;
    try {
      final result = await verifyOtpUseCase.execute(email, otp);
      user = result;
      isAuthenticated = true;
    } catch (e) {
      errorMessage = "Kode OTP salah atau sudah kadaluarsa.";
    } finally {
      isLoading = false;
    }
  }

  @action
  void resetError() => errorMessage = null;

  // --- LOGIN GOOGLE ---
  @action
  Future<void> loginWithGoogle() async {
    isLoading = true;
    errorMessage = null; // Reset error lama
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        isLoading = false;
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? accessToken = googleAuth.accessToken;

      if (accessToken != null) {
        final result = await googleLoginUseCase.execute(accessToken);
        user = result;
        isAuthenticated = true;
      }
    } catch (e) {
      // --- PERBAIKAN PESAN ERROR DI SINI ---
      if (e is DioException) {
        // Cek jika status codenya 401 (Unauthorized) dari Backend tadi
        if (e.response?.statusCode == 401) {
          // Ambil pesan cantik dari JSON backend
          errorMessage = e.response?.data['message'] ?? "Akun tidak terdaftar.";
        } else if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.connectionError) {
          errorMessage = "Gagal terhubung ke server. Cek koneksi internet.";
        } else {
          errorMessage = "Terjadi kesalahan server (${e.response?.statusCode})";
        }
      } else {
        // Error lain (misal dari Google Sign In pluginnya)
        errorMessage = "Gagal Login Google. Coba lagi.";
        print("System Error: $e");
      }
    } finally {
      isLoading = false;
    }
  }
}
