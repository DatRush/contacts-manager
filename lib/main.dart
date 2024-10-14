import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'dart:convert'; 

import 'qr_gen_page.dart';

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
  List<String> links = [];

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Загружаем данные при запуске
  }

  final Map<String, IconData> domainIcons = {
    'web.whatsapp.com': FontAwesomeIcons.whatsapp,
    'x.com': FontAwesomeIcons.twitter,
    'www.instagram.com': FontAwesomeIcons.instagram,
    'github.com': FontAwesomeIcons.github,
    'www.facebook.com': FontAwesomeIcons.facebook,
    'web.telegram.org': FontAwesomeIcons.telegram,
  };

  void _addLink() {
    setState(() {
      final link = linkController.text;
      if (link.isNotEmpty && Uri.tryParse(link)?.hasAbsolutePath == true) {
        links.add(link);
        linkController.clear(); 
      }
    });
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Не удалось открыть $url';
    }
  }

  IconData _getIconForLink(String url) {
    Uri uri = Uri.parse(url);
    String? domain = uri.host;
    
    if (domainIcons.containsKey(domain)) {
      return domainIcons[domain]!;
    }
    
    return Icons.link;
  }

  Future<void> _saveUserData(Uint8List? imageBytes) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  await prefs.setString('userName', nameController.text);
  await prefs.setString('userBio', bioController.text);

  if (imageBytes != null) {
    String base64Image = base64Encode(imageBytes);
    await prefs.setString('userImage', base64Image);
  } else {
    await prefs.remove('userImage'); 
  }
}

  Future<void> _loadUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    nameController.text = prefs.getString('userName') ?? '';
    bioController.text = prefs.getString('userBio') ?? '';

    String? base64Image = prefs.getString('userImage');
    if (base64Image != null) {
      Uint8List imageBytes = base64Decode(base64Image);
      _imageBytes = imageBytes;
    }
  });
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
                maxLines: 3, 
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  _saveUserData(_imageBytes); 
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Данные сохранены')),
                  );
                },
                child: const Text('Сохранить'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: linkController,
                decoration: const InputDecoration(
                  labelText: 'Введите ссылку',
                  hintText: 'https://example.com',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addLink,
                child: const Text('Добавить ссылку'),
              ),
              const SizedBox(height: 20),
              if (links.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true, 
                  physics: const NeverScrollableScrollPhysics(), 
                  itemCount: links.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: InkWell(
                        onTap: () => _launchURL(links[index]),
                        child: Text(
                          links[index],
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      leading: Icon(_getIconForLink(links[index])),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            links.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                )
              else
                const Center(child: Text('Список ссылок пуст')),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QRCodePage()),
          );
        },
        tooltip: 'Сгенерировать QR-код',
        child: const Icon(Icons.qr_code),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
  