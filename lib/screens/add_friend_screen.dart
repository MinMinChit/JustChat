import 'package:flutter/material.dart';
import 'package:just_chat/add_friend_constructor.dart';
import 'package:just_chat/constants.dart';
import 'package:just_chat/widgets/button_gesture.dart';
import 'package:just_chat/widgets/text_field_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({Key? key}) : super(key: key);

  static const String id = '/addFriendScreen';
  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  String friendID = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        iconTheme: const IconThemeData(
          size: 35,
        ),
        backgroundColor: kBgColor,
        elevation: 0.5,
      ),
      backgroundColor: kBgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xfff3f3f3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add Friend',
                    style: kLoginTextStyle.copyWith(
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFieldContainer(
                    onChanged: (value) {
                      friendID = value;
                    },
                    icon: const Icon(Icons.add),
                    hintText: 'Enter ID',
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                  ButtonGesture(
                    onTap: () async {
                      if (friendID != '') {
                        User? user = auth.currentUser;
                        var map = await firebaseFirestore
                            .doc('users/$friendID')
                            .get();

                        if (map.exists) {
                          await firebaseFirestore
                              .doc('users/${user?.uid}/contacts/$friendID')
                              .set(
                                AddFriendConstructor(
                                        name: map['name'],
                                        profile: map['profile'],
                                        friendID: friendID,
                                        description: map['description'])
                                    .toMap(),
                              )
                              .whenComplete(() => Navigator.pop(context));
                        }
                      }
                    },
                    buttonText: 'Add',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
