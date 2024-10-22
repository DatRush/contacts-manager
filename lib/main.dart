import 'package:flut1/screens/Welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/Main/contact_model.dart';
import 'screens/Signup/signup_screen.dart';  
import 'screens/Login/login_screen.dart';    

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
        useMaterial3: true,
      ),
      initialRoute: '/', 
      routes: {
        '/': (context) => WelcomeScreen(),  
        '/login': (context) => LoginScreen(),  
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}
