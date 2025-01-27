import 'package:flut1/screens/Main/mainpage.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сканировать QR-код')),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      // Извлекаем ID карточки из QR-кода
      final String scannedData = scanData.code ?? '';

      // Преобразуем в int
      final int? cardId = int.tryParse(scannedData);

      if (cardId != null) {
        // Если удалось преобразовать в ID, переходим на экран карточки
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(scannedCardId: cardId),
          ),
        );
      } else {
        // Если данные некорректны, показываем ошибку
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Неверный QR-код')),
        );
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

