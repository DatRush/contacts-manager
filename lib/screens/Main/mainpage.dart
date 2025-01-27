import 'package:flut1/imports.dart';

class MyHomePage extends StatelessWidget {
  final int? scannedCardId; // ID карточки, полученный через QR-код

  const MyHomePage({super.key, this.scannedCardId});

  @override
  Widget build(BuildContext context) {
    final apiService = context.read<ApiService>();
    final currentUserId = context.read<AuthModel>().userId;

    return FutureBuilder(
      future: apiService.fetchCards(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Ошибка: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final cardDataList = snapshot.data as List<CardData>;

          if (cardDataList.isEmpty) {
            return const Center(child: Text('Нет данных'));
          }

          // Если есть ID карточки из QR-кода, используем его
          final cardData = scannedCardId != null
              ? cardDataList.firstWhere(
                  (card) => card.id == scannedCardId,
                )
              : cardDataList.firstWhere(
                  (card) => card.id == currentUserId,
                );

          final isOwner = currentUserId == cardData.id;

          return MyHomePageContent(cardData: cardData, isOwner: isOwner);
        } else {
          return const Center(child: Text('Нет данных'));
        }
      },
    );
  }
}


class MyHomePageContent extends StatelessWidget {
  final CardData cardData;
  final bool isOwner;
  const MyHomePageContent(
      {required this.cardData, required this.isOwner, super.key});

  @override
  Widget build(BuildContext context) {
    final contactModel = context.read<ContactModel>();
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // Широкий экран: два столбца
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: ProfileWidget(cardData: cardData, isOwner: isOwner),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: LinkPanelWidget(
                      contactModel: contactModel,
                      cardData: cardData,
                      isOwner: isOwner),
                ),
              ],
            );
          } else {
            // Узкий экран: только левый столбец и кнопка для открытия боковой панели
            return Stack(
              children: [
                ProfileWidget(cardData: cardData, isOwner: isOwner),
                Positioned(
                  top: 48,
                  right: 16,
                  child: Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.chrome_reader_mode, size: 30),
                      tooltip: 'Открыть меню',
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                    ),
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
            return Drawer(
              child: LinkPanelWidget(
                contactModel: contactModel,
                cardData: cardData,
                isOwner: isOwner,
              ),
            );
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
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  QRScanPage(),
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
                                  QRCodePage(cardId: cardData.id),
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
