import 'package:flutter/material.dart';


class AlreadyHAACheck extends StatelessWidget {
  final bool login;
  final VoidCallback press;
  const AlreadyHAACheck({
    super.key,
    this.login = true,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          login ? "Don't have an account?" : "Already have an Account?",
          style: const TextStyle(color: Colors.black),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ?
            ' SIGN UP' : ' SIGN IN',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
