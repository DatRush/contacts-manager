import 'package:flut1/screens/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flut1/screens/Welcome/components/background.dart';
import 'package:flut1/screens/login/login_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flut1/components/rounded_button.dart';

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
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              'assets/pictures/images.svg',
              height: size.height * 0.3,
            ),
            SizedBox(height: size.height * 0.03),
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
            RoundedButton(
              text: 'SIGNUP',
              color: const Color.fromARGB(255, 166, 198, 255),
              textColor: Colors.black,
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
      ),
    );
  }
}
