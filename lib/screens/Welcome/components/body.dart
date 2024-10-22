import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flut1/components/rounded_button.dart';

import 'package:flut1/screens/signup/signup_screen.dart';
import 'package:flut1/screens/Welcome/components/background.dart';
import 'package:flut1/screens/login/login_screen.dart';



class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Test",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              'assets/pictures/placeholder.svg',

              height: size.height * 0.3,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedButton(
              text: 'SIGNUP',
              color: const Color.fromARGB(180, 4, 221, 236),
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
            RoundedButton(

              text: 'LOGIN',
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
          ],
        ),
      ),
    );
  }
}
