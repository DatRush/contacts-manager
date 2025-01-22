import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class SocalIcon extends StatelessWidget {
  final String iconsrc;
  final VoidCallback press;
  const SocalIcon({
    super.key,
    required this.iconsrc,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: const Color.fromARGB(255, 91, 238, 157)),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          iconsrc,
          height: 20,
          width: 20,
        ),
      ),
    );
  }
}
