import 'package:flutter/material.dart';
import 'package:flut1/screens/Login/components/body.dart';

import 'package:flut1/services/api_service.dart';

class LoginScreen extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiService apiService = ApiService();

  LoginScreen({super.key});

  void _loginUser(BuildContext context) async {
    bool success = await apiService.loginUser(
      _usernameController.text,
      _passwordController.text,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Вход выполнен успешно')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Неверные учетные данные')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вход')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Имя пользователя')),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Пароль'), obscureText: true),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => _loginUser(context), child: const Text('Войти')),
          ],
        ),
      ),
    );
  }
}
