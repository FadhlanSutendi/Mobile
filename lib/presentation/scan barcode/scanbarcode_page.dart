import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../cek_item/cek_item_page.dart';
import 'controller/scanbarcode_controller.dart';
import 'models/scanbarcode_models.dart';

class ScanBarcodePage extends StatefulWidget {
  @override
  State<ScanBarcodePage> createState() => _ScanBarcodePageState();
}

class _ScanBarcodePageState extends State<ScanBarcodePage> {
  String? scannedResult;
  bool isLoading = false;
  bool hasScanned = false;
  String? cameraError;

  final ScanBarcodeController scanController = ScanBarcodeController();
  final MobileScannerController mobileScannerController =
      MobileScannerController();

  Future<void> _onBarcodeDetect(BarcodeCapture capture) async {
    if (hasScanned) return;

    hasScanned = true;
    debugPrint('onDetect called');

    final value =
        capture.barcodes.isNotEmpty ? capture.barcodes.first.rawValue : null;

    if (value != null) {
      debugPrint('Barcode found: $value');

      setState(() {
        isLoading = true;
        scannedResult = value;
      });

      final unitItem = await scanController.fetchUnitItem(value);

      setState(() {
        isLoading = false;
      });

      if (unitItem != null) {
        await mobileScannerController.stop();
        await Get.to(() => CekItemPage(unitItem: unitItem));
        hasScanned = false;
        setState(() {
          scannedResult = null;
        });
        await mobileScannerController.start();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data tidak ditemukan')),
        );
        hasScanned = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR/Barcode")),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Builder(
              builder: (context) {
                if (cameraError != null) {
                  return Center(child: Text(cameraError!));
                }
                return MobileScanner(
                  controller: mobileScannerController,
                  onDetect: _onBarcodeDetect,
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  scannedResult != null
                      ? Text('Barcode terdeteksi: $scannedResult')
                      : const Text('Arahkan kamera ke QR/Barcode'),
                  const SizedBox(height: 16),
                  if (isLoading) const CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
