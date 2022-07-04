import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_chat/screens/setup_screen.dart';
import '../constants.dart';
import '../widgets/input_container_field.dart';
import '../widgets/loading.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static const String id = '/registerScreen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool showProgress = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  Text(
                    'Just Chat',
                    style: kLoginTextStyle,
                  ),
                  Text(
                    'Sign Up',
                    style: kLoginTextStyle.copyWith(fontSize: 50),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InputFormContainer(
              emailOnChanged: (value) {
                email = value;
              },
              passwordOnChanged: (value) {
                password = value;
              },
              onTap: () async {
                if (email != '' && password != '') {
                  setState(() {
                    showProgress = true;
                  });
                  try {
                    final user = await auth.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    if (!mounted) return;
                    if (user.user?.email == email) {
                      Navigator.popAndPushNamed(context, SetupScreen.id);
                    }
                  } catch (e) {
                    setState(() {
                      showProgress = false;
                    });
                    AlertDialog(
                      title: const Text('Error message'),
                      content: Text(e.toString()),
                    );
                  }
                }
              },
              buttonText: 'Sign Up',
              isLogin: false,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: showProgress ? const Loading() : const Text(''),
          ),
          const Align(
            alignment: Alignment.bottomRight,
            child: Text(
              'Kwejibo',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
