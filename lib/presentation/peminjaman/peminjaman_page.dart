import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart'; // tambahkan import ini
import '../cek_item/models/cek_item_models.dart'; // gunakan model yang benar
import 'controller/peminjaman_controller.dart';
import 'models/peminjaman_models.dart';
import '../login/controller/login_controller.dart';
import '../../theme/app_button_custom.dart'; // tambahkan import ini
import '../../theme/succes_custome_page.dart'; // tambahkan import ini

class PeminjamanPage extends StatefulWidget {
  final UnitItem? unitItem;
  final int initialStep;
  final String token;
  final String borrowerType; // 'student' atau 'teacher'

  PeminjamanPage({
    Key? key,
    this.unitItem,
    this.initialStep = 0,
    required this.token,
    required this.borrowerType,
  }) : super(key: key);

  @override
  State<PeminjamanPage> createState() => _PeminjamanPageState();
}

class _PeminjamanPageState extends State<PeminjamanPage> {
  late final PeminjamanController controller;

  final nisController = TextEditingController();
  final nameController = TextEditingController();
  final rayonController = TextEditingController();
  final majorController = TextEditingController();
  final descriptionController = TextEditingController();
  final lenderController = TextEditingController();
  final dateController = TextEditingController();
  final roomController = TextEditingController();
  final purposeController = TextEditingController();

  String guarantee = 'kartu pelajar'; // default value sesuai permintaan
  bool isChecked = false;
  String? serverDate; // untuk format tanggal ke API

  @override
  void initState() {
    super.initState();
    // Pastikan controller sudah ada, jika belum, inisialisasi
    if (Get.isRegistered<PeminjamanController>()) {
      controller = Get.find<PeminjamanController>();
    } else {
      controller = Get.put(PeminjamanController());
    }
    if (widget.unitItem != null && controller.unitItem == null) {
      controller.unitItem = widget.unitItem;
    }
    if (controller.step.value == 0 && widget.initialStep != 0) {
      controller.step.value = widget.initialStep;
    }
    // Aktifkan kembali ever agar field otomatis update dari API
    ever(controller.student, (student) {
      if (widget.borrowerType == 'student' && student != null) {
        nameController.text = student.name ?? '';
        rayonController.text = student.rayon ?? '';
        majorController.text = student.major ?? '';
      }
    });
    ever(controller.teacher, (teacher) {
      if (widget.borrowerType == 'teacher' && teacher != null) {
        nameController.text = teacher.name ?? '';
        rayonController.text =
            teacher.telephone ?? ''; // <-- update nomor telepon
        majorController.text = '';
      }
    });
    controller.nameController = nameController;
    controller.rayonController = rayonController;
    controller.majorController = majorController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form Borrowing"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      // Hapus Obx di sini, langsung panggil StepperWidget
      body: StepperWidget(
        step: controller.step.value,
        onStepContinue: () => controller.nextStep(),
        onStepCancel: () => controller.prevStep(),
        child: _buildStepContent(context),
      ),
    );
  }

  Widget _buildStepContent(BuildContext context) {
    // Tidak perlu Obx di sini, karena sudah di atas
    switch (controller.step.value) {
      case 0:
        return _stepCheckItem();
      case 1:
        return _stepBorrowerInfo();
      case 2:
        return _stepCollateral(context);
      default:
        return SizedBox.shrink();
    }
  }

  Widget _stepCheckItem() {
    if (widget.unitItem == null) {
      return Center(child: Text("No item selected"));
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.unitItem!.subItem.merk,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 8),
              Text("Code: ${widget.unitItem!.codeUnit}"),
              Text("Description: ${widget.unitItem!.description}"),
              Text("Procurement Date: ${widget.unitItem!.procurementDate}"),
              Text("Status: ${widget.unitItem!.status}"),
              Text("Condition: ${widget.unitItem!.condition}"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepBorrowerInfo() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Row(
      children: [
        buildInputField(
          label: widget.borrowerType == 'teacher' ? "NIP" : "NIS",
          controller: nisController,
          inputType: widget.borrowerType == 'teacher'
              ? TextInputType.text
              : TextInputType.number,
          onChanged: (val) {
            if (widget.borrowerType == 'teacher') {
              controller.fetchTeacher(val, widget.token);
            } else {
              controller.fetchStudent(val, widget.token);
            }
          },
        ),
        const SizedBox(width: 12),
        buildInputField(
          label: "Name",
          controller: nameController,
          enabled: false,
        ),
      ],
    ),
    const SizedBox(height: 12),

    // Row kedua: Rayon/Telepon & Major/Room
    Row(
      children: [
        buildInputField(
          label: widget.borrowerType == 'teacher' ? "Nomor Telepon" : "Rayon",
          controller: rayonController,
          enabled: false,
        ),
        const SizedBox(width: 12),
        buildInputField(
          label: widget.borrowerType == 'teacher' ? "Room" : "Major",
          controller: widget.borrowerType == 'teacher'
              ? roomController
              : majorController,
          enabled: widget.borrowerType != 'teacher' ? false : true,
        ),
      ],
    ),

    // indikator loading & error message (logic tetap sama)
    Obx(() {
      if (controller.isLoading.value) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 8),
              const Text("Searching...", style: TextStyle(fontSize: 12)),
            ],
          ),
        );
      }
      if (widget.borrowerType == 'student' &&
          controller.student.value == null &&
          nisController.text.isNotEmpty) {
        return const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text("Student not found",
              style: TextStyle(color: Colors.red, fontSize: 12)),
        );
      }
      if (widget.borrowerType == 'teacher' &&
          controller.teacher.value == null &&
          nisController.text.isNotEmpty) {
        return const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text("Teacher not found",
              style: TextStyle(color: Colors.red, fontSize: 12)),
        );
      }
      return const SizedBox.shrink();
    }),

    const SizedBox(height: 16),
    const Text(
         "Warranty",
         style: TextStyle(
           fontSize: 13,
           fontWeight: FontWeight.w500,
           color: Colors.black87,
         ),
         textAlign: TextAlign.start,
       ),
       const SizedBox(height: 6),
            // Warranty & Upload hanya untuk student
            if (widget.borrowerType == 'student') ...[
              Row(
        children: [
          
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => guarantee = 'BKP'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: guarantee == 'BKP'
                        ? const Color(0xFF023A8F)
                        : Colors.grey.shade300,
                    width: 1.5,
                  ),
                  color: guarantee == 'BKP'
                      ? const Color(0xFF023A8F).withOpacity(0.05)
                      : Colors.white,
                ),
                child: Row(
                  children: [
                    Icon(
                      guarantee == 'BKP'
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: guarantee == 'BKP'
                          ? const Color(0xFF023A8F)
                          : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "BKP",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => guarantee = 'kartu pelajar'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: guarantee == 'kartu pelajar'
                        ? const Color(0xFF023A8F)
                        : Colors.grey.shade300,
                    width: 1.5,
                  ),
                  color: guarantee == 'kartu pelajar'
                      ? const Color(0xFF023A8F).withOpacity(0.05)
                      : Colors.white,
                ),
                child: Row(
                  children: [
                    Icon(
                      guarantee == 'kartu pelajar'
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: guarantee == 'kartu pelajar'
                          ? const Color(0xFF023A8F)
                          : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Student Card",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Upload Warranty",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 8),
              Obx(() => controller.imagePath.value.isEmpty
                  ? GestureDetector(
                      onTap: () => controller.pickImage(),
                      child: Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[100],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_outlined,
                                size: 32, color: Colors.grey),
                            SizedBox(height: 8),
                            Text.rich(
                              TextSpan(
                                text: "Click ",
                                children: [
                                  TextSpan(
                                    text: "here",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(text: " to take a photo"),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(controller.imagePath.value),
                            width: double.infinity,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                            icon: Icon(Icons.close, color: Colors.red),
                            onPressed: () => controller.imagePath.value = '',
                          ),
                        ),
                      ],
                    )),
              SizedBox(height: 16),
            ],
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: "Description",
                hintText: "Pinjam Laptop untuk Mapel Prod",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              ),
              maxLines: 2,
            ),
            SizedBox(height: 16),
            // Lender's Name & Room (student)
            if (widget.borrowerType == 'student') ...[
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: lenderController,
                      decoration: InputDecoration(
                        labelText: "Lender's Name",
                        hintText: "Nama peminjam",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: TextFormField(
                      controller: roomController,
                      decoration: InputDecoration(
                        labelText: "Room",
                        hintText: "Room",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
            // Lender's Name (teacher)
            if (widget.borrowerType == 'teacher') ...[
              TextFormField(
                controller: lenderController,
                decoration: InputDecoration(
                  labelText: "Lender's Name",
                  hintText: "Nama peminjam",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                ),
              ),
              SizedBox(height: 16),
            ],
            TextFormField(
              controller: dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Date - Pick Up Time",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: Icon(Icons.calendar_today),
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              ),
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2030),
                );
                if (picked != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: 8, minute: 0),
                  );
                  if (time != null) {
                    final dt = DateTime(
                      picked.year,
                      picked.month,
                      picked.day,
                      time.hour,
                      time.minute,
                    );
                    // Untuk user (display)
                    dateController.text =
                        "${dt.day} ${_monthName(dt.month)} ${dt.year} - ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
                    // Untuk API (server format)
                    serverDate =
                        "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:00";
                  }
                }
              },
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  activeColor: Colors.blue,
                  checkColor: Colors.white,
                  onChanged: (val) {
                    setState(() {
                      isChecked = val ?? false;
                    });
                  },
                ),
                Flexible(
                    child: Text("Make sure the data is correct",
                        overflow: TextOverflow.ellipsis)),
              ],
            ),
            SizedBox(height: 16),
            Builder(
              builder: (context) {
                final isFilled = descriptionController.text.isNotEmpty &&
                    lenderController.text.isNotEmpty &&
                    dateController.text.isNotEmpty &&
                    isChecked &&
                    (widget.borrowerType == 'teacher'
                        ? roomController.text.isNotEmpty
                        : roomController
                            .text.isNotEmpty); // student juga wajib isi room
                return SizedBox(
                  width: double.infinity,
                  child: AppButtonCustom(
                    label: "Submit",
                    color: isFilled ? Colors.blue : Colors.grey,
                    onPressed: isFilled
                        ? () async {
                            String? imagePathCompressed;
                            if (widget.borrowerType == 'student' &&
                                controller.imagePath.value.isNotEmpty) {
                              final compressedFile =
                                  await FlutterImageCompress.compressAndGetFile(
                                controller.imagePath.value,
                                controller.imagePath.value + "_compressed.jpg",
                                quality: 75,
                                minWidth: 800,
                                minHeight: 800,
                              );
                              imagePathCompressed = compressedFile?.path;
                            }
                            final req = LoanRequest(
                              studentId: widget.borrowerType == 'student'
                                  ? controller.student.value?.id
                                  : null,
                              teacherId: widget.borrowerType == 'teacher'
                                  ? controller.teacher.value?.id
                                  : null,
                              unitItemId: widget.unitItem?.id ?? "",
                              borrowedBy: lenderController.text,
                              borrowedAt: serverDate ?? '',
                              purpose: descriptionController.text,
                              room: int.tryParse(roomController.text) ?? 0,
                              imagePath: imagePathCompressed,
                              guarantee: widget.borrowerType == 'student'
                                  ? guarantee
                                  : '',
                            );
                            // Pastikan hanya satu id yang dikirim
                            final map = req.toMap();
                            if (widget.borrowerType == 'student') {
                              map.remove('teacher_id');
                            } else if (widget.borrowerType == 'teacher') {
                              map.remove('student_id');
                            }
                            final result =
                                await controller.submitLoan(req, widget.token);
                            if (result != null && result['status'] == 200) {
                              Get.snackbar(
                                  "Success", "Loan submitted successfully");
                              // Buat data struk dari input dan unitItem
                              final receiptData = {
                                'date': dateController.text.split(' - ').first,
                                'time':
                                    dateController.text.split(' - ').length > 1
                                        ? dateController.text.split(' - ')[1]
                                        : "-",
                                'nis': widget.borrowerType == 'student'
                                    ? nisController.text
                                    : null,
                                'nip': widget.borrowerType == 'teacher'
                                    ? nisController.text
                                    : null,
                                'name': nameController.text,
                                'major': widget.borrowerType == 'student'
                                    ? majorController.text
                                    : null,
                                'room': roomController
                                    .text, // <-- selalu kirim room
                                'telephone': widget.borrowerType == 'teacher'
                                    ? rayonController.text
                                    : null,
                                'description': descriptionController.text,
                                'warranty': widget.borrowerType == 'student'
                                    ? guarantee
                                    : null,
                                'unitCode': widget.unitItem?.codeUnit,
                                'merk': widget.unitItem?.subItem.merk,
                                'author': "Iqbal Fajar Syahbana",
                              };
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SuccessCustomPage(
                                    receiptData: receiptData,
                                  ),
                                ),
                              );
                            } else {
                              // Tampilkan pesan error backend ke user
                              Get.snackbar(
                                  "Error",
                                  result?['message'] ??
                                      "Failed to submit loan");
                            }
                          }
                        : null,
                    loading: false,
                    borderRadius: 8,
                  ),
                );
              },
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget buildInputField({
  required String label,
  required TextEditingController controller,
  bool enabled = true,
  TextInputType inputType = TextInputType.text,
  Function(String)? onChanged,
}) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: inputType,
          onChanged: onChanged,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey.shade200,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF023A8F), width: 1.5),
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _stepCollateral(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Select Guarantee",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          guarantee == 'BKP' ? Colors.blue : Colors.white,
                      foregroundColor:
                          guarantee == 'BKP' ? Colors.white : Colors.black,
                      side: BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      setState(() {
                        guarantee = 'BKP';
                      });
                    },
                    child: Text("BKP"),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: guarantee == 'kartu pelajar'
                          ? Colors.blue
                          : Colors.white,
                      foregroundColor: guarantee == 'kartu pelajar'
                          ? Colors.white
                          : Colors.black,
                      side: BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      setState(() {
                        guarantee = 'kartu pelajar';
                      });
                    },
                    child: Text("Kartu Pelajar"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text("Upload Warranty",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            // Hanya bagian gambar yang pakai Obx
            Obx(() => controller.imagePath.value.isEmpty
                ? GestureDetector(
                    onTap: () => controller.pickImage(),
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[100],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 32, color: Colors.grey),
                          SizedBox(height: 8),
                          Text.rich(
                            TextSpan(
                              text: "Click ",
                              children: [
                                TextSpan(
                                  text: "here",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                TextSpan(text: " to take a photo"),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(controller.imagePath.value),
                          width: double.infinity,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () => controller.imagePath.value = '',
                        ),
                      ),
                    ],
                  )),
            SizedBox(height: 16),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: "Description",
                hintText: "Pinjam Laptop untuk Mapel Prod",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              ),
              maxLines: 2,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: lenderController,
              decoration: InputDecoration(
                labelText: "Lender's Name",
                hintText: "Nama peminjam",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Date - Pick Up Time",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: Icon(Icons.calendar_today),
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              ),
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2030),
                );
                if (picked != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: 8, minute: 0),
                  );
                  if (time != null) {
                    final dt = DateTime(
                      picked.year,
                      picked.month,
                      picked.day,
                      time.hour,
                      time.minute,
                    );
                    dateController.text =
                        "${dt.day} ${_monthName(dt.month)} ${dt.year} - ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
                    serverDate =
                        "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:00";
                  }
                }
              },
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (val) {
                    setState(() {
                      isChecked = val ?? false;
                    });
                  },
                ),
                Flexible(
                    child: Text("Make sure the data is correct",
                        overflow: TextOverflow.ellipsis)),
              ],
            ),
            SizedBox(height: 16),
            // Ubah validasi isFilled agar imagePath opsional
            Builder(
              builder: (context) {
                final isFilled = descriptionController.text.isNotEmpty &&
                    lenderController.text.isNotEmpty &&
                    dateController.text.isNotEmpty &&
                    isChecked;
                return SizedBox(
                  width: double.infinity,
                  child: AppButtonCustom(
                    label: "Submit",
                    color: isFilled ? Colors.blue : Colors.grey,
                    onPressed: isFilled
                        ? () async {
                            String? imagePathCompressed;
                            if (controller.imagePath.value.isNotEmpty) {
                              final compressedFile =
                                  await FlutterImageCompress.compressAndGetFile(
                                controller.imagePath.value,
                                controller.imagePath.value + "_compressed.jpg",
                                quality: 75,
                                minWidth: 800,
                                minHeight: 800,
                              );
                              imagePathCompressed = compressedFile?.path;
                            }
                            final req = LoanRequest(
                              studentId: widget.borrowerType == 'student'
                                  ? controller.student.value?.id
                                  : null,
                              teacherId: widget.borrowerType == 'teacher'
                                  ? controller.teacher.value?.id
                                  : null,
                              unitItemId: widget.unitItem?.id ?? "",
                              borrowedBy: lenderController.text,
                              borrowedAt: serverDate ?? '',
                              purpose: descriptionController.text,
                              room: 0,
                              imagePath: imagePathCompressed,
                              guarantee: guarantee,
                            );
                            final result =
                                await controller.submitLoan(req, widget.token);
                            if (result != null && result['status'] == 200) {
                              Get.snackbar(
                                  "Success", "Loan submitted successfully");
                              // Buat data struk dari input dan unitItem
                              final receiptData = {
                                'date': dateController.text.split(' - ').first,
                                'time':
                                    dateController.text.split(' - ').length > 1
                                        ? dateController.text.split(' - ')[1]
                                        : "-",
                                'nis': widget.borrowerType == 'student'
                                    ? nisController.text
                                    : null,
                                'name': nameController.text,
                                'major': majorController.text,
                                'description': descriptionController.text,
                                'room': roomController.text.isNotEmpty
                                    ? roomController.text
                                    : null,
                                'warranty': guarantee,
                                'unitCode': widget.unitItem?.codeUnit,
                                'merk': widget.unitItem?.subItem.merk,
                                'author': "Iqbal Fajar Syahbana",
                              };
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SuccessCustomPage(
                                    receiptData: receiptData,
                                  ),
                                ),
                              );
                            } else {
                              // Tampilkan pesan error backend ke user
                              Get.snackbar(
                                  "Error",
                                  result?['message'] ??
                                      "Failed to submit loan");
                            }
                          }
                        : null,
                    loading: false,
                    borderRadius: 8,
                  ),
                );
              },
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month];
  }
}

class StepperWidget extends StatelessWidget {
  final int step;
  final VoidCallback onStepContinue;
  final VoidCallback onStepCancel;
  final Widget child;

  const StepperWidget({
    required this.step,
    required this.onStepContinue,
    required this.onStepCancel,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Row(
            children: [
              _stepCircle(Icons.check, true),
              _stepLine(),
              _stepCircle(Icons.check, true),
              _stepLine(),
              _stepCircle(Icons.check, false, number: "3"),
            ],
          ),
        ),
        SizedBox(height: 4),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  width: 60,
                  child: Text("Check Item",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12))),
              SizedBox(
                  width: 80,
                  child: Text("Borrower Info",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12))),
              SizedBox(
                  width: 60,
                  child: Text("Collateral",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12))),
            ],
          ),
        ),
        SizedBox(height: 20),

        // ✅ child ikut jadi bagian scroll
        child,
      ],
    );
  }

  Widget _stepCircle(IconData icon, bool active, {String? number}) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: active ? Colors.green : Colors.blue,
      child: active
          ? Icon(
              icon,
              color: Colors.white,
              size: 18,
            )
          : Text(
              number ?? "",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }

  Widget _stepLine() {
    return Expanded(
      child: Container(
        height: 2,
        color: Colors.grey[300],
      ),
    );
  }
}
