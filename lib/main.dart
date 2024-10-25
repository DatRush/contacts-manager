import 'package:flut1/screens/Login/login_screen.dart';
import 'package:flut1/screens/Register/register_screen.dart';
import 'package:flut1/screens/Welcome/welcome_screen.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flut1/providers/contact_model.dart';
import 'package:flut1/providers/auth_model.dart'; 

void main() {
  runApp(
    MultiProvider( // Изменяем на MultiProvider для поддержки нескольких провайдеров
      providers: [
        ChangeNotifierProvider(create: (_) => ContactModel()), // Модель для контактов
        ChangeNotifierProvider(create: (_) => AuthModel()), // Модель для авторизации
      ],
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
        useMaterial3: true,
      ),
      initialRoute: '/', 
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => LoginScreen(),  
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}
