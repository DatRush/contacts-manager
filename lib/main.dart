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
      theme: ThemeData.dark().copyWith(
        // Основной фон
        scaffoldBackgroundColor: const Color(0xFF121212), // Угольный чёрный фон
        primaryColor: const Color(0xFF1A1A40), // Глубокий тёмно-фиолетовый

        // Карточки
        cardColor: const Color(0xFF23232E), // Чуть светлее для карточек

        // Цветовая тема текста
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Color(0xFFECEFF1), // Светло-бежевый текст
          ),
          bodyMedium: TextStyle(
            color: Color(0xFFB0BEC5), // Нейтральный серо-голубой текст
          ),
          headlineSmall: TextStyle(
            color: Color(0xFFFFC107), // Золотистый для заголовков
            fontWeight: FontWeight.bold,
          ),
        ),

        // Иконки
        iconTheme: const IconThemeData(
          color: Color(0xFFFF5722), // Сочный оранжево-розовый для иконок
        ),

        // Кнопки
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF607D8B), // Серо-голубой фон кнопок
            foregroundColor: Colors.white, // Белый текст на кнопках
          ),
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF607D8B), // Фон для всех FAB
          foregroundColor: Colors.white, // Цвет иконок
          elevation: 6.0, // Высота тени
        ),

        // Поля ввода
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF23232E), // Темный фон полей ввода
          labelStyle: TextStyle(
            color: Color(0xFFFFC107), // Золотистая подсказка
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFF5722)), // Оранжево-розовая рамка
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFFC107)), // Золотистая рамка при фокусе
          ),
        ),

        // Диалоги
        dialogBackgroundColor: const Color(0xFF23232E), // Темный фон всплывающих окон

        // Используем Material Design 3
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
