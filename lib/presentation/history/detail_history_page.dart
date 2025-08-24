import 'package:flutter/material.dart';
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
    final teacher = item.teacher ?? {}; // Ambil dari root HistoryItem jika ada
    final nis = student['nis']?.toString() ?? '';
    final rayon = student['rayon'] ?? '';
    final jurusan = student['major']?['name'] ?? '';
    final qrcodeUrl = (unitItem?['qrcode'] ?? '').replaceFirst(
      'http://localhost:8000',
      AppApi.imagePath.replaceFirst('/storage/', ''),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail History', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.image != null)
              Center(
                child: Image.network(
                  '${AppApi.imagePath}${item.image}',
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(Icons.image, size: 80),
                ),
              ),
            SizedBox(height: 16),
            Text(
              unitItem?['code_unit'] ?? '',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text('Description: ${unitItem?['description'] ?? '-'}'),
            SizedBox(height: 8),
            Text('Borrowed By: ${item.borrowedBy}'),
            SizedBox(height: 8),
            Text('Purpose: ${item.purpose}'),
            SizedBox(height: 8),
            Text('Room: ${item.room}'),
            SizedBox(height: 8),
            Text('Guarantee: ${item.guarantee}'),
            SizedBox(height: 8),
            Text('Borrowed At: ${item.borrowedAt}'),
            SizedBox(height: 8),
            Text('Returned At: ${item.returnedAt ?? '-'}'),
            SizedBox(height: 8),
            Text('Status: ${item.status == "returned" ? "Returned" : "Borrowed"}'),
            SizedBox(height: 16),
            if (student.isNotEmpty)
              Card(
                child: ListTile(
                  title: Text('Student: ${student['name'] ?? '-'}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('NIS: $nis'),
                      Text('Rayon: $rayon'),
                      Text('Jurusan: $jurusan'),
                    ],
                  ),
                ),
              ),
            if (teacher.isNotEmpty)
              Card(
                child: ListTile(
                  title: Text('Teacher: ${teacher['name'] ?? '-'}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (teacher['nip'] != null) Text('NIP: ${teacher['nip']}'),
                      if (teacher['subject'] != null) Text('Subject: ${teacher['subject']}'),
                      // Tambahkan field lain sesuai struktur API teacher
                    ],
                  ),
                ),
              ),
            SizedBox(height: 8),
            Text('Merk: ${subItem['merk'] ?? '-'}'),
            SizedBox(height: 8),
            Text('Item Type: ${itemType['name'] ?? '-'}'),
            SizedBox(height: 8),
            if (qrcodeUrl.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('QR Code:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Center(
                    child: Image.network(
                      qrcodeUrl,
                      height: 120,
                      errorBuilder: (_, __, ___) => Icon(Icons.qr_code, size: 80),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}