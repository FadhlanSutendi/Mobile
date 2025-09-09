import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
                    Text(
                      "Form Borrowing",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ✅ Step Indicator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _stepCircle(1, true),
                      const SizedBox(width: 5),
                      _stepLine(const Color.fromARGB(255, 0, 0, 0)),
                      const SizedBox(width: 5),
                      _stepCircle(2, false),
                      const SizedBox(width: 5),
                      _stepLine(const Color.fromARGB(255, 174, 175, 176)),
                      const SizedBox(width: 5),
                      _stepCircle(3, false),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 60,
                        child: Column(
                          children: [
                            Text("Check",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold, fontSize: 12)),
                            Text("Item",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                      ),
                       SizedBox(
                        width: 80,
                        child: Column(
                          children: [
                            Text("Borrower",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                            Text("Info",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        child: Text("Collateral",
                            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // ✅ Konten pakai Obx biar reactive
                Obx(() {
                  if (cekItemController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (cekItemController.errorMessage.value.isNotEmpty) {
                    return Text(
                      cekItemController.errorMessage.value,
                      style: GoogleFonts.poppins(color: Colors.red),
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
                            _inputField("Condition", conditionController),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Borrower",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                        
                            // Pilihan Student / Teacher
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() => borrowerType = 'student');
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: borrowerType == 'student'
                                              ? const Color(0xFF023A8F)
                                              : Colors.grey.shade300,
                                          width: 1.5,
                                        ),
                                        color: borrowerType == 'student'
                                            ? const Color(0xFF023A8F).withOpacity(0.05)
                                            : Colors.white,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            borrowerType == 'student'
                                                ? Icons.radio_button_checked
                                                : Icons.radio_button_off,
                                            color: borrowerType == 'student'
                                                ? const Color(0xFF023A8F)
                                                : Colors.grey,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 7),
                                          Text(
                                            "Student",
                                            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() => borrowerType = 'teacher');
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: borrowerType == 'teacher'
                                              ? const Color(0xFF023A8F)
                                              : Colors.grey.shade300,
                                          width: 1.5,
                                        ),
                                        color: borrowerType == 'teacher'
                                            ? const Color(0xFF023A8F).withOpacity(0.05)
                                            : Colors.white,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            borrowerType == 'teacher'
                                                ? Icons.radio_button_checked
                                                : Icons.radio_button_off,
                                            color: borrowerType == 'teacher'
                                                ? const Color(0xFF023A8F)
                                                : Colors.grey,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 7),
                                          Text(
                                            "Teacher",
                                            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        
                            const SizedBox(height: 120),
                        
                            // Tombol Back & Next
                            Row(
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () => Get.back(),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    side: const BorderSide(color: Colors.grey, width: 1.5),
                                    foregroundColor: Colors.grey,
                                  ),
                                  icon: const Icon(Icons.arrow_back),
                                  label: const Text(""),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: borrowerType == null
                                        ? null
                                        : () {
                                            Get.to(() => PeminjamanPage(
                                                  unitItem: widget.unitItem,
                                                  initialStep: 1,
                                                  token: loginController.token.value,
                                                  borrowerType: borrowerType!,
                                                ));
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF023A8F),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    icon: Text("Next", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                                    label: const Icon(Icons.arrow_forward),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )

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
      backgroundColor: active ? Color(0xFF023A8F) : Colors.grey[300],
      child: Text(
        "$number",
        style: GoogleFonts.poppins(
          color: active ? Colors.white : Colors.black,
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

  Widget _inputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          readOnly: true,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), // font input lebih kecil
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFEAEAEA),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.grey, // warna saat belum fokus
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.blue, // warna saat fokus
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 10,
            ),
          ),
        ),
      ],
    );
  }
}