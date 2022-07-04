import 'package:flutter/material.dart';

class ButtonGesture extends StatelessWidget {
  const ButtonGesture({
    Key? key,
    required this.onTap,
    required this.buttonText,
  }) : super(key: key);

  final Function() onTap;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              spreadRadius: -2,
              offset: Offset(1, 1),
              blurRadius: 2,
              color: Colors.white,
            ),
          ],
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xff0CD3D6),
              Color(0xff02A2FA),
            ],
          ),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
