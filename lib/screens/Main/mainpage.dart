import 'package:flut1/imports.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // Широкий экран: два столбца
            return const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: ProfileWidget(),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: LinkPanelWidget(),
                ),
              ],
            );
          } else {
            // Узкий экран: только левый столбец и кнопка для открытия боковой панели
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
            return const Drawer(
              child: LinkPanelWidget(),
            );
          }
          return const SizedBox
              .shrink();
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
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const QRScanPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                                position: offsetAnimation, child: child);
                          },
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.qr_code),
                    title: const Text('Сгенерировать QR-код'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const QRCodePage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                                position: offsetAnimation, child: child);
                          },
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
