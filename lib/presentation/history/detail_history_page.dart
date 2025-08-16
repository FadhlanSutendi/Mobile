import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controller/detail_history_controller.dart';

class DetailHistoryPage extends StatelessWidget {
  final String id;
  final String token;
  DetailHistoryPage({required this.id, required this.token});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetailHistoryController(id: id, token: token)..fetchDetail(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Detail History', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Consumer<DetailHistoryController>(
          builder: (context, controller, _) {
            if (controller.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (controller.detail == null) {
              return Center(child: Text('No detail found'));
            }
            final d = controller.detail!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  if (d.image != null)
                    Center(
                      child: Image.network(
                        'https://bccdebd2a24a.ngrok-free.app/storage/${d.image}',
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(Icons.image, size: 80),
                      ),
                    ),
                  SizedBox(height: 16),
                  Text(
                    d.unitItem?.codeUnit ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text('Description: ${d.unitItem?.description ?? '-'}'),
                  SizedBox(height: 8),
                  Text('Borrowed By: ${d.borrowedBy}'),
                  SizedBox(height: 8),
                  Text('Purpose: ${d.purpose}'),
                  SizedBox(height: 8),
                  Text('Room: ${d.room}'),
                  SizedBox(height: 8),
                  Text('Guarantee: ${d.guarantee}'),
                  SizedBox(height: 8),
                  Text('Borrowed At: ${d.borrowedAt}'),
                  SizedBox(height: 8),
                  Text('Returned At: ${d.returnedAt ?? '-'}'),
                  SizedBox(height: 8),
                  Text('Status: ${d.status ? "Returned" : "Borrowed"}'),
                  SizedBox(height: 16),
                  if (d.student != null)
                    Card(
                      child: ListTile(
                        title: Text('Student: ${d.student!.name}'),
                        subtitle: Text('NIS: ${d.student!.nis}\nRayon: ${d.student!.rayon}'),
                      ),
                    ),
                  if (d.teacher != null)
                    Card(
                      child: ListTile(
                        title: Text('Teacher'),
                        // Add teacher fields if needed
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
