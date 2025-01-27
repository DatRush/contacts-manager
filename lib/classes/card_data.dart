class CardData {
  final int id; // Убедитесь, что тип id — int
  final String name;
  final String bio;
  final String position;
  final String companyName;
  final String address;
  final List<ContactData> contacts;

  CardData({
    required this.id,
    required this.name,
    required this.bio,
    required this.position,
    required this.companyName,
    required this.address,
    required this.contacts,
  });

  // Метод для преобразования в JSON для отправки в базу
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'bio': bio,
        'position': position,
        'company_name': companyName,
        'address': address,
        'contacts': contacts.map((contact) => contact.toJson()).toList(),
      };

  // Создание из JSON при получении данных из базы
  factory CardData.fromJson(Map<String, dynamic> json) {
    return CardData(
      id: json['id'],
      name: json['name'] ?? '',
      bio: json['bio'] ?? '',
      position: json['position'] ?? '',
      companyName: json['company_name'] ?? '',
      address: json['address'] ?? '',
      contacts: (json['contacts'] ?? '' as List)
          .map((contact) => ContactData.fromJson(contact))
          .toList(),
    );
  }
}

class ContactData {
  final int id; // Уникальный идентификатор контакта
  final String type;
  final String value;
  final String info;

  ContactData({
    required this.id,
    required this.type,
    required this.value,
    required this.info,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'value': value,
        'info': info,
      };

  factory ContactData.fromJson(Map<String, dynamic> json) {
    return ContactData(
      id: json['id'],
      type: json['type'],
      value: json['value'],
      info: json['info'],
    );
  }
}
