import 'package:flutter/material.dart';

const kBgColor = Color(0xfffdfff5);
const kTextFieldColor = Color(0xff439DF6);
const kTextFieldBgColor = Color(0xffF0F0F0);

const kTextFieldHintTextStyle = TextStyle(
  color: Colors.grey,
);

var kSetupTextStyle = const TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: Colors.grey,
);

var kLoginTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  foreground: Paint()
    ..shader = const LinearGradient(
      colors: [
        Color(0xff02A2FA),
        Color(0xff0CD3D6),
      ],
      begin: Alignment.centerLeft,
      end: Alignment.bottomRight,
    ).createShader(
      const Rect.fromLTWH(100.0, 0.0, 150, 0.0),
    ),
);

var kChatScreenTextFieldInputDecoration = const InputDecoration(
  hintStyle: TextStyle(
    color: Colors.grey,
  ),
  hintText: 'Aa',
  isDense: true,
  contentPadding: EdgeInsets.symmetric(
    horizontal: 20.0,
    vertical: 7,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: InputBorder.none,
  focusedBorder: InputBorder.none,
);
