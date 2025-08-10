import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      imagePath.value = picked.path;
    }
  }

  Future<void> fetchStudent(String id, String token) async {
    isLoading.value = true;
    final data = await AppApi.fetchPerson(id, type: 'student', token: token);
    if (data != null) {
      student.value = Student.fromJson(data['data']);
    }
    isLoading.value = false;
  }

  Future<void> fetchTeacher(String id, String token) async {
    isLoading.value = true;
    final data = await AppApi.fetchPerson(id, type: 'teacher', token: token);
    if (data != null) {
      teacher.value = Teacher.fromJson(data['data']);
    }
    isLoading.value = false;
  }

  Future<Map<String, dynamic>?> submitLoan(LoanRequest req, String token) async {
    isLoading.value = true;
    // Ensure unit_item_id is the UUID from UnitItem
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

