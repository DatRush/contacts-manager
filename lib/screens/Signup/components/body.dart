import 'package:flut1/components/already_haa_check.dart';
import 'package:flut1/components/rounded_button.dart';
import 'package:flut1/components/rounded_input_field.dart';
import 'package:flut1/screens/Login/login_screen.dart';
import 'package:flut1/screens/Main/mainpage.dart';
import 'package:flut1/screens/Signup/components/ordivider.dart';
import 'package:flut1/screens/Signup/components/socalicon.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flut1/screens/Signup/components/background.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'SIGNUP',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size.height * 0.03),
          SvgPicture.asset(
            'assets/pictures/images.svg',
            height: size.height * 0.35,
          ),
          RoundedInputField(
            hintText: 'Email',
            onChanged: (value) {},
          ),
          RoundedInputField(
            hintText: 'Password',
            onChanged: (value) {},
          ),
          RoundedButton(
            text: 'SIGNUP',
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
              SocalIcon(iconsrc: ' assets/pictures/images.svg', press: () {}),
              SocalIcon(iconsrc: ' assets/pictures/images.svg', press: () {}),
              SocalIcon(iconsrc: ' assets/pictures/images.svg', press: () {}),
            ],
          ),
        ],
      ),
    );
  }
}
