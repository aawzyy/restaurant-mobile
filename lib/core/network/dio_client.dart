import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../constants/constants.dart';

class DioClient {
  late Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // Logger untuk melihat apakah header terkirim atau tidak
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
        compact: true,
      ),
    );

    // INI SOLUSINYA: Interceptor untuk menyisipkan token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Ambil SharedPreferences secara dinamis tiap ada request
          final prefs = await SharedPreferences.getInstance();

          // Ambil token menggunakan Key yang sama dengan AuthLocalDataSource
          final String? token = prefs.getString(AppConstants.tokenKey);

          if (token != null && token.isNotEmpty) {
            // Sisipkan ke header
            options.headers['Authorization'] = 'Bearer $token';
            print("DIO INTERCEPTOR: Token ditemukan, menyisipkan ke header.");
          } else {
            print("DIO INTERCEPTOR: Token TIDAK ditemukan.");
          }

          return handler.next(options); // Lanjutkan request
        },
        onError: (DioException e, handler) {
          // Jika server balas 401, berarti token di HP sudah tidak valid di database
          if (e.response?.statusCode == 401) {
            print("DIO ERROR: Sesi berakhir (401).");
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get instance => _dio;
}
