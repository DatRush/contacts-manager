import 'package:flut1/components/already_haa_check.dart';
import 'package:flut1/components/rounded_button.dart';
import 'package:flut1/components/rounded_input_field.dart';
import 'package:flut1/components/rounded_password_field.dart';
import 'package:flut1/screens/Login/components/background.dart';
import 'package:flut1/screens/Signup/signup_screen.dart';
import 'package:flut1/screens/Main/mainpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatelessWidget {
  const Body({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
          RoundedInputField(
            hintText: 'Email',
            onChanged: (value) {},
          ),
          RoundedPasswordField(
            onChanged: (value) {},
          ),
          RoundedButton(
            text: 'LOGIN',
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
