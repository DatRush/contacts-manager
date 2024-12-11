import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:flut1/components/already_haa_check.dart';
import 'package:flut1/components/rounded_button.dart';
import 'package:flut1/components/rounded_input_field.dart';
import 'package:flut1/components/rounded_password_field.dart';

import 'package:flut1/screens/Login/components/background.dart';
import 'package:flut1/screens/Register/register_screen.dart';
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
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          SvgPicture.asset(
            'assets/pictures/placeholder.svg',
            height: size.height * 0.3,
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          // Поле для email
          RoundedInputField(
            icon: Icons.mail,
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
          RoundedButton(
            text: 'LOGIN',
            color: const Color.fromARGB(180, 4, 221, 236),
            press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const MyHomePage();
                    },
                  ),
                );
            },
          ),
          // Кнопка для входа
          // RoundedButton(
          //   text: authProvider.isLoading ? 'LOADING...' : 'LOGIN',
          //   color: const Color.fromARGB(180, 4, 221, 236),
          //   press: authProvider.isLoading ? null : () async {
          //     bool success = await authProvider.login();

          //     ScaffoldMessenger.of(context).showSnackBar(
          //       SnackBar(content: Text(success ? 'Вход прошел успешно' : authProvider.errorMessage ?? 'Ошибка')),
          //     );

          //     if (success) {
          //       authProvider.clearError(); // Сброс ошибок перед переходом
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) {
          //             return const MyHomePage();
          //           },
          //         ),
          //       );
          //     }
          //   },
          // ),
          SizedBox(
            height: size.height * 0.03,
          ),
          AlreadyHAACheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return RegisterScreen();
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
