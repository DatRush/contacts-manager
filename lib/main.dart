import 'package:flut1/screens/Welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'screens/Main/contact_model.dart';
import 'screens/Main/qr_gen_page.dart';
import 'screens/Main/qr_scan_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ContactModel(), 
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test01',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 20, 90, 124),
        scaffoldBackgroundColor: const Color.fromARGB(255, 235, 234, 234),
        useMaterial3: true,),
      home: WelcomeScreen(),
      // title: 'Link Saver',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      // home: const MyHomePage(),
    );
  }
}
  