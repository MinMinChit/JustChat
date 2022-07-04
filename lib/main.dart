import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_chat/add_friend_constructor.dart';
import 'package:just_chat/constants.dart';
import 'package:just_chat/screens/add_friend_screen.dart';
import 'package:just_chat/screens/chat_lists_screen.dart';
import 'package:just_chat/screens/chat_screen.dart';
import 'package:just_chat/screens/edit_profile_screen.dart';
import 'package:just_chat/screens/get_started_screen.dart';
import 'package:just_chat/screens/login_screen.dart';
import 'package:just_chat/screens/setup_screen.dart';
import 'package:just_chat/screens/sign_up_screen.dart';
import 'package:just_chat/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    // navigation bar color
    statusBarColor: kBgColor, // status bar color
  ));
  runApp(const JustChat());
}

class JustChat extends StatelessWidget {
  const JustChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ShowScreen(),
      routes: {
        GetStartedScreen.id: (context) => const GetStartedScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        SignUpScreen.id: (context) => const SignUpScreen(),
        ChatListScreen.id: (context) => const ChatListScreen(),
        SetupScreen.id: (context) => const SetupScreen(),
        AddFriendScreen.id: (context) => const AddFriendScreen(),
        ChatScreen.id: (context) => ChatScreen(
            ModalRoute.of(context)?.settings.arguments as AddFriendConstructor),
        EditProfileScreen.id: (context) => const EditProfileScreen(),
      },
    );
  }
}

class ShowScreen extends StatefulWidget {
  const ShowScreen({Key? key}) : super(key: key);

  @override
  State<ShowScreen> createState() => _ShowScreenState();
}

class _ShowScreenState extends State<ShowScreen> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool seen = prefs.getBool('seen') ?? false;

    if (seen) {
      _handleStartScreen();
    } else {
      await prefs.setBool('seen', true);
      if (!mounted) return;
      Navigator.pushNamed(context, '/getStartedScreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Loading(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    checkFirstSeen();
  }

  Future<void> _handleStartScreen() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      Navigator.popAndPushNamed(context, LoginScreen.id);
    } else {
      getCurrentUser();
    }
  }

  void getCurrentUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    try {
      final user = auth.currentUser;
      if (user != null) {
        final DocumentReference document =
            firebaseFirestore.collection("users").doc(user.uid.toString());

        await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
          if (!snapshot.exists) {
            Navigator.popAndPushNamed(context, SetupScreen.id);
          } else {
            Navigator.popAndPushNamed(context, ChatListScreen.id);
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
