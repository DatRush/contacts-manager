import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback? press;  // Используем VoidCallback? для возможности null
  final Color color, textColor;

  const RoundedButton({
    super.key,
    required this.text,  // Делаем текст обязательным
    this.press,  // press может быть null
    this.color = const Color.fromARGB(255, 28, 128, 123),  // Добавляем значение по умолчанию
    this.textColor = Colors.white,  // Цвет текста по умолчанию
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            backgroundColor: color,  // Указываем цвет кнопки
          ),
          onPressed: press,  // Нажатие кнопки вызывает переданную функцию
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}
