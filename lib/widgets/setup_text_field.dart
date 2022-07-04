import 'package:flutter/material.dart';

class SetupTextField extends StatelessWidget {
  const SetupTextField({
    Key? key,
    required this.onChanged,
    required this.hintText,
    required this.labelText,
  }) : super(key: key);

  final Function(dynamic) onChanged;
  final String hintText;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
        labelText: labelText,
        floatingLabelStyle: const TextStyle(
          color: Color(0xff439DF6),
          fontSize: 17,
        ),
        floatingLabelAlignment: FloatingLabelAlignment.start,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Color(0xff439DF6),
            width: 1.2,
          ),
        ),
        border: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
    );
  }
}
