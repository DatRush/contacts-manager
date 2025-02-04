import 'package:flut1/components/text_field_container.dart';
import 'package:flutter/material.dart';


class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const RoundedInputField(

    {super.key,
      required this.hintText,
      this.icon = Icons.person,
      required this.onChanged
    });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,

        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.black,
          ),
          hintText: hintText,
          border: InputBorder.none
        ),
      ),
    );
  }
}
