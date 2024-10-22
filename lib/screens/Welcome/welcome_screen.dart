import 'package:flut1/screens/Welcome/components/body.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Body(),  // Сохраняем основной виджет
          const SizedBox(height: 20),  // Отступ между контентом и кнопками
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            child: const Text('Вход'),
          ),
          const SizedBox(height: 10),  // Отступ между кнопками
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/register'),
            child: const Text('Регистрация'),
          ),
        ],
      ),
    );
  }
}
