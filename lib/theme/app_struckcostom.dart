import 'package:flutter/material.dart';

class StruckCustomPage extends StatelessWidget {
  final String date;
  final String time;
  final String? nis;
  final String? name;
  final String? major;
  final String? description;
  final String? room;
  final String? warranty;
  final String? unitCode;
  final String? merk; // gunakan merk untuk type dan brand
  final String? author;

  const StruckCustomPage({
    Key? key,
    required this.date,
    required this.time,
    this.nis,
    this.name,
    this.major,
    this.description,
    this.room,
    this.warranty,
    this.unitCode,
    this.merk,
    this.author = "Iqbal Fajar Syahbana",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header blue with logo
            Container(
              width: double.infinity,
              color: Color(0xFF0A3576),
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  Icon(Icons.inventory_2, size: 48, color: Colors.white),
                  const SizedBox(height: 8),
                  const Text(
                    "WiKVENTORY",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Text(
                    "Smart inventory for smart school",
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
            // Struk card
            Expanded(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Date & Time
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(date, style: TextStyle(fontWeight: FontWeight.w500)),
                          Text(time, style: TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const Divider(height: 24, thickness: 1),
                      // Info
                      _infoRow("NIS", nis),
                      _infoRow("NAME", name),
                      _infoRow("MAJOR", major),
                      _infoRow("DESCRIPTION", description),
                      _infoRow("ROOM", room),
                      _infoRow("WARRANTY", warranty),
                      const SizedBox(height: 12),
                      Divider(thickness: 1),
                      // Unit info
                      _infoRow("Unit Code", unitCode),
                      _infoRow("Type", merk),   // gunakan merk untuk type
                      _infoRow("Brand", merk),  // gunakan merk untuk brand
                      Divider(thickness: 1),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          author ?? "",
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Go to Dashboard button
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: SizedBox(
                width: 220,
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0A3576),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text(
                    "Go to Dashboard",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: TextStyle(fontSize: 13, color: Colors.black87)),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value ?? "-",
              style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w500),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
