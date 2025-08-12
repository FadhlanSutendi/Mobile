import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mobile_scanner/mobile_scanner.dart';

class AppApi {
  static final Dio _dio = Dio();

  /// LOGIN METHOD
  static Future<Map<String, dynamic>?> login(String username, String password) async {
    const url = 'https://6d2ac8adc27b.ngrok-free.app/api/login';
    try {
      final response = await _dio.post(
        url,
        data: jsonEncode({
          'username': username,
          'password': password,
        }),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      return response.data as Map<String, dynamic>;
    } on DioError catch (e) {
      print("LOGIN ERROR:");
      print(e);
      return null;
    }
  }

  /// FETCH UNIT ITEM METHOD (dengan http package)+++++++++++++
  static Future<Map<String, dynamic>?> fetchUnitItem(String barcode, {required String token}) async {
    final url = Uri.parse('https://6d2ac8adc27b.ngrok-free.app/api/unit-items?code_unit=$barcode');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("fetchUnitItem ERROR: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("fetchUnitItem Exception: $e");
      return null;
    }
  }

  /// FETCH UNIT LOAN CHECK (for scan barcode student)
  static Future<Map<String, dynamic>?> fetchUnitLoanCheck(String codeUnit, {required String token}) async {
    final url = Uri.parse('https://6d2ac8adc27b.ngrok-free.app/api/unit-loan/check');
    try {
      print('fetchUnitLoanCheck: token=$token, code_unit=$codeUnit'); // debug
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'code_unit': codeUnit}),
      );
      print('fetchUnitLoanCheck: status=${response.statusCode}, body=${response.body}'); // debug

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("fetchUnitLoanCheck ERROR: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("fetchUnitLoanCheck Exception: $e");
      return null;
    }
  }

  /// FETCH STUDENT/TEACHER DATA (search by query param)
  static Future<Map<String, dynamic>?> fetchPerson(String id, {required String type, required String token}) async {
    // Use search query for student/teacher
    final url = Uri.parse('https://6d2ac8adc27b.ngrok-free.app/api/$type?search=$id');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("fetchPerson ERROR: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("fetchPerson Exception: $e");
      return null;
    }
  }

  /// POST UNIT LOAN
  static Future<Map<String, dynamic>?> postUnitLoan(Map<String, dynamic> data, {required String token}) async {
    final url = Uri.parse('https://6d2ac8adc27b.ngrok-free.app/api/unit-loan');
    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    // Only add fields that are not null and not 'image'
    data.forEach((key, value) {
      if (value != null && key != 'image') {
        request.fields[key] = value.toString();
      }
    });
    if (data['image'] != null) {
      request.files.add(await http.MultipartFile.fromPath('image', data['image']));
    }
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        print("postUnitLoan ERROR: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("postUnitLoan Exception: $e");
      return null;
    }
  }

  /// RETURN UNIT LOAN (PUT /unit-loan/{id})
  static Future<Map<String, dynamic>?> returnUnitLoan(String loanId, String returnedAt, {required String token}) async {
    final url = Uri.parse('https://6d2ac8adc27b.ngrok-free.app/api/unit-loan/$loanId');
    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'returned_at': returnedAt}),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("returnUnitLoan ERROR: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("returnUnitLoan Exception: $e");
      return null;
    }
  }
}