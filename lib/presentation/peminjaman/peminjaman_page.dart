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
          mainAxisSize: MainAxisSize.min,
          children: [
            // NIS/NIP input, trigger fetchStudent/fetchTeacher on change
            TextFormField(
              controller: nisController,
              keyboardType: widget.borrowerType == 'teacher'
                  ? TextInputType.text
                  : TextInputType.number,
              decoration: InputDecoration(
                labelText: widget.borrowerType == 'teacher' ? "NIP" : "NIS",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              ),
              onChanged: (val) {
                if (widget.borrowerType == 'teacher') {
                  controller.fetchTeacher(val, widget.token);
                } else {
                  controller.fetchStudent(val, widget.token);
                }
              },
            ),
            SizedBox(height: 12),
            // Nama otomatis terisi jika student/teacher ditemukan
            TextFormField(
              enabled: false,
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Name",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              ),
            ),
            SizedBox(height: 8),
            // Rayon/Telepon
            widget.borrowerType == 'teacher'
                ? TextFormField(
                    enabled: false,
                    controller: rayonController,
                    decoration: InputDecoration(
                      labelText: "Nomor Telepon",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    ),
                  )
                : TextFormField(
                    enabled: false,
                    controller: rayonController,
                    decoration: InputDecoration(
                      labelText: "Rayon",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    ),
                  ),
            SizedBox(height: 8),
            // Major/Room
            widget.borrowerType == 'teacher'
                ? TextFormField(
                    controller: roomController,
                    decoration: InputDecoration(
                      labelText: "Room",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    ),
                  )
                : TextFormField(
                    enabled: false,
                    controller: majorController,
                    decoration: InputDecoration(
                      labelText: "Major",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    ),
                  ),
            // Tambahkan indikator loading dan pesan error
            Obx(() {
              if (controller.isLoading.value) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text("Searching...", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                );
              }
              if (widget.borrowerType == 'student' &&
                  controller.student.value == null &&
                  nisController.text.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text("Student not found",
                      style: TextStyle(color: Colors.red, fontSize: 12)),
                );
              }
              if (widget.borrowerType == 'teacher' &&
                  controller.teacher.value == null &&
                  nisController.text.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text("Teacher not found",
                      style: TextStyle(color: Colors.red, fontSize: 12)),
                );
              }
              return SizedBox.shrink();
            }),
            SizedBox(height: 16),
            // Warranty & Upload hanya untuk student
            if (widget.borrowerType == 'student') ...[
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      value: 'BKP',
                      groupValue: guarantee,
                      contentPadding: EdgeInsets.zero,
                      activeColor: Colors.blue,
                      title: Text('BKP', style: TextStyle(fontSize: 14)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      onChanged: (val) {
                        setState(() {
                          guarantee = val!;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: RadioListTile<String>(
                      value: 'kartu pelajar',
                      groupValue: guarantee,
                      contentPadding: EdgeInsets.zero,
                      activeColor: Colors.blue,
                      title:
                          Text('Kartu Pelajar', style: TextStyle(fontSize: 14)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      onChanged: (val) {
                        setState(() {
                          guarantee = val!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
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
                            Icon(Icons.camera_alt,
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
