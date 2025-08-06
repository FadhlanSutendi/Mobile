import 'package:flutter/material.dart';

class CekItemPage extends StatefulWidget {
  final String scannedId;
  CekItemPage({required this.scannedId});

  @override
  _CekItemPageState createState() => _CekItemPageState();
}

class _CekItemPageState extends State<CekItemPage> {
  late TextEditingController _idController;
  String? validationMessage;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.scannedId);
    _validateId(widget.scannedId);
  }

  void _validateId(String id) {
    // Dummy validation: id must not be empty and must be numeric
    if (id.isEmpty) {
      validationMessage = "ID tidak boleh kosong";
    } else if (!RegExp(r'^\d+$').hasMatch(id)) {
      validationMessage = "ID harus berupa angka";
    } else {
      validationMessage = null;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cek Item")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: "ID Item",
                errorText: validationMessage,
              ),
              onChanged: _validateId,
            ),
            // ...add more widgets as needed...
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }
}
