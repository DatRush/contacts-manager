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

  final Map<String, IconData> domainIcons = {
    'web.whatsapp.com': FontAwesomeIcons.whatsapp,
    'x.com': FontAwesomeIcons.twitter,
    'www.instagram.com': FontAwesomeIcons.instagram,
    'github.com': FontAwesomeIcons.github,
    'www.facebook.com': FontAwesomeIcons.facebook,
    'web.telegram.org': FontAwesomeIcons.telegram,
  };

  void _addContact() {
    final input = linkController.text;
    final type = _determineType(input);
    if (input.isNotEmpty && type != 'unknown') {
      Provider.of<ContactModel>(context, listen: false).addContact(type, input);
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => pickImage(context),
                child: Consumer<ContactModel>(
                  builder: (context, model, child) {
                    return CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: model.imageBytes != null
                          ? MemoryImage(model.imageBytes!)
                          : null,
                      child: model.imageBytes == null
                          ? const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white,
                            )
                          : null,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Строка с линией и полем для имени
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 3, // Толщина линии
                    height: 40, // Высота линии, можно настроить
                    color: const Color.fromARGB(255, 39, 57, 160),
                    margin: const EdgeInsets.only(right: 8.0), // Отступ между линией и полем
                  ),
                  Expanded(
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Имя',
                        border: InputBorder.none,
                        isDense: true, // Уменьшение высоты
                        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Строка с линией и полем для биографии
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 3, // Толщина линии
                    height: 40, // Высота линии, можно настроить
                    color: Color.fromARGB(255, 39, 57, 160),
                    margin: const EdgeInsets.only(right: 8.0), // Отступ между линией и полем
                  ),
                  Expanded(
                    child: TextField(
                      controller: bioController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Био',
                        isDense: true, // Уменьшение высоты
                        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      ),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              TextField(
                controller: linkController,
                decoration: const InputDecoration(
                  labelText: 'Введите ссылку, номер телефона или email',
                  hintText: 'https://example.com, +123456789, example@email.com',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
                onSubmitted: (value) {
                  _addContact();
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addContact,
                child: const Text('Добавить'),
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
                                    contact['value']!,
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                leading: Icon(_getIconForContact(contact['type']!, contact['value']!)),
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
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                            totalRepeatCount: 1, // Однократное повторение анимации
                          ),
                        );
                },
              ),
            ],
          ),
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
