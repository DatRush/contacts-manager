import 'package:flut1/screens/Main/components/profile.dart';
import 'package:flutter/material.dart';
import 'package:flut1/screens/Main/components/qr_gen.dart';

import 'components/linkpanel.dart';
import 'components/qr_scan.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 1, child: ProfileWidget()),
                SizedBox(width: 16),
                Expanded(flex: 2, child: LinkPanelWidget()),
              ],
            );
          } else {
            return Stack(
              children: [
                const ProfileWidget(),
                Positioned(
                  top: 48,
                  right: 16,
                  child: IconButton(
                    icon: const Icon(Icons.chrome_reader_mode),
                    tooltip: 'Открыть меню',
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
              ],
            );
          }
        },
      ),
      endDrawer: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth <= 600) {
            return const Drawer(child: LinkPanelWidget());
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.qr_code_scanner),
                    title: const Text('Сканировать QR-код'),
                    onTap: () {
                      Navigator.pop(context);
                      // Навигация на экран сканирования QR-кода
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QRScanPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.qr_code),
                    title: const Text('Сгенерировать QR-код'),
                    onTap: () {
                      Navigator.pop(context);
                      // Передача userId и переход на страницу генерации QR-кода
                      String userId = 'user123';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRCodePage(userId: userId),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Действия с QR-кодами',
        child: const Icon(Icons.qr_code),
      ),
    );
  }
}