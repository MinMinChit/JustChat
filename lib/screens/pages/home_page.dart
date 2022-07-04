import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:just_chat/add_friend_constructor.dart';
import 'package:just_chat/constants.dart';
import 'package:just_chat/widgets/loading.dart';

import '../chat_screen.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseStorage firebaseStorage = FirebaseStorage.instance;
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = auth.currentUser;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 35,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xffd2d2d2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                onChanged: (value) {},
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.2,
                ),
                decoration: const InputDecoration(
                  icon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: 'Search',
                  hintStyle: kTextFieldHintTextStyle,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 15,
          child: StreamBuilder(
              stream: firebaseFirestore
                  .collection('users')
                  .doc(user?.uid)
                  .collection('contacts')
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Loading());
                }

                final data = snapshot.requireData;

                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: data.size,
                    itemBuilder: (context, index) {
                      final friendID = data!.docs[index]['friendID'];
                      final profile = data!.docs[index]['profile'];
                      final name = data!.docs[index]['name'];
                      final description = data!.docs[index]['description'];
                      final id = user!.uid;
                      var result = id.compareTo(friendID);
                      String documentID;

                      if (result < 0) {
                        //id is less than friendID
                        documentID = friendID + id;
                      } else {
                        // id is greater than friendID
                        documentID = id + friendID;
                      }
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ChatScreen.id,
                            arguments: AddFriendConstructor(
                              name: name,
                              profile: profile,
                              friendID: friendID,
                              description: description,
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            decoration: BoxDecoration(
                              color: kBgColor,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: const [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  spreadRadius: -2,
                                  blurRadius: 2,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    FutureBuilder(
                                      future: firebaseStorage
                                          .ref()
                                          .child('profile/$profile')
                                          .getDownloadURL(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<dynamic> snapshot) {
                                        if (snapshot.hasData) {
                                          return Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image:
                                                    NetworkImage(snapshot.data),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(50)),
                                            ),
                                          );
                                        } else {
                                          return Container(
                                            width: 60,
                                            height: 60,
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/offline_image.png'),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50)),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    FutureBuilder(
                                      future: firebaseFirestore
                                          .collection('users')
                                          .doc(friendID)
                                          .get(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<dynamic> snapshot) {
                                        if (snapshot.hasData) {
                                          return snapshot.data['isActive']
                                              ? Positioned(
                                                  right: -1,
                                                  bottom: -1,
                                                  child: Container(
                                                    width: 15,
                                                    height: 15,
                                                    decoration: BoxDecoration(
                                                      color: Colors.lightGreen,
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 2.0),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(10),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container();
                                        }
                                        return Container();
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                StreamBuilder(
                                  stream: firebaseFirestore
                                      .collection('chats')
                                      .doc(documentID)
                                      .collection('message')
                                      .orderBy('sentAt', descending: true)
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<dynamic> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Text('');
                                    }
                                    if (!snapshot.data.docs.isEmpty) {
                                      var lastData = snapshot.requireData;

                                      final String messageText =
                                          lastData!.docs[0]['messageText'];
                                      final isSeen =
                                          lastData!.docs[0]['isSeen'];
                                      final sentBy =
                                          lastData!.docs[0]['sentBy'];
                                      final isMe = id == sentBy;

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name,
                                            style: !isSeen && !isMe
                                                ? const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w700,
                                                  )
                                                : const TextStyle(
                                                    fontSize: 19,
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            messageText.length > 20
                                                ? '${messageText.substring(0, 20)}...'
                                                : messageText,
                                            style: !isSeen && !isMe
                                                ? const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  )
                                                : const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name,
                                            style: const TextStyle(
                                              fontSize: 19,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          const Text(
                                            'just chat now',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.green,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              }),
        ),
      ],
    );
  }
}
