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
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    controller = Get.put(PengembalianController());
    descriptionController.text = widget.loan.purpose;
    lenderController.text = widget.loan.borrowedBy;
    pickUpController.text = _formatDateTime(widget.loan.borrowedAt);
    returnController.text = _formatDateTime(DateTime.now().toString());
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
              padding: const EdgeInsets.symmetric(horizontal: 40),
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
              padding: EdgeInsets.symmetric(horizontal: 25),
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
                      child: Text("Borrower info",
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
                          Flexible(
                            child: TextFormField(
                              enabled: false,
                              initialValue: safeString(student['nis']),
                              decoration: InputDecoration(
                                labelText: "NIS",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 12),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Flexible(
                            child: TextFormField(
                              enabled: false,
                              initialValue: safeString(student['name']),
                              decoration: InputDecoration(
                                labelText: "Name",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Flexible(
                            child: TextFormField(
                              enabled: false,
                              initialValue: safeString(student['rayon']),
                              decoration: InputDecoration(
                                labelText: "Rayon",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 12),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Flexible(
                            child: TextFormField(
                              enabled: false,
                              initialValue: safeString(student['major']),
                              decoration: InputDecoration(
                                labelText: "Major",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      // Tambahkan Room untuk student
                      Row(
                        children: [
                          Flexible(
                            child: TextFormField(
                              enabled: false,
                              initialValue: safeString(widget.loan.room),
                              decoration: InputDecoration(
                                labelText: "Room",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                    ],
                    // Tampilkan data teacher jika ada
                    if (teacher != null) ...[
                      Row(
                        children: [
                          Flexible(
                            child: TextFormField(
                              enabled: false,
                              initialValue: safeString(teacher['nip']),
                              decoration: InputDecoration(
                                labelText: "NIP",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 12),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Flexible(
                            child: TextFormField(
                              enabled: false,
                              initialValue: safeString(teacher['name']),
                              decoration: InputDecoration(
                                labelText: "Name",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Flexible(
                            child: TextFormField(
                              enabled: false,
                              initialValue: safeString(teacher['telephone']),
                              decoration: InputDecoration(
                                labelText: "Nomor Telepon",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 12),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Flexible(
                            child: TextFormField(
                              enabled: false,
                              initialValue: safeString(widget.loan.room),
                              decoration: InputDecoration(
                                labelText: "Room",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                    ],
                    // Warranty radio
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            value: 'BKP',
                            groupValue: widget.loan.guarantee,
                            contentPadding: EdgeInsets.zero,
                            activeColor: Colors.blue,
                            title: Text('BKP', style: TextStyle(fontSize: 14)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            onChanged: null,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: RadioListTile<String>(
                            value: 'STUDENT_CARD',
                            groupValue: widget.loan.guarantee,
                            contentPadding: EdgeInsets.zero,
                            activeColor: Colors.blue,
                            title: Text('STUDENT CARD',
                                style: TextStyle(fontSize: 14)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            onChanged: null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    // Warranty image
                    if (widget.loan.image != null &&
                        widget.loan.image!.isNotEmpty)
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              AppApi.imagePath + widget.loan.image!,
                              width: double.infinity,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Icon(Icons.close, color: Colors.transparent),
                          ),
                        ],
                      ),
                    SizedBox(height: 8),
                    // Description
                    TextFormField(
                      enabled: false,
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      ),
                      maxLines: 2,
                    ),
                    SizedBox(height: 12),
                    // Lender's Name & Room (student)
                    if (student != null) ...[
                      Row(
                        children: [
                          Flexible(
                            child: TextFormField(
                              enabled: false,
                              controller: lenderController,
                              decoration: InputDecoration(
                                labelText: "Lender's Name",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 12),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Flexible(
                            child: TextFormField(
                              enabled: false,
                              initialValue: safeString(widget.loan.room),
                              decoration: InputDecoration(
                                labelText: "Room",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                    ],
                    // Lender's Name (teacher)
                    if (teacher != null) ...[
                      TextFormField(
                        enabled: false,
                        controller: lenderController,
                        decoration: InputDecoration(
                          labelText: "Lender's Name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        ),
                      ),
                      SizedBox(height: 12),
                    ],
                    // Pick Up Time & Return Time
                    Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            enabled: false,
                            controller: pickUpController,
                            decoration: InputDecoration(
                              labelText: "Pick Up Time",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              prefixIcon: Icon(Icons.calendar_today),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Flexible(
                          child: TextFormField(
                            enabled: false,
                            controller: returnController,
                            decoration: InputDecoration(
                              labelText: "Return Time",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              prefixIcon: Icon(Icons.calendar_today),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                            ),
                          ),
                        ),
                      ],
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
                                    'date': widget.loan.borrowedAt.split(' ').first,
                                    'time': widget.loan.borrowedAt.split(' ').length > 1
                                        ? widget.loan.borrowedAt.split(' ')[1]
                                        : "-",
                                    'nis': widget.loan.student != null
                                        ? safeString(widget.loan.student?['nis'])
                                        : null,
                                    'nip': widget.loan.teacher != null
                                        ? safeString(widget.loan.teacher?['nip'])
                                        : null,
                                    'name': widget.loan.student != null
                                        ? safeString(widget.loan.student?['name'])
                                        : widget.loan.teacher != null
                                            ? safeString(widget.loan.teacher?['name'])
                                            : null,
                                    'major': widget.loan.student != null
                                        ? safeString(widget.loan.student?['major'])
                                        : null,
                                    'room': safeString(widget.loan.room), // <-- selalu kirim room
                                    'telephone': widget.loan.teacher != null
                                        ? safeString(widget.loan.teacher?['telephone'])
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