import 'package:dio/dio.dart';

class AppApi {
  static final Dio _dio = Dio();

  static Future<Map<String, dynamic>> login(String username, String password) async {
    final url = 'https://da7332809535.ngrok-free.app/api/login';
    try {
      final response = await _dio.post(
        url,
        data: {
          'username': username,
          'password': password,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }
}
