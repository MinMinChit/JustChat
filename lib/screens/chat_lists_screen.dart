import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_chat/screens/add_friend_screen.dart';
import 'package:just_chat/screens/pages/home_page.dart';
import 'package:just_chat/screens/pages/people_page.dart';
import 'package:just_chat/screens/pages/setting_page.dart';
import 'package:just_chat/widgets/loading.dart';
import '../constants.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  static const String id = '/chatListScreen';

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>
    with WidgetsBindingObserver {
  Reference ref = firebaseStorage.ref();
  int index = 0;
  List bodyLists = [];
  bool visibleFloatingButton = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      //online
      setStatus(true);
    } else {
      setStatus(false);
    }
  }

  void setStatus(bool isActive) async {
    await firebaseFirestore
        .collection('users')
        .doc(auth.currentUser?.uid)
        .update({
      'isActive': isActive,
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = auth.currentUser;
    return FutureBuilder(
      future: firebaseFirestore.collection("users").doc(user!.uid).get(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          String data = snapshot.data['profile'].toString();
          return Scaffold(
            backgroundColor: kBgColor,
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FutureBuilder(
                    future: ref.child('profile/$data').getDownloadURL(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(snapshot.data),
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                          ),
                        );
                      } else {
                        return Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/images/offline_image.png'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                        );
                      }
                    },
                  ),
                  Text(
                    appbarText(index),
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    child: appbarIcon(index),
                  ),
                ],
              ),
              backgroundColor: kBgColor,
              elevation: 0.2,
            ),
            floatingActionButton: visibleFloatingButton
                ? FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AddFriendScreen.id);
                    },
                    backgroundColor: kBgColor,
                    child: const Icon(
                      Icons.add,
                      size: 30,
                      color: Color(0xff02A2FA),
                    ),
                  )
                : null,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: index,
              onTap: (value) {
                setState(() {
                  index = value;
                  if (index == 1) {
                    visibleFloatingButton = true;
                  } else {
                    visibleFloatingButton = false;
                  }
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.supervised_user_circle),
                  label: 'People',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Setting',
                ),
              ],
              backgroundColor: kBgColor,
            ),
            body: bodyPage(index),
          );
        } else {
          return Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        'Just Chat',
                        style: kLoginTextStyle.copyWith(
                          fontSize: 40,
                        ),
                      ),
                    ),
                  ),
                  const Align(alignment: Alignment.center, child: Loading()),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget bodyPage(int index) {
    if (index == 0) {
      return const HomePage();
    } else if (index == 1) {
      return const PeoplePage();
    } else {
      return const SettingPage();
    }
  }

  String appbarText(int index) {
    if (index == 0) {
      return 'Chats';
    } else if (index == 1) {
      return 'People';
    } else {
      return 'Settings';
    }
  }

  Widget appbarIcon(int index) {
    if (index == 0) {
      return Image.asset('assets/images/new_message.png');
    } else if (index == 1) {
      return Image.asset('assets/images/people_contact.png');
    } else {
      return Image.asset('assets/images/settings.png');
    }
  }
}
