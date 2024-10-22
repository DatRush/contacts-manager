import 'package:flutter/material.dart';
import 'package:flut1/services/api_service.dart';

class RegisterScreen extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final ApiService apiService = ApiService();

  void _registerUser(BuildContext context) async {
    bool success = await apiService.registerUser(
      _usernameController.text,
      _passwordController.text,
      _emailController.text,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Регистрация прошла успешно')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка регистрации')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Регистрация')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _usernameController,
                decoration:
                    const InputDecoration(labelText: 'Имя пользователя')),
            TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Пароль'),
                obscureText: true),
            TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () => _registerUser(context),
                child: const Text('Зарегистрироваться')),
          ],
        ),
      ),
    );
  }
}
