import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../cek_item/models/cek_item_models.dart'; // gunakan model yang benar
import 'controller/peminjaman_controller.dart';
import 'models/peminjaman_models.dart';
import '../login/controller/login_controller.dart';

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
  final controller = Get.put(PeminjamanController());

  final nisController = TextEditingController();
  final nameController = TextEditingController();
  final rayonController = TextEditingController();
  final majorController = TextEditingController();
  final descriptionController = TextEditingController();
  final lenderController = TextEditingController();
  final dateController = TextEditingController();
  final roomController = TextEditingController();
  final purposeController = TextEditingController();

  String guarantee = 'STUDENT CARD';
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    if (widget.unitItem != null && controller.unitItem == null) {
      controller.unitItem = widget.unitItem;
    }
    if (controller.step.value == 0 && widget.initialStep != 0) {
      controller.step.value = widget.initialStep;
    }
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
      body: StepperWidget(
        step: controller.step.value,
        onStepContinue: () => controller.nextStep(),
        onStepCancel: () => controller.prevStep(),
        child: _buildStepContent(context),
      ),
    );
  }

  Widget _buildStepContent(BuildContext context) {
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
    // Tampilkan data unit item yang dikirim dari cek item
    if (widget.unitItem == null) {
      return Center(child: Text("No item selected"));
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: ListTile(
          title: Text(widget.unitItem!.subItem.merk),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
    return Column(
      children: [
        TextFormField(
          controller: nisController,
          keyboardType: widget.borrowerType == 'student'
              ? TextInputType.number
              : TextInputType.text,
          decoration: InputDecoration(
            labelText: widget.borrowerType == 'student' ? "NIS" : "NIP",
            hintText: widget.borrowerType == 'student'
                ? "Masukkan NIS siswa"
                : "Masukkan NIP guru",
          ),
          onChanged: (val) {
            if (widget.borrowerType == 'student') {
              controller.fetchStudent(val, widget.token);
            } else {
              controller.fetchTeacher(val, widget.token);
            }
          },
          onFieldSubmitted: (val) {
            if (val.isNotEmpty) {
              if (widget.borrowerType == 'student') {
                controller.fetchStudent(val, widget.token);
              } else {
                controller.fetchTeacher(val, widget.token);
              }
            }
          },
        ),
        SizedBox(height: 8),
        if (widget.borrowerType == 'teacher')
          Obx(() => Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "NIP: ${controller.teacher.value?.id ?? ''}",
              style: TextStyle(fontSize: 16),
            ),
          )),
        Obx(() => Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Name: ${widget.borrowerType == 'student'
                ? controller.student.value?.name ?? ''
                : controller.teacher.value?.name ?? ''}",
            style: TextStyle(fontSize: 16),
          ),
        )),
        if (widget.borrowerType == 'student')
          Obx(() => Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Rayon: ${controller.student.value?.rayon ?? ''}",
              style: TextStyle(fontSize: 16),
            ),
          )),
        if (widget.borrowerType == 'student')
          Obx(() => Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Major: ${controller.student.value?.major ?? ''}",
              style: TextStyle(fontSize: 16),
            ),
          )),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => controller.nextStep(),
          child: Text("Next"),
        ),
      ],
    );
  }

  Widget _stepCollateral(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Warranty Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: guarantee == 'BKP' ? Colors.blue : Colors.white,
                    foregroundColor: guarantee == 'BKP' ? Colors.white : Colors.black,
                    side: BorderSide(color: Colors.blue),
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
                    backgroundColor: guarantee == 'STUDENT CARD' ? Colors.blue : Colors.white,
                    foregroundColor: guarantee == 'STUDENT CARD' ? Colors.white : Colors.black,
                    side: BorderSide(color: Colors.blue),
                  ),
                  onPressed: () {
                    setState(() {
                      guarantee = 'STUDENT CARD';
                    });
                  },
                  child: Text("STUDENT CARD"),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          // Upload Warranty
          Text("Upload Warranty", style: TextStyle(fontWeight: FontWeight.bold)),
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
                        ),
                      ],
                    ),
                  ),
                )
              : Stack(
                  children: [
                    Image.file(
                      File(controller.imagePath.value),
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => controller.imagePath.value = '',
                      ),
                    ),
                  ],
                )),
          SizedBox(height: 16),
          // Description
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: "Description",
              hintText: "Pinjam Laptop untuk Mapel Prod",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          SizedBox(height: 16),
          // Lender's Name
          TextFormField(
            controller: lenderController,
            decoration: InputDecoration(
              labelText: "Lender's Name",
              hintText: "Nama peminjam",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          SizedBox(height: 16),
          // Date - Pick Up Time
          TextFormField(
            controller: dateController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Date - Pick Up Time",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              prefixIcon: Icon(Icons.calendar_today),
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
                      "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:00";
                }
              }
            },
          ),
          SizedBox(height: 16),
          // Checkbox
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
              Text("Make sure the data is correct"),
            ],
          ),
          SizedBox(height: 16),
          // Submit Button
          Obx(() {
            final isFilled = descriptionController.text.isNotEmpty &&
                lenderController.text.isNotEmpty &&
                dateController.text.isNotEmpty &&
                controller.imagePath.value.isNotEmpty &&
                isChecked;
            return SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFilled ? Colors.blue : Colors.grey,
                  foregroundColor: Colors.white,
                ),
                onPressed: isFilled
                    ? () async {
                        final req = LoanRequest(
                          studentId: widget.borrowerType == 'student'
                              ? controller.student.value?.id
                              : null,
                          teacherId: widget.borrowerType == 'teacher'
                              ? controller.teacher.value?.id
                              : null,
                          unitItemId: widget.unitItem?.id ?? "",
                          borrowedBy: lenderController.text,
                          borrowedAt: dateController.text,
                          purpose: descriptionController.text,
                          room: 0, // room tidak ada di UI, set default 0
                          imagePath: controller.imagePath.value,
                          guarantee: guarantee,
                        );
                        final result = await controller.submitLoan(req, widget.token);
                        if (result != null && result['status'] == 200) {
                          Get.snackbar("Success", "Loan submitted successfully");
                          Navigator.pop(context);
                        } else {
                          Get.snackbar("Error", "Failed to submit loan");
                        }
                      }
                    : null,
                child: Text("Submit"),
              ),
            );
          }),
        ],
      ),
    );
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
    return Column(
      children: [
        Row(
          children: [
            _stepCircle(1, step >= 0),
            _stepLine(),
            _stepCircle(2, step >= 1),
            _stepLine(),
            _stepCircle(3, step >= 2),
          ],
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 60, child: Text("Check Item", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
            SizedBox(width: 80, child: Text("Borrower Info", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
            SizedBox(width: 60, child: Text("Collateral", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          ],
        ),
        SizedBox(height: 24),
        Expanded(child: child),
      ],
    );
  }

  Widget _stepCircle(int number, bool active) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: active ? Colors.blue : Colors.grey[300],
      child: Text(
        "$number",
        style: TextStyle(
          color: active ? Colors.white : Colors.black,
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