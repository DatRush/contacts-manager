import 'package:flut1/components/text_field_container.dart';
import 'package:flutter/material.dart';


class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: true,
        onChanged: onChanged,
        decoration: const InputDecoration(
          hintText: 'Password',
          icon: Icon(
            Icons.lock,
            color: Colors.black,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: Colors.black,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
