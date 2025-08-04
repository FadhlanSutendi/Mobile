import 'package:dio/dio.dart';

class AppApi {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://da7332809535.ngrok-free.app/api',
      headers: {'Accept': 'application/json'},
    ),
  );

  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    final response = await _dio.post(
      '/login',
      data: FormData.fromMap({
        'username': username,
        'password': password,
      }),
    );
    return response.data;
  }
}
