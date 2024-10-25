import 'package:flutter/material.dart';
import 'package:flut1/services/api_service.dart';

class AuthModel with ChangeNotifier {
  String _email = '';
  String _password = '';
  String _username = '';
  bool _isLoading = false;
  String? _errorMessage;
  String? _validateMessage;

  String get email => _email;
  String get password => _password;
  String get username => _username;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get validateMessage => _validateMessage;

  final ApiService apiService = ApiService();

  // Регулярное выражение для email и пароля
  RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
  RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$');

  // Установка email с проверкой
  void setEmail(String email) {
    _email = email;
    _validateMessage = emailRegex.hasMatch(email) ? null : 'Некорректный формат email';
    notifyListeners();
  }

  // Установка пароля с проверкой
  void setPassword(String password) {
    _password = password;
    _validateMessage = passwordRegex.hasMatch(password) ? null : 'Условие пароля: длина 8, цифра, спец. символ';
    notifyListeners();
  }

  // Установка имени пользователя
  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  // Логин
  Future<bool> login() async {
    _isLoading = true;
    notifyListeners();

    bool success = await apiService.loginUser(
      _username,
      _password,
    );

    if (success) {
      _username = '';
      _password = '';
      notifyListeners();
    } else {
      _errorMessage = 'Неверные учетные данные';
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  // Регистрация
  Future<bool> signUp() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (_validateMessage != null) {
      _isLoading = false;
      return false;
    }

    bool success = await apiService.registerUser(
      _username,
      _password,
      _email,
    );

    if (success) {
      _username = '';
      _password = '';
      _email = '';
      notifyListeners();
    } else {
      _errorMessage = 'Ошибка регистрации';
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  // Сброс ошибок
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
