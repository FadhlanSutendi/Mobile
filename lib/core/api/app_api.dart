import 'package:dio/dio.dart';

class AppApi {
  static final Dio _dio = Dio();

  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    final url = 'https://b398739fe74b.ngrok-free.app/api/login';
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

  static Future<Map<String, dynamic>?> fetchUnitItem(String barcode) async {
    final url =
        'https://b398739fe74b.ngrok-free.app/api/unit-items?code_unit=$barcode';
    try {
      final response = await _dio.get(url);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }
}
