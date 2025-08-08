import 'package:flutter/material.dart';
import '../scan barcode/models/scanbarcode_models.dart';

class CekItemPage extends StatefulWidget {
  final UnitItem unitItem;
  CekItemPage({required this.unitItem});

  @override
  _CekItemPageState createState() => _CekItemPageState();
}

class _CekItemPageState extends State<CekItemPage> {
  int selectedMode = 0; // 0: Pinjaman, 1: Pengembalian

  @override
  Widget build(BuildContext context) {
    final unitItem = widget.unitItem;
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Step Indicator
            Row(
              children: [
                _stepCircle(1, true),
                _stepLine(),
                _stepCircle(2, false),
                _stepLine(),
                _stepCircle(3, false),
              ],
            ),
            SizedBox(height: 4),
            Row(
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
            SizedBox(height: 24),
            // Button Pinjaman & Pengembalian
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          selectedMode == 0 ? Colors.blue : Colors.white,
                      foregroundColor:
                          selectedMode == 0 ? Colors.white : Colors.black,
                      side: BorderSide(color: Colors.blue),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedMode = 0;
                      });
                    },
                    child: Text("Pinjaman"),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          selectedMode == 1 ? Colors.blue : Colors.white,
                      foregroundColor:
                          selectedMode == 1 ? Colors.white : Colors.black,
                      side: BorderSide(color: Colors.blue),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedMode = 1;
                      });
                    },
                    child: Text("Pengembalian"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            // Input fields
            _readonlyField("Type", unitItem.subItem.merk),
            SizedBox(height: 16),
            _readonlyField("Unit Code", unitItem.codeUnit),
            SizedBox(height: 16),
            _readonlyField("Brand", unitItem.subItem.merk),
            Spacer(),
            // Navigation buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      // Next step action
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Next"),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
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

  Widget _readonlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        TextFormField(
          initialValue: value,
          readOnly: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          ),
        ),
      ],
    );
  }
}
