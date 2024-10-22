import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flut1/components/already_haa_check.dart';
import 'package:flut1/components/rounded_button.dart';
import 'package:flut1/components/rounded_input_field.dart';
import 'package:flut1/components/rounded_password_field.dart';

import 'package:flut1/screens/Login/login_screen.dart';
import 'package:flut1/screens/Main/mainpage.dart';
import 'package:flut1/screens/Signup/components/ordivider.dart';
import 'package:flut1/screens/Signup/components/socalicon.dart';
import 'package:flut1/screens/Signup/components/background.dart';

import 'package:flut1/providers/auth_model.dart';


class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthModel>(context); // Получаем доступ к AuthProvider
    Size size = MediaQuery.of(context).size;

    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'SIGNUP',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size.height * 0.03),
          SvgPicture.asset(
            'assets/pictures/placeholder.svg',
            height: size.height * 0.3,
          ),
          // Поле для ввода email
          RoundedInputField(
            hintText: 'Email',
            onChanged: (value) {
              authProvider.setEmail(value); // Сохраняем email в AuthProvider
            },
          ),
          // Поле для ввода пароля
          RoundedPasswordField(
            onChanged: (value) {
              authProvider.setPassword(value); // Сохраняем пароль в AuthProvider
            },
          ),
          // Отображение сообщения об ошибке валидации пароля
          if (authProvider.validateMessage != null)
            Text(
              authProvider.validateMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          // Кнопка для регистрации
          RoundedButton(
            text: authProvider.isLoading ? 'LOADING...' : 'SIGNUP',
            color: const Color.fromARGB(180, 4, 221, 236),
            press: () async {
              await authProvider.signUp(); // Выполняем регистрацию
              if (authProvider.errorMessage == null) {
                // Если регистрация прошла успешно, перенаправляем на главную страницу
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const MyHomePage();
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(authProvider.errorMessage!)),
                );
              } else {
                // Если ошибка, показываем сообщение
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(authProvider.errorMessage!)),
                );
              }
            },
          ),
          SizedBox(height: size.height * 0.03),
          AlreadyHAACheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          ),
          OrDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SocalIcon(iconsrc: 'assets/pictures/google.svg', press: () {}),
              SocalIcon(iconsrc: 'assets/pictures/facebook.svg', press: () {}),
              SocalIcon(iconsrc: 'assets/pictures/x.svg', press: () {}),
            ],
          ),
        ],
      ),
    );
  }
}