import 'package:flutter/material.dart';
import 'app_struckcostom.dart';

class SuccessCustomPage extends StatelessWidget {
  final VoidCallback? onShowReceipt;
  // Tambahkan parameter data yang diperlukan
  final Map<String, dynamic>? receiptData;

  const SuccessCustomPage({Key? key, this.onShowReceipt, this.receiptData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            // Green check icon
            Container(
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(32),
              child: const Icon(Icons.check, color: Colors.white, size: 64),
            ),
            const SizedBox(height: 24),
            // Success text
            const Text(
              "Success",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            // Subtext
            const Text(
              "Borrowing item created successfully!",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 3),
            // Show receipt button
            TextButton(
              onPressed: () {
                if (receiptData != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StruckCustomPage(
                        date: receiptData!['date'] ?? "-",
                        time: receiptData!['time'] ?? "-",
                        nis: receiptData!['nis'],
                        name: receiptData!['name'],
                        major: receiptData!['major'],
                        description: receiptData!['description'],
                        room: receiptData!['room'],
                        warranty: receiptData!['warranty'],
                        unitCode: receiptData!['unitCode'],
                        type: receiptData!['type'],
                        brand: receiptData!['brand'],
                        author: receiptData!['author'],
                      ),
                    ),
                  );
                } else if (onShowReceipt != null) {
                  onShowReceipt!();
                }
              },
              child: const Text(
                "show receipt",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Logo and app name
            Column(
              children: [
                // Replace with your logo asset if available
                Icon(Icons.inventory_2, size: 36, color: Colors.black),
                const SizedBox(height: 4),
                const Text(
                  "WiKVENTORY",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: 1.5,
                  ),
                ),
                const Text(
                  "Smart inventory for smart school",
                  style: TextStyle(fontSize: 10, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
