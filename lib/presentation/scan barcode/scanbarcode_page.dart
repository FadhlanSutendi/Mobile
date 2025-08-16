import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../cek_item/cek_item_page.dart';
import '../login/controller/login_controller.dart';
import 'controller/scanbarcode_controller.dart';
import '../cek_item/models/cek_item_models.dart';
import '../pengembalian/pengembalian_page.dart'; // import pengembalian page
import '../pengembalian/models/pengembalian_models.dart'; // import pengembalian models
import '../pengembalian/controller/pengembalian_controller.dart';

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
  final loginController = Get.find<LoginController>();

  Future<void> _onBarcodeDetect(BarcodeCapture capture) async {
    if (hasScanned) return;

    hasScanned = true;
    debugPrint('onDetect called');

    try {
      final value =
          capture.barcodes.isNotEmpty ? capture.barcodes.first.rawValue : null;

      if (value != null) {
        debugPrint('Barcode found: $value');
        setState(() {
          isLoading = true;
          scannedResult = value;
          // Jika pakai searchController, isi hasil scan ke field
          // searchController.text = value;
        });

        final result = await scanController.fetchUnitItemOrLoan(
          value, // value adalah hasil scan barcode
          token: loginController.token.value,
        );

        if (result != null) {
          await mobileScannerController.stop();
          // If loan exists, show pengembalian page
          if (result['loan'] != null) {
            await Get.to(() => PengembalianPage(
              loan: result['loan'],
              unitItem: result['unitItem'],
              token: loginController.token.value,
            ));
          }
          // If only unitItem exists, show cek item page
          else if (result['unitItem'] != null) {
            await Get.to(() => CekItemPage(unitItem: result['unitItem']));
          }
          setState(() => scannedResult = null);
          await mobileScannerController.start();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data tidak ditemukan')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error saat scanning: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan saat scan')),
      );
    } finally {
      setState(() {
        isLoading = false;
        hasScanned = false;
      });
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
                return Stack(
                  children: [
                    MobileScanner(
                      controller: mobileScannerController,
                      onDetect: _onBarcodeDetect,
                      errorBuilder: (context, error, child) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            cameraError = 'Gagal mengakses kamera: $error';
                          });
                        });
                        return Center(child: Text('Gagal mengakses kamera: $error'));
                      },
                    ),
                    // Tombol switch camera & flash
                    Positioned(
                      right: 16,
                      top: 16,
                      child: Column(
                        children: [
                          FloatingActionButton(
                            heroTag: 'switchCamera',
                            mini: true,
                            onPressed: () {
                              mobileScannerController.switchCamera();
                            },
                            child: const Icon(Icons.cameraswitch),
                          ),
                          const SizedBox(height: 8),
                          FloatingActionButton(
                            heroTag: 'toggleFlash',
                            mini: true,
                            onPressed: () {
                              mobileScannerController.toggleTorch();
                            },
                            child: const Icon(Icons.flash_on),
                          ),
                        ],
                      ),
                    ),
                  ],
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
