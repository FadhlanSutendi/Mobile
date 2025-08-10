import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../cek_item/models/cek_item_models.dart'; // gunakan model yang benar
import 'controller/peminjaman_controller.dart';
import 'models/peminjaman_models.dart';

class PeminjamanPage extends StatelessWidget {
  final UnitItem? unitItem;
  final int initialStep; // tambahkan parameter ini

  PeminjamanPage({Key? key, this.unitItem, this.initialStep = 0}) : super(key: key);

  final controller = Get.put(PeminjamanController());

  final nisController = TextEditingController();
  final nameController = TextEditingController();
  final rayonController = TextEditingController();
  final majorController = TextEditingController();
  final descriptionController = TextEditingController();
  final lenderController = TextEditingController();
  final dateController = TextEditingController();
  final purposeController = TextEditingController();
  final roomController = TextEditingController();
  final guarantee = 'kartu pelajar'.obs;

  @override
  Widget build(BuildContext context) {
    // Set data unit item ke controller jika ada
    if (unitItem != null && controller.unitItem == null) {
      controller.unitItem = unitItem;
    }
    // Set initial step jika belum diatur
    if (controller.step.value == 0 && initialStep != 0) {
      controller.step.value = initialStep;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Form Borrowing"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => controller.prevStep(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Obx(() => StepperWidget(
        step: controller.step.value,
        onStepContinue: () => controller.nextStep(),
        onStepCancel: () => controller.prevStep(),
        child: _buildStepContent(context),
      )),
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
    if (unitItem == null) {
      return Center(child: Text("No item selected"));
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: ListTile(
          title: Text(unitItem!.subItem.merk),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Code: ${unitItem!.codeUnit}"),
              Text("Description: ${unitItem!.description}"),
              Text("Procurement Date: ${unitItem!.procurementDate}"),
              Text("Status: ${unitItem!.status}"),
              Text("Condition: ${unitItem!.condition}"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepBorrowerInfo() {
    return Column(
      children: [
        TextFormField(controller: nisController, decoration: InputDecoration(labelText: "NIS")),
        TextFormField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
        TextFormField(controller: rayonController, decoration: InputDecoration(labelText: "Rayon")),
        TextFormField(controller: majorController, decoration: InputDecoration(labelText: "Major")),
        // ...add teacher fields if needed...
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
        children: [
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text("BKP"),
                  leading: Radio(
                    value: 'BKP',
                    groupValue: guarantee.value,
                    onChanged: (val) => guarantee.value = val!,
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text("STUDENT CARD"),
                  leading: Radio(
                    value: 'kartu pelajar',
                    groupValue: guarantee.value,
                    onChanged: (val) => guarantee.value = val!,
                  ),
                ),
              ),
            ],
          ),
          Obx(() => controller.imagePath.value.isEmpty
              ? OutlinedButton.icon(
                  icon: Icon(Icons.camera_alt),
                  label: Text("Upload Warranty"),
                  onPressed: () => controller.pickImage(),
                )
              : Stack(
                  children: [
                    Image.file(
                      File(controller.imagePath.value),
                      width: 200,
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
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: "Description"),
          ),
          TextFormField(
            controller: lenderController,
            decoration: InputDecoration(labelText: "Lender's Name"),
          ),
          TextFormField(
            controller: dateController,
            decoration: InputDecoration(labelText: "Date - Pick Up Time"),
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2024),
                lastDate: DateTime(2030),
              );
              if (picked != null) {
                dateController.text = picked.toString();
              }
            },
          ),
          Row(
            children: [
              Checkbox(value: true, onChanged: (_) {}),
              Text("Make sure the data is correct"),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              // Compose LoanRequest and submit
              final req = LoanRequest(
                studentId: controller.student.value?.id,
                unitItemId: unitItem?.codeUnit ?? "unit_item_id", // gunakan codeUnit dari unitItem
                borrowedBy: lenderController.text,
                borrowedAt: dateController.text,
                purpose: descriptionController.text,
                room: int.tryParse(roomController.text) ?? 0,
                imagePath: controller.imagePath.value,
                guarantee: guarantee.value,
              );
              controller.submitLoan(req, "token"); // replace token
            },
            child: Text("Submit"),
          ),
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
