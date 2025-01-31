import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flut1/classes/card_data.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  // Универсальный метод для обработки заголовков
  Map<String, String> _defaultHeaders() {
    return {'Content-Type': 'application/json'};
  }

  // Метод для отправки GET-запросов
  Future<dynamic> _get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl$endpoint'),
        headers: _defaultHeaders());
    return _processResponse(response);
  }

  // Метод для отправки POST-запросов
  Future<dynamic> _post(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: _defaultHeaders(),
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  // Метод для отправки PUT-запросов
  Future<dynamic> _put(String endpoint, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: _defaultHeaders(),
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  // Метод для отправки DELETE-запросов
  Future<void> _delete(String endpoint) async {
    final response = await http.delete(Uri.parse('$baseUrl$endpoint'),
        headers: _defaultHeaders());
    _processResponse(response);
  }

  // Обработка ответа сервера
  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body.isNotEmpty ? jsonDecode(response.body) : null;
    } else {
      throw Exception('Ошибка HTTP: ${response.statusCode}, ${response.body}');
    }
  }

  // Регистрация пользователя
  Future<bool> registerUser(
      String username, String password, String email) async {
    final body = {'username': username, 'password': password, 'email': email};

    // Отправляем запрос на регистрацию пользователя
    final userData = await _post('/users/register', body);

    if (userData == null ||
        !userData.containsKey('user_id') ||
        !userData.containsKey('card_id')) {
      throw Exception(
          'Ошибка: user_id или card_id отсутствует в ответе сервера');
    }

    return true;
  }

  // Авторизация пользователя
Future<bool> loginUser(String username, String password) async {
  final body = {'username': username, 'password': password};

  final userData = await _post('/users/login', body);

  if (userData == null || !userData.containsKey('user_id')) {
    throw Exception('Ошибка: user_id отсутствует в ответе сервера');
  }

  return true; // Теперь Flutter получает user_id и card_id
}


  // Получение всех визиток
  Future<List<CardData>> fetchCards() async {
    try {
      final data = await _get('/cards');
      
      if (data == null || data.isEmpty) {
        return []; // Возвращаем пустой список, если нет данных
      }
      return (data as List).map((card) => CardData.fromJson(card)).toList();
    } catch (e) {
      throw Exception('Ошибка при загрузке карточек: $e');
    }
  }

  // Получение визитки по ID
Future<CardData?> fetchCardById(int userId) async {
  try {
    final data = await _get('/cards/$userId');
    if (data == null) {
      print('❌ Карточка не найдена для userId: $userId');
      return null; // Вернем null вместо ошибки
    }
    return CardData.fromJson(data);
  } catch (e) {
    print('❌ Ошибка при получении карточки: $e');
    return null;
  }
}


  // Обновление визитки
  Future<CardData> updateCard(int id, CardData updatedCard) async {
    final data = await _put('/cards/$id', updatedCard.toJson());
    return CardData.fromJson(data);
  }

  // Удаление визитки
  Future<void> deleteCard(int id) async {
    await _delete(' /cards/$id');
  }

  // Добавление нового контакта
  Future<Map<String, dynamic>> addContact(
      int cardId, Map<String, String> contact) async {
    final url = Uri.parse('$baseUrl/cards/$cardId/contacts/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(contact),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body); // Возвращаем созданный контакт
    } else {
      throw Exception('Ошибка при добавлении контакта: ${response.body}');
    }
  }

  // Загрузка контактов для карточки
  Future<List<Map<String, dynamic>>> fetchContacts(int cardId) async {
    final data = await _get('/cards/$cardId/contacts/');
    return List<Map<String, dynamic>>.from(data);
  }

  // Удаление контакта
  Future<void> deleteContact(int contactId) async {
    final url = Uri.parse('$baseUrl/contacts/$contactId/');
    final response =
        await http.delete(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode != 200) {
      throw Exception('Ошибка при удалении контакта: ${response.body}');
    }
  }
}
