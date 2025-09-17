import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project_prapw/presentation/login/controller/login_controller.dart';
import '../../../core/api/app_api.dart';
import '../models/history_models.dart';

class HistoryController extends ChangeNotifier {
  List<HistoryItem> items = [];
  bool isLoading = false;
  final loginController = Get.find<LoginController>();
  String selectedCategory = 'All';
  final String token; // token wajib diisi lewat konstruktor

  HistoryController({required this.token});

  final List<String> categories = [
    'All',
    'Laptop',
    'Mouse',
    'Keyboard',
    'Monitor',
    'Earphone',
    'Other'
  ];

  List<String> dynamicCategories = ['All'];

  Future<void> fetchCategories() async {
    try {
      final fetched = await AppApi.fetchItemCategories(token: token);
      if (fetched.isNotEmpty) {
        dynamicCategories = ['All', ...fetched];
      } else {
        // Fallback ke kategori default jika API tidak mengembalikan data
        dynamicCategories = ['All', 'Laptop', 'Mouse', 'Keyboard', 'Monitor', 'Printer', 'Speaker', 'Komputer'];
      }
      notifyListeners();
    } catch (e) {
      print("Error fetching categories: $e");
      dynamicCategories = ['All', 'Laptop', 'Mouse', 'Keyboard', 'Monitor', 'Printer', 'Speaker', 'Komputer'];
      notifyListeners();
    }
  }

  Future<void> refreshHistory() async {
    await fetchCategories();
    await fetchHistory();
  }

  Future<void> fetchHistory({
    String data = 'borrowing',
    String sortByType = 'desc',
    String sortByTime = 'asc',
    String search = '',
  }) async {
    isLoading = true;
    notifyListeners();
    final result = await AppApi.fetchUnitLoanHistory(
      token: loginController.token.value,
      data: data,
      sortByType: sortByType,
      sortByTime: sortByTime,
      search: search,
    );
    items = [];
    if (result != null && result['data'] != null) {
      items = List<HistoryItem>.from(
          result['data'].map((x) => HistoryItem.fromJson(x)));
      print('History fetched: ${items.length} items'); // log ke terminal
    } else {
      print('No history data fetched'); // log ke terminal
    }
    // Filter kategori yang ada datanya
    await fetchCategories();
    isLoading = false;
    notifyListeners();
  }

  List<String> get availableCategories {
    // Ambil kategori dari API, tapi hanya tampilkan jika ada item di kategori tsb (case-insensitive)
    final Set<String> itemTypes = items.map((e) => e.itemType.toLowerCase()).toSet();
    return dynamicCategories.where((cat) =>
      cat == 'All' || itemTypes.contains(cat.toLowerCase())
    ).toList();
  }

  List<HistoryItem> get filteredItems {
    if (selectedCategory == 'All') return items;
    return items
        .where((item) =>
            item.itemType.toLowerCase() == selectedCategory.toLowerCase())
        .toList();
  }

  void setCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }
}