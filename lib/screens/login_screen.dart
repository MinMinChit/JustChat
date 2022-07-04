import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_chat/constants.dart';
import '../widgets/input_container_field.dart';
import '../widgets/loading.dart';
import 'chat_lists_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String id = '/loginScreen';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool showProgress = false;
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
                    'Login',
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
                    final user = await auth.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    if (!mounted) return;
                    if (user.user?.email == email) {
                      setState(() {
                        showProgress = false;
                      });
                      Navigator.popAndPushNamed(context, ChatListScreen.id);
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
              buttonText: 'Login',
              isLogin: true,
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
