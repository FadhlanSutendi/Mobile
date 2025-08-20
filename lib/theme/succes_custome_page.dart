import 'package:flutter/material.dart';
import 'app_struckcostom.dart';

class SuccessCustomPage extends StatelessWidget {
  final Map<String, dynamic>? receiptData;

  const SuccessCustomPage({
    Key? key,
    this.onShowReceipt,
    this.receiptData,
    this.showDashboardButton = false,
  }) : super(key: key);

  final VoidCallback? onShowReceipt;
  final bool showDashboardButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // ✅ Green check icon
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(32),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 64,
                  ),
                ),

                const SizedBox(height: 24),

                // ✅ Success text
                const Text(
                  "Success",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 8),

                // ✅ Subtext
                const Text(
                  "Borrowing item created successfully!",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),

                const Spacer(flex: 3),

                // ✅ Show receipt button
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
                            merk: receiptData!['merk'],
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

                if (showDashboardButton)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      child: const Text("back to dashboard"),
                    ),
                  ),

                const SizedBox(height: 16),

                // ✅ Footer pakai logo image
                Image.asset(
                  'assets/logo2.png',
                  height: 20, // atur ukuran sesuai kebutuhan
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
