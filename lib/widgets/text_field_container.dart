import 'package:flutter/material.dart';

import '../constants.dart';

class TextFieldContainer extends StatelessWidget {
  const TextFieldContainer({
    Key? key,
    required this.onChanged,
    required this.icon,
    required this.hintText,
    required this.obscureText,
  }) : super(key: key);

  final Function(dynamic) onChanged;
  final Icon icon;
  final String hintText;
  final bool obscureText;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: TextField(
        obscureText: obscureText,
        onChanged: onChanged,
        style: const TextStyle(
          color: kTextFieldColor,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.2,
        ),
        decoration: InputDecoration(
          icon: icon,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: hintText,
          hintStyle: kTextFieldHintTextStyle,
        ),
      ),
    );
  }
}
