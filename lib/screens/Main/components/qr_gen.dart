import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;

class QRCodePage extends StatefulWidget {
  final String userId;

  const QRCodePage({Key? key, required this.userId}) : super(key: key);

  @override
  _QRCodePageState createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  late Future<String> qrCodeUrl;

  Future<String> fetchQRCodeUrl() async {
    final String backendUrl =
        'http://localhost:8081/api/qrcode/${widget.userId}';
    try {
      final response = await http.get(Uri.parse(backendUrl));

      if (response.statusCode == 200) {
        return backendUrl;
      } else {
        throw Exception('Ошибка при загрузке QR-кода: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка сети: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    qrCodeUrl = fetchQRCodeUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR-код для профиля')),
      body: Center(
        child: FutureBuilder<String>(
          future: qrCodeUrl,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 50),
                  const SizedBox(height: 10),
                  Text('Ошибка: ${snapshot.error}',
                      textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        qrCodeUrl = fetchQRCodeUrl();
                      });
                    },
                    child: const Text('Повторить'),
                  ),
                ],
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QrImageView(
                    data: snapshot.data!,
                    version: QrVersions.auto,
                    size: 200.0,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  Text('QR-код для профиля пользователя: ${widget.userId}'),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}