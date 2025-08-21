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

  // Add borrowerType to determine if the borrower is a student or teacher
  String borrowerType = 'student'; // default, set from page

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      imagePath.value = picked.path;
    }
  }

  Future<void> fetchStudent(String id, String token) async {
    isLoading.value = true;
    print('Searching for: $id (Type: student)');
    final data = await AppApi.fetchPerson(id, type: 'student', token: token);
    print('API Response: $data'); // Debug respons

    if (data != null && data['data'] is List) {
      if (data['data'].isNotEmpty) {
        final studentData = data['data'][0];
        student.value = Student.fromJson(studentData);
        print('Student loaded: ${student.value?.name}');
        // Tidak mengisi name/rayon/major ke controller, user isi manual
      } else {
        print('No student found with NIS/name: $id');
        student.value = null;
      }
    } else {
      print('Invalid API response format');
      student.value = null;
    }
    isLoading.value = false;
  }

  Future<void> fetchTeacher(String id, String token) async {
    isLoading.value = true;
    print('Searching for: $id (Type: teacher)');
    final data = await AppApi.fetchPerson(id, type: 'teacher', token: token);
    print('API Response: $data'); // Debug respons

    if (data != null && data['data'] is List) {
      if (data['data'].isNotEmpty) {
        final teacherData = data['data'][0];
        teacher.value = Teacher.fromJson(teacherData);
        print('Teacher loaded: ${teacher.value?.name}');
        // Tidak mengisi name/rayon/major ke controller, user isi manual
      } else {
        print('No teacher found with NIP/name: $id');
        teacher.value = null;
      }
    } else {
      print('Invalid API response format');
      teacher.value = null;
    }
    isLoading.value = false;
  }

  Future<Map<String, dynamic>?> submitLoan(LoanRequest req, String token) async {
    isLoading.value = true;
    // req.unitItemId sudah di-set dari page
    // Map sudah diolah di page, langsung kirim
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