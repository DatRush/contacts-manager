import 'package:flut1/imports.dart';

class ContactModel with ChangeNotifier {
  final List<ContactData> _contacts = []; // Используем модель ContactData
  final ApiService apiService;

  ContactModel(this.apiService);

  // Геттер для списка контактов
  List<ContactData> get contacts => _contacts;

  // Метод для загрузки контактов из API
  Future<void> fetchContacts(int cardId) async {
    try {
      final response = await apiService.fetchContacts(cardId);
      _contacts.clear();
      _contacts.addAll(response.map((data) => ContactData.fromJson(data)).toList());
      notifyListeners();
    } catch (e) {
      print('Ошибка загрузки контактов: $e');
    }
  }

  // Метод для добавления контакта
  Future<void> addContact(int cardId, String type, String value, String info) async {
    final contactData = {'name': type, 'url': value, 'description': info};

    // Отправляем данные на сервер и получаем добавленный контакт
    final savedContact = await apiService.addContact(cardId, contactData);

    // Если успешно, добавляем локально
    _contacts.add(ContactData.fromJson(savedContact));
    notifyListeners();
  }

  // Метод для удаления контакта
  Future<void> removeContact(int contactId) async {
    // Удаляем контакт на сервере
    await apiService.deleteContact(contactId);

    // Удаляем контакт локально
    _contacts.removeWhere((contact) => contact.id == contactId);
    notifyListeners();
  }
}
