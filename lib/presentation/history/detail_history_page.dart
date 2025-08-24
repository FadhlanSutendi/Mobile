import 'package:flutter/material.dart';
import 'models/history_models.dart';

class DetailHistoryPage extends StatelessWidget {
  final HistoryItem item;
  DetailHistoryPage({required this.item});

  @override
  Widget build(BuildContext context) {
    final unitItem = item.unitItem;
    final subItem = unitItem?['sub_item'] ?? {};
    final itemType = subItem['item'] ?? {};
    final major = subItem['major'] ?? {};
    final student = unitItem?['student'] ?? {};
    final nis = student['nis'] ?? '';
    final rayon = student['rayon'] ?? '';
    final jurusan = major['name'] ?? '';
    final qrcodeUrl = unitItem?['qrcode'] ?? '';

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
                  'https://55d0909b17e1.ngrok-free.app/storage/${item.image}',
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
            Text('Status: ${item.status ? "Returned" : "Borrowed"}'),
            SizedBox(height: 16),
            if (item.studentName != null)
              Card(
                child: ListTile(
                  title: Text('Student: ${item.studentName}'),
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
            if (item.teacherName != null)
              Card(
                child: ListTile(
                  title: Text('Teacher: ${item.teacherName}'),
                  // Add more teacher fields if needed
                ),
              ),
            SizedBox(height: 8),
            Text('Merk: ${subItem['merk'] ?? '-'}'),
            SizedBox(height: 8),
            Text('Item Type: ${itemType['name'] ?? '-'}'),
            SizedBox(height: 8),
            if (qrcodeUrl != '')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('QR Code:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Center(
                    child: Image.network(
                      qrcodeUrl.replaceFirst('http://localhost:8000', 'https://55d0909b17e1.ngrok-free.app'),
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