import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart'; // ⬅ Tambah ini
import 'models/history_models.dart';
import '../../core/api/app_api.dart';

class DetailHistoryPage extends StatelessWidget {
  final HistoryItem item;
  DetailHistoryPage({required this.item});

  @override
  Widget build(BuildContext context) {
    final unitItem = item.unitItem;
    final subItem = unitItem?['sub_item'] ?? {};
    final itemType = subItem['item'] ?? {};
    final student = item.student ?? {};
    final teacher = item.teacher ?? {};

    // Debug data untuk memastikan struktur data benar
    print("Unit Item: $unitItem");
    print("Sub Item: $subItem");
    print("Item Type: $itemType");
    print("Student: $student");
    print("Teacher: $teacher");

    final nis = student['nis']?.toString() ?? '';
    final rayon = student['rayon'] ?? '';
    final jurusan = student['major']?['name'] ?? '';

    // Pastikan description diambil dari tempat yang benar
    final description = unitItem?['description'] ?? subItem['description'] ?? '-';

    // Pastikan lender name diambil dari teacher atau data yang sesuai
    final lenderName = teacher['name'] ?? 'Admin';

    final qrcodeUrl = (unitItem?['qrcode'] ?? '').replaceFirst(
      'http://localhost:8000',
      AppApi.imagePath.replaceFirst('/storage/', ''),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF023A8F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF023A8F),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Detail Borrowed",
          style: GoogleFonts.poppins( // ⬅ Poppins
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Konten putih
            Container(
              margin: EdgeInsets.only(top: 80),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(height: 80),
                  Text(
                    unitItem?['code_unit'] ?? '',
                    style: GoogleFonts.poppins( // ⬅ Poppins
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 24),

                  // ITEM INFO
                  sectionTitle("ITEM INFO"),
                  Row(
                    children: [
                      Expanded(
                        child: infoField("Type", itemType['name'] ?? '-'),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: infoField("Brand", subItem['merk'] ?? '-'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // BORROWER INFO
                  sectionTitle("BORROWER'S INFO"),
                  Row(
                    children: [
                      Expanded(child: infoField("NIS", nis)),
                      SizedBox(width: 12),
                      Expanded(child: infoField("Name", student['name'] ?? '-')),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: infoField("Rayon", rayon)),
                      SizedBox(width: 12),
                      Expanded(child: infoField("Major", jurusan)),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: infoField("Date - Pick Up Time", item.borrowedAt ?? '-'),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: infoField(
                          "Room",
                          item.room?.toString() ??
                              (unitItem?['room']?.toString() ?? '-'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // DESCRIPTION - PERBAIKAN DI SINI
                  sectionTitle("Description"),
                  infoField("", description),
                  SizedBox(height: 16),

                  // LENDER INFO - PERBAIKAN DI SINI
                  sectionTitle("Lender's Name"),
                  infoField("", lenderName),
                  SizedBox(height: 32),
                ],
              ),
            ),

            // QR Code di tengah
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: qrcodeUrl.isNotEmpty
                      ? (qrcodeUrl.endsWith(".svg")
                          ? SvgPicture.network(
                              qrcodeUrl,
                              height: 120,
                              placeholderBuilder: (_) =>
                                  Icon(Icons.qr_code, size: 80),
                            )
                          : Image.network(
                              qrcodeUrl,
                              height: 120,
                              errorBuilder: (_, __, ___) =>
                                  Icon(Icons.qr_code, size: 100),
                            ))
                      : Icon(Icons.qr_code, size: 100),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          title,
          style: GoogleFonts.poppins( // ⬅ Poppins
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
      ),
    );
  }

  Widget infoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty)
            Text(
              label,
              style: GoogleFonts.poppins( // ⬅ Poppins
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
          SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              value,
              style: GoogleFonts.poppins( // ⬅ Poppins
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}