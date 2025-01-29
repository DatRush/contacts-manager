import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flut1/services/api_service.dart';

enum UserRole { owner, viewer }

class AuthModel with ChangeNotifier {
  String _email = '';
  String _password = '';
  String _username = '';
  int? _userId; 
  bool _isLoading = false;
  String? _errorMessage;
  String? _validateMessage;

  String get email => _email;
  String get password => _password;
  String get username => _username;
  int? get userId => _userId; 
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get validateMessage => _validateMessage;

  final ApiService apiService = ApiService('http://192.168.1.85:8080/api');
  Uint8List? _imageBytes;
  // Регулярное выражение для email и пароля
  RegExp emailRegex =
      RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
  RegExp passwordRegex =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$');

  // Новое поле для роли пользователя
  UserRole _role = UserRole.owner; // По умолчанию роль владельца

  UserRole get role => _role;
  Uint8List? get imageBytes => _imageBytes;
  // Метод для установки роли
  void setRole(UserRole role) {
    _role = role;
    notifyListeners();
  }

  void switchToViewer() {
    setRole(UserRole.viewer);
  }

  void setUserId(int userId) {
    _userId = userId;
    notifyListeners();
  }
  // Установка email с проверкой
  void setEmail(String email) {
    _email = email;
    if (!emailRegex.hasMatch(email)) {
      _errorMessage = 'Некорректный формат email';
    } else {
      _errorMessage = null;
    }
    notifyListeners();
  }

  // Установка пароля с проверкой
  void setPassword(String password) {
    _password = password;
    _errorMessage = passwordRegex.hasMatch(password)
        ? null
        : 'Условие пароля: длина 8, цифра, спец. символ';
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
    _errorMessage = null;
    notifyListeners();

    bool success = await apiService.loginUser(
      _username,
      _password,
    );

    if (success) {
      setRole(UserRole.owner);
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
    if (!emailRegex.hasMatch(_email)) {
      _errorMessage = 'Некорректный формат email';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (!passwordRegex.hasMatch(_password)) {
      _errorMessage = 'Условие пароля: длина 8, цифра, спец. символ';
      _isLoading = false;
      notifyListeners();
      return false;
    }
    notifyListeners();

    if (_errorMessage != null) {
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

    // Метод для обновления изображения
  void updateImage(Uint8List bytes) {
    _imageBytes = bytes;
    notifyListeners();
  }
}
