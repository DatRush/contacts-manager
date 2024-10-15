import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

import 'qr_gen_page.dart';
import 'qr_scan_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Link Saver',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController linkController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  Uint8List? _imageBytes;
  List<Map<String, String>> contacts = [];

  @override
  void initState() {
    super.initState();
  }

  final Map<String, IconData> domainIcons = {
    'web.whatsapp.com': FontAwesomeIcons.whatsapp,
    'x.com': FontAwesomeIcons.twitter,
    'www.instagram.com': FontAwesomeIcons.instagram,
    'github.com': FontAwesomeIcons.github,
    'www.facebook.com': FontAwesomeIcons.facebook,
    'web.telegram.org': FontAwesomeIcons.telegram,
  };

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

  void _addContact() {
    setState(() {
      final input = linkController.text;
      final type = _determineType(input); // Определить тип контакта

      if (input.isNotEmpty && type != 'unknown') {
        contacts.add({'type': type, 'value': input});
        linkController.clear(); 
      }
    });
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

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final Uint8List bytes = await pickedFile.readAsBytes(); // Read image as bytes
      setState(() {
        _imageBytes = bytes; // Store image bytes
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TEst'),
        centerTitle: true,
      ),
      body: SingleChildScrollView( 
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: pickImage, 
                child: CircleAvatar(
                  radius: 50, 
                  backgroundColor: Colors.grey[300], 
                  backgroundImage: _imageBytes != null
                      ? MemoryImage(_imageBytes!) 
                      : null, 
                  child: _imageBytes == null
                      ? const Icon(
                        Icons.person, 
                        size: 50,
                        color: Colors.white,
                    )
                  : null, 
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Имя',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: bioController,
                decoration: const InputDecoration(
                  labelText: 'Краткая биография',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2, 
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
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addContact,
                child: const Text('Добавить'),
              ),
              const SizedBox(height: 20),
              if (contacts.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true, 
                  physics: const NeverScrollableScrollPhysics(), 
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return ListTile(
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
                          setState(() {
                            contacts.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                )
              else
                const Center(child: Text('Список пуст')),
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
                      Navigator.pop(context); // Закрываем BottomSheet
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const QRScanPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.qr_code),
                    title: const Text('Сгенерировать QR-код'),
                    onTap: () {
                      Navigator.pop(context); // Закрываем BottomSheet
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const QRCodePage()),
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
  