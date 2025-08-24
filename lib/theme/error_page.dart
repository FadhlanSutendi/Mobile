import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final int errorCode;

  const ErrorPage({Key? key, required this.errorCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title;
    String description;
    String imagePath;

    switch (errorCode) {
      case 400:
        title = 'Bad Request';
        description =
            'Request tidak valid, misal format JSON salah atau field kurang';
        imagePath = 'assets/error.png';
        break;
      case 401:
        title = 'Unauthorized';
        description = 'Something has gone on the site’s server';
        imagePath = 'assets/error_401.png';
        break;
      case 403:
        title = 'Forbidden';
        description = 'Tidak memiliki akses walau sudah login';
        imagePath = 'assets/error.png';
        break;
      case 404:
        title = 'Something went wrong';
        description = 'Sorry we were unable to find that page';
        imagePath = 'assets/error_404 .png';
        break;
      case 405:
        title = 'Method Not Allowed';
        description = 'Method tidak diizinkan (misalnya POST ke endpoint GET)';
        imagePath = 'assets/error.png';
        break;
      case 408:
        title = 'Request Timeout';
        description = 'Request terlalu lama, client timeout';
        imagePath = 'assets/error.png';
        break;
      case 409:
        title = 'Conflict';
        description = 'Konflik data, seperti mendaftar email yang sudah ada';
        imagePath = 'assets/error.png';
        break;
      case 422:
        title = 'Unprocessable Entity';
        description = 'Data valid tapi gagal diproses (biasanya validasi)';
        imagePath = 'assets/error.png';
        break;
      case 429:
        title = 'Too Many Requests';
        description = 'Terlalu sering request dalam waktu pendek';
        imagePath = 'assets/error.png';
        break;
      case 500:
        title = 'Internal Server Error';
        description = 'Kesalahan di server, biasanya bug pada backend';
        imagePath = 'assets/error.png';
        break;
      case 502:
        title = 'Bad Gateway';
        description = 'Server proxy menerima respon error dari backend';
        imagePath = 'assets/error.png';
        break;
      case 503:
        title = 'Service Unavailable';
        description = 'Server sedang tidak bisa digunakan';
        imagePath = 'assets/error.png';
        break;
      case 504:
        title = 'Gateway Timeout';
        description = 'Server tidak membalas tepat waktu';
        imagePath = 'assets/error.png';
        break;
      default:
        title = 'Error';
        description = 'Terjadi kesalahan';
        imagePath = 'assets/error.png';
    }

    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 140,
                height: 140,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 32),
              Text(
                '$errorCode',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: 180,
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0A3D91),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Go back',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
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
}
