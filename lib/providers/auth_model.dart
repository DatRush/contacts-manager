import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flut1/services/api_service.dart';

enum UserRole { owner, viewer }

class AuthModel with ChangeNotifier {
  String _email = '';
  String _password = '';
  String _username = '';
  int? _userId;
  int? _cardId; // Добавили хранение cardId
  bool _isLoading = false;
  String? _errorMessage;
  String? _validateMessage;

  String get email => _email;
  String get password => _password;
  String get username => _username;
  int? get userId => _userId;
  int? get cardId => _cardId; // Геттер для cardId
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get validateMessage => _validateMessage;

  final ApiService apiService = ApiService('http://10.201.5.216:8080/api');
  Uint8List? _imageBytes;

  RegExp emailRegex =
      RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
  RegExp passwordRegex =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$');

  UserRole _role = UserRole.owner;

  UserRole get role => _role;
  Uint8List? get imageBytes => _imageBytes;

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

  void setCardId(int cardId) {
    _cardId = cardId;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    _errorMessage = emailRegex.hasMatch(email) ? null : 'Некорректный формат email';
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    _errorMessage = passwordRegex.hasMatch(password) ? null : 'Пароль должен содержать 8 символов, цифру и спецсимвол';
    notifyListeners();
  }

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  // Логин с обработкой user_id и card_id
  Future<bool> login() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    bool success = await apiService.loginUser(_username, _password);

    if (success) {
      setRole(UserRole.owner);
      notifyListeners();
    } else {
      _errorMessage = 'Неверные учетные данные';
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  // Регистрация без лишних проверок
  Future<bool> signUp() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    bool success = await apiService.registerUser(_username, _password, _email);

    if (!success) {
      _errorMessage = 'Ошибка регистрации';
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void updateImage(Uint8List bytes) {
    _imageBytes = bytes;
    notifyListeners();
  }
}

