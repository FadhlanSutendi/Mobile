import 'package:flutter/material.dart';
import '../../../core/api/app_api.dart';
import '../models/detail_history_models.dart';

class DetailHistoryController extends ChangeNotifier {
  final String id;
  final String token;

  DetailHistoryModel? detail;
  bool isLoading = false;

  DetailHistoryController({required this.id, required this.token});

  Future<void> fetchDetail() async {
    isLoading = true;
    notifyListeners();
    final res = await AppApi.fetchUnitLoanDetail(id, token: token);
    print('DetailHistoryController fetchDetail: $res'); // log response
    if (res != null && res['status'] == 200 && res['data'] != null) {
      detail = DetailHistoryModel.fromJson(res['data']);
    }
    isLoading = false;
    notifyListeners();
  }
}
