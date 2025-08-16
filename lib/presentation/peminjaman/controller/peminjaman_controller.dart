import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import '../../../core/api/app_api.dart';
import '../models/peminjaman_models.dart';
import '../../cek_item/models/cek_item_models.dart'; // ganti import ini untuk UnitItem

class PeminjamanController extends GetxController {
  var step = 0.obs;
  var isLoading = false.obs;
  var student = Rxn<Student>();
  var teacher = Rxn<Teacher>();
  var imagePath = ''.obs;
  final picker = ImagePicker();
  UnitItem? unitItem; // pastikan UnitItem sudah terdefinisi dan diimport dari cek_item_models.dart

  TextEditingController? nameController;
  TextEditingController? rayonController;
  TextEditingController? majorController;

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      imagePath.value = picked.path;
    }
  }

  Future<void> fetchStudent(String id, String token) async {
    isLoading.value = true;
    final data = await AppApi.fetchPerson(id, type: 'student', token: token);
    print('fetchStudent response: $data'); // log seluruh respons
    if (data != null) {
      print('fetchStudent status: ${data['status']}'); // log status
    }
    if (data != null && data['data'] is List && data['data'].isNotEmpty) {
      final studentJson = data['data'][0];
      // Ambil major dari nested major object jika ada
      student.value = Student(
        id: studentJson['id'],
        nis: studentJson['nis'].toString(),
        name: studentJson['name'] ?? '',
        rayon: studentJson['rayon'] ?? '',
        major: studentJson['major'] is Map
            ? studentJson['major']['name'] ?? ''
            : (studentJson['major'] ?? ''),
      );
      // Set ke controller jika sudah di-assign dari page
      nameController?.text = student.value?.name ?? '';
      rayonController?.text = student.value?.rayon ?? '';
      majorController?.text = student.value?.major ?? '';
      print('Student found: ${studentJson['name']} / ${studentJson['nis']} / ${studentJson['major']}');
    } else {
      print('Student not found or empty data');
    }
    isLoading.value = false;
  }

  Future<void> fetchTeacher(String id, String token) async {
    isLoading.value = true;
    final data = await AppApi.fetchPerson(id, type: 'teacher', token: token);
    print('fetchTeacher response: $data'); // log seluruh respons
    if (data != null) {
      print('fetchTeacher status: ${data['status']}'); // log status
    }
    if (data != null && data['data'] is List && data['data'].isNotEmpty) {
      final teacherJson = data['data'][0];
      teacher.value = Teacher(
        id: teacherJson['id'],
        name: teacherJson['name'] ?? '',
      );
      nameController?.text = teacher.value?.name ?? '';
      rayonController?.text = '';
      majorController?.text = '';
      print('Teacher found: ${teacherJson['name']} / ${teacherJson['id']}');
    } else {
      print('Teacher not found or empty data');
    }
    isLoading.value = false;
  }

  Future<Map<String, dynamic>?> submitLoan(LoanRequest req, String token) async {
    isLoading.value = true;
    // Ensure unit_item_id is the UUID from 
    if (unitItem != null) {
      req.unitItemId = unitItem!.id;
    }
    final result = await AppApi.postUnitLoan(req.toMap(), token: token);
    isLoading.value = false;
    return result;
  }

  Future<Map<String, dynamic>?> returnLoan(String loanId, String returnedAt, String token) async {
    isLoading.value = true;
    final result = await AppApi.returnUnitLoan(loanId, returnedAt, token: token);
    isLoading.value = false;
    return result;
  }

  void nextStep() {
    if (step.value < 2) step.value++;
  }

  void prevStep() {
    if (step.value > 0) step.value--;
  }
}

