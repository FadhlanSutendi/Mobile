import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    this.author,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Stack(
          children: [
            // Header biru dengan U-shape
            ClipPath(
              clipper: UShapeClipper(),
              child: Container(
                width: double.infinity,
                height: 300,
                color: const Color(0xFF0A3576),
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  children: [
                    SizedBox(height: 60),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Image.asset(
                        "assets/logo_putih.png",
                        height: 32,
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
        
            // Card struk ditempatkan dengan Positioned
            Positioned(
              top: 180, // atur sesuai kedalaman U-shape
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
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
                        Text(date,
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                        Text(time,
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const Divider(height: 24, thickness: 1),
        
                    _infoRow("NIS", nis),
                    _infoRow("NAME", name),
                    _infoRow("MAJOR", major),
                    _infoRow("DESCRIPTION", description),
                    _infoRow("ROOM", room),
                    _infoRow("WARRANTY", warranty),
        
                    const SizedBox(height: 12),
                    const Divider(thickness: 1),
        
                    _infoRow("Unit Code", unitCode),
                    _infoRow("Type", merk),
                    _infoRow("Brand", merk),
        
                    const Divider(thickness: 1),
                    const SizedBox(height: 16),
        
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: Text(
                    //     author ?? "",
                    //     style: GoogleFonts.poppins(
                    //         fontSize: 12, color: Colors.black87),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
        
            // Tombol Dashboard (posisi paling bawah)
            Positioned(
              bottom: 55,
              left: 195,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 160,
                  height: 38,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A3576),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Text(
                      "Go to Dashboard",
                      style: GoogleFonts.poppins(
                        // fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label,
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87)),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value ?? "-",
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  
}

class UShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);

    // Lengkungan ke bawah
    path.quadraticBezierTo(
      size.width / 2, size.height + 60, // titik lengkung
      size.width, size.height - 60,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
