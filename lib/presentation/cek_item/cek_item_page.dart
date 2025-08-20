import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/cek_item_controller.dart';
// import '../scan barcode/models/scanbarcode_models.dart';
import 'models/cek_item_models.dart'; // gunakan model yang benar
import '../login/controller/login_controller.dart';
import '../peminjaman/peminjaman_page.dart'; // tambahkan import ini

class CekItemPage extends StatefulWidget {
  final UnitItem unitItem; // ubah menjadi non-nullable dan required

  const CekItemPage({Key? key, required this.unitItem}) : super(key: key);

  @override
  _CekItemPageState createState() => _CekItemPageState();
}

class _CekItemPageState extends State<CekItemPage> {
  int selectedMode = 0; // 0: Pinjaman, 1: Pengembalian
  final cekItemController = Get.put(CekItemController());
  final loginController = Get.find<LoginController>();
  final TextEditingController searchController = TextEditingController();

  // Tambahkan controller untuk setiap input field
  final TextEditingController typeController = TextEditingController();
  final TextEditingController codeUnitController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController procurementDateController =
      TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController conditionController = TextEditingController();

  String? borrowerType; // 'student' atau 'teacher'

  @override
  void initState() {
    super.initState();
    cekItemController.unitItem.value = widget.unitItem;
    _setControllers(widget.unitItem);
    // Listen perubahan unitItem dari controller, update field jika berubah
    ever<UnitItem?>(cekItemController.unitItem, (unitItem) {
      if (unitItem != null) {
        _setControllers(unitItem);
      } else {
        // Kosongkan field jika unitItem null
        typeController.clear();
        codeUnitController.clear();
        brandController.clear();
        descriptionController.clear();
        procurementDateController.clear();
        statusController.clear();
        conditionController.clear();
      }
    });
  }

  void _setControllers(UnitItem unitItem) {
    typeController.text = unitItem.subItem.merk;
    codeUnitController.text = unitItem.codeUnit;
    brandController.text = unitItem.subItem.merk;
    descriptionController.text = unitItem.description;
    procurementDateController.text = unitItem.procurementDate;
    statusController.text = unitItem.status.toString();
    conditionController.text = unitItem.condition.toString();
  }

  @override
  void dispose() {
    // Dispose semua controller
    typeController.dispose();
    codeUnitController.dispose();
    brandController.dispose();
    descriptionController.dispose();
    procurementDateController.dispose();
    statusController.dispose();
    conditionController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Custom Navbar
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Form Borrowing",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ✅ Step Indicator
                Row(
                  children: [
                    _stepCircle(1, true),
                    _stepLine(),
                    _stepCircle(2, false),
                    _stepLine(),
                    _stepCircle(3, false),
                  ],
                ),
                const SizedBox(height: 4),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 60,
                      child: Column(
                        children: [
                          Text("Check",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12)),
                          Text("Item",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: Text("Borrower Info",
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text("Collateral",
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ✅ Konten pakai Obx biar reactive
                Obx(() {
                  if (cekItemController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (cekItemController.errorMessage.value.isNotEmpty) {
                    return Text(
                      cekItemController.errorMessage.value,
                      style: const TextStyle(color: Colors.red),
                    );
                  }
                  final unitItem = cekItemController.unitItem.value;
                  if (unitItem == null) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            _inputField("Type", typeController),
                            const SizedBox(height: 16),
                            _inputField("Unit Code", codeUnitController),
                            const SizedBox(height: 16),
                            _inputField("Brand", brandController),
                            const SizedBox(height: 16),
                            _inputField("Description", descriptionController),
                            const SizedBox(height: 16),
                            _inputField(
                                "Procurement Date", procurementDateController),
                            const SizedBox(height: 16),
                            _inputField("Status", statusController),
                            const SizedBox(height: 16),
                            _inputField("Condition", conditionController),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () async {
                                setState(() {
                                  borrowerType = 'student';
                                });
                                await Get.to(() => PeminjamanPage(
                                      unitItem: unitItem,
                                      initialStep: 1,
                                      token: loginController.token.value,
                                      borrowerType: 'student',
                                    ));
                              },
                              child: const Text("Student"),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () async {
                                setState(() {
                                  borrowerType = 'teacher';
                                });
                                await Get.to(() => PeminjamanPage(
                                      unitItem: unitItem,
                                      initialStep: 1,
                                      token: loginController.token.value,
                                      borrowerType: 'teacher',
                                    ));
                              },
                              child: const Text("Teacher"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
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

  Widget _inputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          ),
        ),
      ],
    );
  }
}
