import 'package:flut1/imports.dart';

class LinkPanelWidget extends StatefulWidget {
  final ContactModel contactModel;
  final CardData cardData;
  final bool isOwner;

  const LinkPanelWidget({
    required this.contactModel,
    required this.cardData,
    required this.isOwner,
    super.key,
  });

  @override
  State<LinkPanelWidget> createState() => _LinkPanelWidgetState();
}

class _LinkPanelWidgetState extends State<LinkPanelWidget> {
  final TextEditingController linkController = TextEditingController();
  final TextEditingController infoController = TextEditingController();

  final Map<String, IconData> domainIcons = {
    'web.whatsapp.com': FontAwesomeIcons.whatsapp,
    'x.com': FontAwesomeIcons.twitter,
    'www.instagram.com': FontAwesomeIcons.instagram,
    'github.com': FontAwesomeIcons.github,
    'www.facebook.com': FontAwesomeIcons.facebook,
    'web.telegram.org': FontAwesomeIcons.telegram,
  };

  @override
  void initState() {
    super.initState();
    // Загружаем контакты для текущей карточки
    widget.contactModel.fetchContacts(widget.cardData.id);
  }

  String _determineType(String input) {
    final Uri? uri = Uri.tryParse(input);

    if (input.contains(RegExp(r'^\+?[0-9\s\-]+$'))) {
      return 'phone'; // Номер телефона
    } else if (input.contains(RegExp(r'^[^@]+@[^@]+\.[^@]+'))) {
      return 'email'; // Email
    } else if (uri != null && uri.hasAbsolutePath) {
      return 'url'; // URL
    }

    return 'unknown'; // Неизвестный тип
  }

  Future<void> _launchContact(String type, String value) async {
    String url;
    switch (type) {
      case 'phone':
        url = 'tel:$value';
        break;
      case 'email':
        url = 'mailto:$value';
        break;
      case 'url':
        url = value;
        break;
      default:
        throw 'Неизвестный тип контакта';
    }

    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Не удалось открыть $url';
    }
  }

  IconData _getIconForContact(String type, String value) {
    if (type == 'phone') {
      return Icons.phone;
    } else if (type == 'email') {
      return Icons.alternate_email;
    } else if (type == 'url') {
      Uri uri = Uri.parse(value);
      String? domain = uri.host;
      if (domainIcons.containsKey(domain)) {
        return domainIcons[domain]!;
      }
      return Icons.link;
    }
    return Icons.help;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.isOwner) // Показываем кнопку добавления только владельцу
            Center(
              child: IconButton(
                icon: const Icon(Icons.add, size: 30),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Добавить контакт'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: infoController,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                labelText: 'Информация',
                                hintText: 'Содержимое',
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: linkController,
                              decoration: const InputDecoration(
                                labelText: 'Ссылка, номер или email',
                                hintText:
                                    'https://example.com, +123456789, example@email.com',
                              ),
                              keyboardType: TextInputType.url,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Отмена'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final input = linkController.text;
                              final info = infoController.text;
                              final type = _determineType(input);

                              if (input.isNotEmpty && type != 'unknown') {
                                await widget.contactModel.addContact(
                                  widget.cardData.id,
                                  type,
                                  input,
                                  info,
                                );
                                linkController.clear();
                                infoController.clear();
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text('Добавить'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          const SizedBox(height: 20),
          Consumer<ContactModel>(
            builder: (context, model, child) {
              return model.contacts.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: model.contacts.length,
                      itemBuilder: (context, index) {
                        final contact = model.contacts[index];
                        return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            title: InkWell(
                              onTap: () => _launchContact(
                                  contact.type, contact.value),
                              child: Text(
                                contact.info,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            leading: Container(
                              width: 50,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color(0xFFFF5722), width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                _getIconForContact(
                                    contact.type, contact.value),
                                size: 40,
                              ),
                            ),
                            trailing: widget
                                    .isOwner // Кнопка удаления только для владельца
                                ? IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      widget.contactModel.removeContact(index);
                                    },
                                  )
                                : null,
                          ),
                        );
                      },
                    )
                  : Center(
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TyperAnimatedText(
                            'Список пуст',
                            textStyle: const TextStyle(
                              fontSize: 24.0,
                            ),
                          ),
                        ],
                        totalRepeatCount: 1,
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}
