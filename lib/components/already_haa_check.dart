import 'package:flutter/material.dart';


class AlreadyHAACheck extends StatelessWidget {
  final bool login;
  final VoidCallback press;
  const AlreadyHAACheck({

    Key? key,
    this.login = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          login ? "Don't have an account?" : "Already have an Account?",

          style: const TextStyle(color: Color.fromARGB(255, 251, 252, 252)),
          
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ?
            ' SIGN UP' : ' SIGN IN',
            style: const TextStyle(
              color: Color.fromARGB(255, 0, 255, 157),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
