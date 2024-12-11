import 'package:flutter/material.dart';

class AdaptiveUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Определяем размер экрана
    final isWideScreen = MediaQuery.of(context).size.width > 600; // Для веб или планшета
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isWideScreen
            ? _buildWideScreen(context) // Виджет для веб
            : _buildNarrowScreen(context), // Виджет для телефона
      ),
    );
  }

  // Столбцы для широких экранов (веб)
  Widget _buildWideScreen(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: _buildLeftColumn(context),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: _buildRightColumn(context),
        ),
      ],
    );
  }

  // Список ссылок в виде выезжающей панели для телефонов
  Widget _buildNarrowScreen(BuildContext context) {
    return Stack(
      children: [
        // Левый столбец
        _buildLeftColumn(context),
        // Кнопка для показа панели
        Positioned(
          right: 16,
          top: 100,
          child: FloatingActionButton(
            onPressed: () {
              _showLinkPanel(context);
            },
            child: const Icon(Icons.list),
          ),
        ),
      ],
    );
  }

  // Левый столбец с фото и данными
  Widget _buildLeftColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            // Действие при выборе фото
          },
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/profile_placeholder.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const TextField(
          decoration: InputDecoration(
            hintText: 'Введите имя',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        const TextField(
          decoration: InputDecoration(
            hintText: 'Введите должность',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Правый столбец (список ссылок)
  Widget _buildRightColumn(BuildContext context) {
    return ListView(
      children: List.generate(
        10,
        (index) => Card(
          child: ListTile(
            leading: const Icon(Icons.link),
            title: Text('Ссылка $index'),
            onTap: () {
              // Открыть ссылку
            },
          ),
        ),
      ),
    );
  }

  // Выезжающая панель с ссылками
  void _showLinkPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: List.generate(
            10,
            (index) => ListTile(
              leading: const Icon(Icons.link),
              title: Text('Ссылка $index'),
              onTap: () {
                Navigator.pop(context); // Закрыть панель
              },
            ),
          ),
        );
      },
    );
  }
}
