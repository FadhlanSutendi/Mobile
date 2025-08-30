import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_prapw/core/api/app_api.dart';
import 'package:project_prapw/theme/succespengembalian_custome_page.dart';
import 'dart:io';
import 'controller/pengembalian_controller.dart';
// gunakan alias untuk model
import 'models/pengembalian_models.dart' as pengembalian;
import '../../theme/succes_custome_page.dart';

class PengembalianPage extends StatefulWidget {
  final pengembalian.UnitLoan loan;
  final pengembalian.UnitItem
      unitItem; // Use UnitItem from pengembalian_models.dart
  final String token;

  PengembalianPage({
    Key? key,
    required this.loan,
    required this.unitItem,
    required this.token,
  }) : super(key: key);

  @override
  State<PengembalianPage> createState() => _PengembalianPageState();
}

class _PengembalianPageState extends State<PengembalianPage> {
  late final PengembalianController controller;
  final descriptionController = TextEditingController();
  final lenderController = TextEditingController();
  final pickUpController = TextEditingController();
  final returnController = TextEditingController();
  String? guarantee;

  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    controller = Get.put(PengembalianController());
    descriptionController.text = widget.loan.purpose;
    lenderController.text = widget.loan.borrowedBy;
    pickUpController.text = _formatDateTime(widget.loan.borrowedAt);
    returnController.text = _formatDateTime(DateTime.now().toString());
    guarantee = widget.loan.guarantee;
  }

  String _formatDateTime(String dt) {
    // dt: "2024-06-10 08:00:00"
    try {
      final date = DateTime.parse(dt.replaceAll(' ', 'T'));
      return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} ${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    } catch (_) {
      return dt;
    }
  }

  String safeString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final student = widget.loan.student;
    final teacher = widget.loan.teacher;
    return Scaffold(
      appBar: AppBar(
        title: Text("Return"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16),
            // Stepper
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Row(
                children: [
                  _stepCircle(1,
                      isCheck: true,
                      color: const Color(0xFF099B46)), // ✅ hijau ceklis
                  const SizedBox(width: 5),
                  _stepLine(const Color.fromARGB(255, 0, 0, 0)),
                  const SizedBox(width: 5),
                  _stepCircle(1,
                      isCheck: true,
                      color: const Color(0xFF099B46)), // 🔵 biru angka 2
                  const SizedBox(width: 5),
                  _stepLine(const Color.fromARGB(255, 0, 0, 0)),
                  const SizedBox(width: 5),
                  _stepCircle(3,
                      isCheck: false,
                      color: Color(0xFF023A8F)), // ⚪ abu angka 3
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
                    child: Text(
                      "Check Item",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                      maxLines:
                          2, // otomatis kebagi dua baris kalau kepanjangan
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: Text(
                      "Borrower Info",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: Text(
                      "Collateral",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tampilkan data student jika ada
                    if (student != null) ...[
                      Row(
                        children: [
                          buildReadonlyField(
                              label: "NIS", value: safeString(student['nis'])),
                          const SizedBox(width: 8),
                          buildReadonlyField(
                              label: "Name",
                              value: safeString(student['name'])),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          buildReadonlyField(
                              label: "Rayon",
                              value: safeString(student['rayon'])),
                          const SizedBox(width: 8),
                          buildReadonlyField(
                              label: "Major",
                              value: safeString(student['major'])),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          buildReadonlyField(
                              label: "Room",
                              value: safeString(widget.loan.room)),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],

                    if (teacher != null) ...[
                      Row(
                        children: [
                          buildReadonlyField(
                              label: "NIP", value: safeString(teacher['nip'])),
                          const SizedBox(width: 8),
                          buildReadonlyField(
                              label: "Name",
                              value: safeString(teacher['name'])),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          buildReadonlyField(
                              label: "Nomor Telepon",
                              value: safeString(teacher['telephone'])),
                          const SizedBox(width: 8),
                          buildReadonlyField(
                              label: "Room",
                              value: safeString(widget.loan.room)),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                    const Text(
                      "Warranty",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => guarantee = 'BKP'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: widget.loan.guarantee == 'BKP'
                                      ? const Color(0xFF023A8F)
                                      : Colors.grey.shade300,
                                  width: 1.5,
                                ),
                                color: widget.loan.guarantee == 'BKP'
                                    ? const Color(0xFF023A8F).withOpacity(0.05)
                                    : Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    widget.loan.guarantee == 'BKP'
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off,
                                    color: widget.loan.guarantee == 'BKP'
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
                            onTap: () =>
                                setState(() => guarantee = 'STUDENT_CARD'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: widget.loan.guarantee == 'STUDENT_CARD'
                                      ? const Color(0xFF023A8F)
                                      : Colors.grey.shade300,
                                  width: 1.5,
                                ),
                                color: widget.loan.guarantee == 'STUDENT_CARD'
                                    ? const Color(0xFF023A8F).withOpacity(0.05)
                                    : Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    widget.loan.guarantee == 'STUDENT_CARD'
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off,
                                    color:
                                        widget.loan.guarantee == 'STUDENT_CARD'
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
                    const SizedBox(height: 12),

                    const Text(
                      "Warranty Image",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    // Warranty image
                    if (widget.loan.image != null &&
                        widget.loan.image!.isNotEmpty)
                      Container(
                        width: double.infinity,
                        height: 200, // ukuran container tetap seragam
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[100],
                        ),
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              AppApi.imagePath + widget.loan.image!,
                              fit: BoxFit.contain, // biar tidak ketarik aneh
                              height: 180, // batasi biar rapi
                            ),
                          ),
                        ),
                      ),

                    SizedBox(height: 8),
                    // Description
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          enabled: false,
                          controller: descriptionController,
                          maxLines: 2,
                          style: const TextStyle(
                            // ✅ teks hasil input selalu hitam
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Colors.grey.shade200, // background abu
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: Colors.grey.shade300, width: 1.2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: Colors.grey.shade300, width: 1.2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: Color(0xFF023A8F), width: 1.5),
                            ),
                            hintStyle: const TextStyle(
                              // hint tetap abu-abu
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 12),
                    // Lender's Name & Room (student)
                    // Student section
                    if (student != null) ...[
                      Row(
                        children: [
                          buildReadonlyField(
                            label: "Lender's Name",
                            value: lenderController.text,
                          ),
                          const SizedBox(width: 8),
                          buildReadonlyField(
                            label: "Room",
                            value: safeString(widget.loan.room),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],

// Teacher section
                    if (teacher != null) ...[
                      Row(
                        children: [
                          buildReadonlyField(
                            label: "Lender's Name",
                            value: lenderController.text,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],

// PickUp & Return
                    Row(
                      children: [
                        buildReadonlyField(
                          label: "Pick Up Time",
                          value: pickUpController.text,
                        ),
                        const SizedBox(width: 8),
                        buildReadonlyField(
                          label: "Return Time",
                          value: returnController.text,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
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
                            child: Text("Make sure the item in good condition",
                                overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isChecked ? Colors.blue : Colors.grey,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: isChecked
                            ? () async {
                                final now = DateTime.now();
                                final returnedAt =
                                    "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:00";
                                final result = await controller.returnLoan(
                                    widget.loan.id, returnedAt, widget.token);
                                if (result != null && result['status'] == 200) {
                                  Get.snackbar(
                                      "Success", "Item returned successfully");
                                  // Buat data struk dari loan
                                  final receiptData = {
                                    'date':
                                        widget.loan.borrowedAt.split(' ').first,
                                    'time': widget.loan.borrowedAt
                                                .split(' ')
                                                .length >
                                            1
                                        ? widget.loan.borrowedAt.split(' ')[1]
                                        : "-",
                                    'nis': widget.loan.student != null
                                        ? safeString(
                                            widget.loan.student?['nis'])
                                        : null,
                                    'nip': widget.loan.teacher != null
                                        ? safeString(
                                            widget.loan.teacher?['nip'])
                                        : null,
                                    'name': widget.loan.student != null
                                        ? safeString(
                                            widget.loan.student?['name'])
                                        : widget.loan.teacher != null
                                            ? safeString(
                                                widget.loan.teacher?['name'])
                                            : null,
                                    'major': widget.loan.student != null
                                        ? safeString(
                                            widget.loan.student?['major'])
                                        : null,
                                    'room': safeString(widget
                                        .loan.room), // <-- selalu kirim room
                                    'telephone': widget.loan.teacher != null
                                        ? safeString(
                                            widget.loan.teacher?['telephone'])
                                        : null,
                                    'description': widget.loan.purpose,
                                    'warranty': widget.loan.guarantee,
                                    'unitCode': widget.unitItem.codeUnit,
                                    'merk': widget.unitItem.subItem.merk,
                                    'author': "Iqbal Fajar Syahbana",
                                  };
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          SuccespengembalianCustomePage(
                                        onShowReceipt: null,
                                        receiptData: receiptData,
                                        showDashboardButton: true,
                                      ),
                                    ),
                                  );
                                } else {
                                  Get.snackbar(
                                      "Error",
                                      result?['message'] ??
                                          "Failed to return item");
                                }
                              }
                            : null,
                        child: Text("Return"),
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReadonlyField({
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            enabled: false,
            initialValue: value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.grey.shade200, // ❌ tidak bisa diedit
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
                borderSide:
                    const BorderSide(color: Color(0xFF023A8F), width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepCircle(
    int number, {
    bool isCheck = false,
    Color? color,
  }) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: color ?? Colors.grey[300],
      child: isCheck
          ? const Icon(
              Icons.check,
              color: Colors.white,
              size: 18,
            )
          : Text(
              "$number",
              style: TextStyle(
                color: Colors.white, // angka putih biar kontras
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }

  Widget _stepLine(Color color) {
    return Expanded(
      child: Container(
        height: 2,
        color: color,
      ),
    );
  }
}
