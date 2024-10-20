import 'package:flutter/material.dart';
import 'dart:typed_data';

class ContactModel with ChangeNotifier {
  final List<Map<String, String>> _contacts = [];
  Uint8List? _imageBytes;

  // Геттер для контактов
  List<Map<String, String>> get contacts => _contacts;

  // Геттер для изображения
  Uint8List? get imageBytes => _imageBytes;

  // Метод для добавления контакта
  void addContact(String type, String value) {
    _contacts.add({'type': type, 'value': value});
    notifyListeners(); // Уведомляем виджеты об изменении состояния
  }

  // Метод для удаления контакта
  void removeContact(int index) {
    _contacts.removeAt(index);
    notifyListeners(); // Уведомляем виджеты об изменении состояния
  }

  // Метод для обновления изображения
  void updateImage(Uint8List bytes) {
    _imageBytes = bytes;
    notifyListeners();
  }
}
