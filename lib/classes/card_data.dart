// ignore_for_file: non_constant_identifier_names

class CardData {
  final int id; // Убедитесь, что тип id — int
  final String name;
  final String description;
  final String company_name;
  final String company_address;
  final String position;
  final int user_id;
  final String avatar_url;

  CardData({
    required this.id,
    required this.name,
    required this.description,
    required this.company_name,
    required this.company_address,
    required this.position,
    required this.user_id,
    required this.avatar_url,
  });

  // Метод для преобразования в JSON (без id для POST-запросов)
  Map<String, dynamic> toJson({bool includeId = false}) {
    final data = {
      'name': name,
      'description': description,        
      'company_name': company_name,
      'company_address': company_address,
      'position': position,
      'user_id': user_id, // <-- обязательно добавляем
      'avatar_url': avatar_url,   
    };
    if (includeId) {
      data['id'] = id;
    }
    return data;
  }

  // Создание из JSON при получении данных из базы
  factory CardData.fromJson(Map<String, dynamic> json) {
    return CardData(
      id: json['id'] ?? 0, // Защита от null
      name: json['name'] ?? '',
      description: json['description'] ?? '',      
      company_name: json['company_name'] ?? '',
      company_address: json['company_address'] ?? '',
      position: json['position'] ?? '',
      avatar_url: json['avatar_url'] ?? '',
      user_id: json['user_id'] ?? 0, // Защита от null
    );
  }
}

class ContactData {
  final int id; // Уникальный идентификатор контакта
  final String name;
  final String description;
  final String url;
  final int card_id; 

  ContactData({
    required this.id,
    required this.name,
    required this.description,
    required this.url,
    required this.card_id,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'url': url,
        'card_id': card_id,
      };

  factory ContactData.fromJson(Map<String, dynamic> json) {
    return ContactData(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      url: json['url'],
      card_id: json['card_id'],
    );
  }
}
