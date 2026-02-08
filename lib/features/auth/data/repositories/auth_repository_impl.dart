import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/auth_local_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<void> login(String email, String password) async {
    await remoteDataSource.login(email, password);
  }

  @override
  Future<UserEntity> verifyOtp(String email, String otp) async {
    final response = await remoteDataSource.verifyOtp(email, otp);

    // DEBUG: Cek isi response di terminal
    print("Response API: ${response.data}");

    // Pastikan path-nya benar. Jika Laravel kamu mengembalikan { "user": ..., "token": ... }
    final userModel = UserModel.fromJson(response.data['user']);
    final token = response.data['access_token'];

    if (token != null) {
      await localDataSource.saveToken(token);
    }

    return userModel;
  }

  @override
  Future<UserEntity> loginWithGoogle(String accessToken) async {
    final response = await remoteDataSource.googleLogin(accessToken);

    // Parsing data sama seperti verifyOtp
    final userModel = UserModel.fromJson(response.data['user']);
    final token = response.data['access_token'];

    if (token != null) {
      await localDataSource.saveToken(token);
    }
    return userModel;
  }
}
