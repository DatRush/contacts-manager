import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flut1/components/rounded_button.dart';
import 'package:flut1/screens/Welcome/components/background.dart';



class Body extends StatelessWidget {
  const Body({super.key});

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
              press: () { Navigator.pushNamed(context, '/register' );
              },
            ),
            RoundedButton(
              text: 'LOGIN',
              press: () { Navigator.pushNamed(context, '/login' );
              },
            ),
          ],
        ),
      ),
    );
  }
}
