import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mobile_scanner/mobile_scanner.dart';

class AppApi {
  static final Dio _dio = Dio();
  static String imagePath = 'https://4803a8d6f334.ngrok-free.app/storage/';

  /// LOGIN METHOD
  static Future<Map<String, dynamic>?> login(
      String username, String password) async {
    const url = 'https://4803a8d6f334.ngrok-free.app/api/login';
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
  static Future<Map<String, dynamic>?> fetchUnitItem(String barcode,
      {required String token}) async {
    final url = Uri.parse(
        'https://4803a8d6f334.ngrok-free.app/api/unititems?code_unit=$barcode');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json', // tambahkan Accept
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
  static Future<Map<String, dynamic>?> fetchUnitLoanCheck(String unitCode,
      {required String token}) async {
    final sanitizedUnitCode = unitCode.trim();
    final url =
        Uri.parse('https://4803a8d6f334.ngrok-free.app/api/unit-loan/check');
    try {
      print('fetchUnitLoanCheck: token=$token, unit_code=$sanitizedUnitCode');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json', // tambahkan Accept
        },
        body: jsonEncode({'code_unit': sanitizedUnitCode}),
      );
      print(
          'fetchUnitLoanCheck: status=${response.statusCode}, body=${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(
            "fetchUnitLoanCheck ERROR: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("fetchUnitLoanCheck Exception: $e");
      return null;
    }
  }

  /// FETCH STUDENT/TEACHER DATA (search by query param)
  static Future<Map<String, dynamic>?> fetchPerson(String id,
      {required String type, required String token}) async {
    // Use search query for student/teacher
    print('fetchPerson: search="$id", type="$type"');
    final url =
        Uri.parse('https://4803a8d6f334.ngrok-free.app/api/$type?search=$id');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json', // tambahkan Accept
        },
      );
      print(
          'fetchPerson: status=${response.statusCode}, body=${response.body}');
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
  static Future<Map<String, dynamic>?> postUnitLoan(Map<String, dynamic> data,
      {required String token}) async {
    final url = Uri.parse('https://4803a8d6f334.ngrok-free.app/api/unit-loan');
    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json'; // tambahkan Accept
    // Only add fields that are not null and not 'image'
    data.forEach((key, value) {
      if (value != null && key != 'image') {
        request.fields[key] = value.toString();
      }
    });
    if (data['image'] != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', data['image']));
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

  static Future<Map<String, dynamic>?> returnUnitLoan(
      String loanId, String returnedAt,
      {required String token}) async {
    final url =
        Uri.parse('https://4803a8d6f334.ngrok-free.app/api/unit-loan/$loanId');
    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json', // tambahkan Accept
        },
        body: jsonEncode({'returned_at': returnedAt}),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(
            "returnUnitLoan ERROR: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("returnUnitLoan Exception: $e");
      return null;
    }
  }

  /// FETCH HISTORY UNIT LOAN
  static Future<Map<String, dynamic>?> fetchUnitLoanHistory({
    required String token,
    String data = 'borrowing',
    String sortByType = 'desc',
    String sortByTime = 'asc',
    String search = '',
  }) async {
    List<Map<String, dynamic>> allItems = [];
    int page = 1;
    int lastPage = 1;

    try {
      do {
        final url = Uri.parse(
          'https://4803a8d6f334.ngrok-free.app/api/unit-loan/history'
          '?data=$data&sort_by_type=$sortByType&sort_by_time=$sortByTime&search=$search&page=$page',
        );

        final response = await http.get(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        );

        print(
            "fetchUnitLoanHistory page $page: status=${response.statusCode} - ${response.body}");

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          allItems.addAll(List<Map<String, dynamic>>.from(data['data']));
          lastPage = data['meta']['last_page'];
          page++;
        } else {
          print(
              "fetchUnitLoanHistory ERROR: ${response.statusCode} - ${response.body}");
          return null;
        }
      } while (page <= lastPage);

      return {
        "data": allItems,
        "meta": {
          "current_page": 1,
          "from": 1,
          "to": allItems.length,
          "last_page": 1,
          "per_page": allItems.length,
          "total": allItems.length,
        }
      };
    } catch (e) {
      print("fetchUnitLoanHistory Exception: $e");
      return null;
    }
  }

  /// LOGOUT METHOD
  static Future<Map<String, dynamic>?> logout({required String token}) async {
    final url = Uri.parse('https://4803a8d6f334.ngrok-free.app/api/logout');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json', // tambahkan Accept
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("logout ERROR: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("logout Exception: $e");
      return null;
    }
  }

  /// FETCH DETAIL UNIT LOAN BY ID
  static Future<Map<String, dynamic>?> fetchUnitLoanDetail(String id,
      {required String token}) async {
    final url =
        Uri.parse('https://4803a8d6f334.ngrok-free.app/api/unit-loan/$id');
    try {
      print('fetchUnitLoanDetail: token=$token, id=$id');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json', // tambahkan Accept
        },
      );
      print(
          'fetchUnitLoanDetail: status=${response.statusCode}, body=${response.body}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(
            "fetchUnitLoanDetail ERROR: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("fetchUnitLoanDetail Exception: $e");
      return null;
    }
  }

  /// FETCH DASHBOARD CARD DATA
  static Future<Map<String, dynamic>?> fetchDashboardCard(
      {required String token}) async {
    final url = Uri.parse(
        'https://4803a8d6f334.ngrok-free.app/api/dashboard/mobile/card');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      print(
          'fetchDashboardCard response.body: ${response.body}'); // <--- print body mentah
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(
            "fetchDashboardCard ERROR: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("fetchDashboardCard Exception: $e");
      return null;
    }
  }

  /// FETCH DASHBOARD LATEST ACTIVITY
  static Future<Map<String, dynamic>?> fetchDashboardLatestActivity(
      {required String token}) async {
    final url = Uri.parse(
        'https://4803a8d6f334.ngrok-free.app/api/dashboard/mobile/latest-activity');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      print(
          'fetchDashboardLatestActivity response.body: ${response.body}'); // <--- print body mentah
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(
            "fetchDashboardLatestActivity ERROR: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("fetchDashboardLatestActivity Exception: $e");
      return null;
    }
  }

  /// FETCH DASHBOARD LOAN REPORT (for chart)
  static Future<Map<String, dynamic>?> fetchLoanReport(
      {required String from, required String to, required String token}) async {
    final url = Uri.parse(
        'https://4803a8d6f334.ngrok-free.app/api/dashboard/loan-report?from=$from&to=$to');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      print(
          'fetchLoanReport response.body: ${response.body}'); // <--- print body mentah
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(
            "fetchLoanReport ERROR: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("fetchLoanReport Exception: $e");
      return null;
    }
  }

  /// FETCH PIE CHART DATA
  static Future<Map<String, dynamic>?> fetchPieChart(
      {required String token}) async {
    final url = Uri.parse(
        'https://4803a8d6f334.ngrok-free.app/api/dashboard/admin-user/most-borrowed-percentage');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      print('fetchPieChart response: ${response.body}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("fetchPieChart ERROR: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("fetchPieChart Exception: $e");
      return null;
    }
  }

  /// FETCH LEGEND DATA
  static Future<Map<String, dynamic>?> fetchLegend(
      {required String token}) async {
    final url = Uri.parse(
        'https://4803a8d6f334.ngrok-free.app/api/dashboard/admin-user/item-count');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      print('fetchLegend response: ${response.body}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("fetchLegend ERROR: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("fetchLegend Exception: $e");
      return null;
    }
  }

  /// FETCH USER DATA
  static Future<Map<String, dynamic>?> fetchUser(
      {required String token}) async {
    final url = Uri.parse('https://4803a8d6f334.ngrok-free.app/api/user');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      print(
          'fetchUser response.body: ${response.body}'); // <--- print body mentah
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("fetchUser ERROR: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("fetchUser Exception: $e");
      return null;
    }
  }
}
