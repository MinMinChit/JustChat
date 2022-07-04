import 'package:flutter/material.dart';
import 'package:just_chat/screens/sign_up_screen.dart';
import 'package:just_chat/widgets/text_field_container.dart';
import '../constants.dart';
import '../screens/login_screen.dart';
import 'button_gesture.dart';

class InputFormContainer extends StatelessWidget {
  const InputFormContainer({
    Key? key,
    required this.emailOnChanged,
    required this.passwordOnChanged,
    required this.onTap,
    required this.buttonText,
    required this.isLogin,
  }) : super(key: key);

  final Function(dynamic) emailOnChanged;
  final Function(dynamic) passwordOnChanged;
  final Function() onTap;
  final String buttonText;
  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      height: MediaQuery.of(context).size.height * 0.7,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Color(0xff02A2FA),
            Color(0xff0CD3D6),
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(-2, 0),
            spreadRadius: -2,
            blurRadius: 2,
            color: Colors.grey,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 50,
                color: Color(0xff0AC5E3),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextFieldContainer(
            onChanged: emailOnChanged,
            icon: const Icon(
              Icons.email,
              color: kTextFieldColor,
            ),
            hintText: 'email address',
            obscureText: false,
          ),
          const SizedBox(height: 10),
          TextFieldContainer(
            onChanged: passwordOnChanged,
            icon: const Icon(
              Icons.lock,
              color: kTextFieldColor,
            ),
            hintText: 'password',
            obscureText: true,
          ),
          const SizedBox(height: 20),
          Center(
            child: ButtonGesture(onTap: onTap, buttonText: buttonText),
          ),
          const SizedBox(height: 5),
          Center(
            child: TextButton(
              onPressed: () {
                isLogin
                    ? Navigator.popAndPushNamed(context, SignUpScreen.id)
                    : Navigator.popAndPushNamed(context, LoginScreen.id);
              },
              child: Text(
                isLogin ? 'haven\' account?' : 'have already account?',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
