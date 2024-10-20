import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:flut1/components/already_haa_check.dart';
import 'package:flut1/components/rounded_button.dart';
import 'package:flut1/components/rounded_input_field.dart';
import 'package:flut1/components/rounded_password_field.dart';

import 'package:flut1/screens/Login/components/background.dart';
import 'package:flut1/screens/Signup/signup_screen.dart';
import 'package:flut1/screens/Main/mainpage.dart';

import 'package:flut1/providers/auth_model.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final authProvider = Provider.of<AuthModel>(context);

    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'LOGIN',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          SvgPicture.asset(
            'assets/pictures/images.svg',
            height: size.height * 0.3,
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          // Поле для email
          RoundedInputField(
            hintText: 'Email',
            onChanged: (value) {
              authProvider.setEmail(value);
            },
          ),
          // Поле для пароля
          RoundedPasswordField(
            onChanged: (value) {
              authProvider.setPassword(value);
            },
          ),
          // Кнопка для входа
          RoundedButton(
            text: authProvider.isLoading ? 'LOADING...' : 'LOGIN',
            press: () async {
              await authProvider.login();
              if (authProvider.errorMessage == null) {
                // Если вход успешен, перенаправляем на главную страницу
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const MyHomePage(); // Главная страница после входа
                    },
                  ),
                );
              } else {
                // Показываем сообщение об ошибке, если вход не удался
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(authProvider.errorMessage!)),
                );
              }
            },
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          // Переход на страницу регистрации
          AlreadyHAACheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignupScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}