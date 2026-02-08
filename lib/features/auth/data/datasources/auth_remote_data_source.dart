import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<Response> login(String email, String password);
  Future<Response> verifyOtp(String email, String otp);
  Future<Response> googleLogin(String accessToken); // Tambah ini
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<Response> login(String email, String password) async {
    return await _dio.post(
      '/login',
      data: {'email': email, 'password': password},
    );
  }

  @override
  Future<Response> verifyOtp(String email, String otp) async {
    return await _dio.post(
      '/login/verify',
      data: {'email': email, 'otp_code': otp},
    );
  }

  @override
  Future<Response> googleLogin(String accessToken) async {
    return await _dio.post('/auth/google', data: {'access_token': accessToken});
  }
}
