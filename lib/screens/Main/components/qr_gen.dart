import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodePage extends StatelessWidget {
  const QRCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    const String homepageUrl = 'http://localhost:64785/'; 

    return Scaffold(
      appBar: AppBar(title: const Text('QR-код для главной страницы')),
      body: Center(
        child: QrImageView(
          data: homepageUrl, 
          version: QrVersions.auto,
          size: 200.0,
          backgroundColor: Colors.white, 
        ),
      ),
    );
  }
}
