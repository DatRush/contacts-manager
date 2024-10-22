import 'package:flutter/material.dart';

class AuthModel with ChangeNotifier {
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  String? _errorMessage;
  String? _validateMessage;

  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get validateMessage => _validateMessage;

  // Регулярное выражение для email и пароля
  RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
  RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$');

  // Установка email с проверкой
  void setEmail(String email) {
    _email = email;
    if (!emailRegex.hasMatch(email)) {
      _validateMessage = 'Некорректный формат email';
    } else {
      _validateMessage = null;
    }
    notifyListeners();
  }

  // Установка пароля с проверкой
  void setPassword(String password) {
    _password = password;
    if (!passwordRegex.hasMatch(password)) {
      _validateMessage = 'Условие пароля: длина 8, цифра, спец. символ';
    } else {
      _validateMessage = null;
    }
    notifyListeners();
  }

  // Логин
  Future<void> login() async {
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(const Duration(seconds: 2)); // Симуляция запроса

    // Пример успешного входа
    if (_email == 'test@test.com' && _password == 'Password@123') {
      _errorMessage = null; // Сброс ошибки
    } else {
      _errorMessage = 'Неверный email или пароль';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Регистрация
  Future<void> signUp() async {
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(const Duration(seconds: 2)); // Симуляция запроса

    // Валидация email и пароля при регистрации
    if (emailRegex.hasMatch(_email) && passwordRegex.hasMatch(_password)) {
      _errorMessage = null; // Успешная регистрация
    } else {
      if (!emailRegex.hasMatch(_email)) {
        _errorMessage = 'Некорректный email';
      }
      if (!passwordRegex.hasMatch(_password)) {
        _errorMessage = 'Некорректный пароль';
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  // Сброс ошибок
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
