import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flut1/providers/contact_model.dart';
import 'qr_gen_page.dart';
import 'qr_scan_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController linkController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController infoController = TextEditingController(); 
  final TextEditingController positionController = TextEditingController(); 
  final TextEditingController organizationController = TextEditingController();

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode positionFocusNode = FocusNode();

  bool showPositionField = false;

  @override
  void initState() {
    super.initState();
    nameFocusNode.addListener(_handleFocusChange);
    positionFocusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (nameFocusNode.hasFocus) {
      setState(() {
        showPositionField = true; // Показать поле должности при фокусе на поле имени
      });
    } else if (!positionFocusNode.hasFocus && positionController.text.isEmpty) {
      setState(() {
        showPositionField = false; // Скрыть поле, если оно пусто и не в фокусе
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    positionController.dispose();
    nameFocusNode.dispose();
    positionFocusNode.dispose();
    super.dispose();
  }

  final Map<String, IconData> domainIcons = {
    'web.whatsapp.com': FontAwesomeIcons.whatsapp,
    'x.com': FontAwesomeIcons.twitter,
    'www.instagram.com': FontAwesomeIcons.instagram,
    'github.com': FontAwesomeIcons.github,
    'www.facebook.com': FontAwesomeIcons.facebook,
    'web.telegram.org': FontAwesomeIcons.telegram,
  };

  void _addContact() {
    final info = infoController.text;
    final input = linkController.text;
    final type = _determineType(input);
    if (input.isNotEmpty && type != 'unknown') {
      Provider.of<ContactModel>(context, listen: false).addContact(type, input, info);
      infoController.clear();
      linkController.clear();
    }
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
      return Icons.email;
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

  Future<void> pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final Uint8List bytes = await pickedFile.readAsBytes();
      Provider.of<ContactModel>(context, listen: false).updateImage(bytes); // Обновляем изображение
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ЛЕВЫЙ СТОЛБЕЦ
            Expanded(
              flex: 1,
              child: Card(
                elevation: 4,
                margin: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Фото
                      Center(
                        child: GestureDetector(
                          onTap: () => pickImage(context),
                          child: Consumer<ContactModel>(
                            builder: (context, model, child) {
                              return Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  image: model.imageBytes != null
                                      ? DecorationImage(
                                          image: MemoryImage(model.imageBytes!),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                  border: Border.all(width: 2),
                                  borderRadius: BorderRadius.circular(75),
                                ),
                                child: model.imageBytes == null
                                    ? const Center(
                                        child: Icon(Icons.person, size: 50),
                                      )
                                    : null,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      TextField(
                        controller: nameController,
                        focusNode: nameFocusNode,
                        decoration: const InputDecoration(
                          hintText: 'Введите имя',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        ),
                      ),
                      // Анимация появления поля должности
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.decelerate,
                        height: showPositionField ? 60 : 0, // Управляем высотой
                        child: ClipRect(
                          child: Align(
                            alignment: Alignment.topCenter,
                            heightFactor: showPositionField ? 1.0 : 0.0, // Высота раскрытия
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: TextField(
                                controller: positionController,
                                focusNode: positionFocusNode,
                                decoration: const InputDecoration(
                                  hintText: 'Введите должность',
                                  border: OutlineInputBorder(
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Био
                      TextField(
                        controller: bioController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          hintText: 'Введите краткое описание',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Кнопка сохранения
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                          },
                          icon: const Icon(Icons.save),
                          label: const Text('Сохранить'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // ПРАВЫЙ СТОЛБЕЦ
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                        hintText: 'https://example.com, +123456789, example@email.com',
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
                                    onPressed: () {
                                      _addContact();
                                      Navigator.of(context).pop();
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
                                        onTap: () => _launchContact(contact['type']!, contact['value']!),
                                        child: Text(
                                          contact['info']!,
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
                                          border: Border.all(color: const Color(0xFFFF5722), width: 1),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        alignment: Alignment.center,
                                        child: Icon(
                                          _getIconForContact(contact['type']!, contact['value']!),
                                          size: 40,
                                        ),
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          Provider.of<ContactModel>(context, listen: false).removeContact(index);
                                        },
                                      ),
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
              ),
            ),
          ],
        ),
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
                          pageBuilder: (context, animation, secondaryAnimation) => const QRScanPage(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(position: offsetAnimation, child: child);
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
                          pageBuilder: (context, animation, secondaryAnimation) => const QRCodePage(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(position: offsetAnimation, child: child);
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
