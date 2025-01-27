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
    print("checking");
    await _post('/users/register', body);
    print("completed");
    return true; // Если дошли сюда, запрос успешен
  }

  // Авторизация пользователя
  Future<bool> loginUser(String username, String password) async {
    final body = {'username': username, 'password': password};
    await _post('/users/login', body);
    return true;
  }

  // Получение всех визиток
  Future<List<CardData>> fetchCards() async {
    final data = await _get('/api/cards');
    return (data as List).map((card) => CardData.fromJson(card)).toList();
  }

  // Получение визитки по ID
  Future<CardData> fetchCardById(int id) async {
    final data = await _get('/api/cards/$id');
    return CardData.fromJson(data);
  }

  // Создание визитки
  Future<int> createCard(String ownerName, String cardTitle) async {
    final body = {'owner': ownerName, 'title': cardTitle};
    final data = await _post('/api/cards/', body);
    return data['id']; // Возвращаем ID карточки
  }

  // Обновление визитки
  Future<CardData> updateCard(int id, CardData updatedCard) async {
    final data = await _put('/api/cards/$id', updatedCard.toJson());
    return CardData.fromJson(data);
  }

  // Удаление визитки
  Future<void> deleteCard(int id) async {
    await _delete('/api/cards/$id');
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
