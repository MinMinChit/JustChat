import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:external_path/external_path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:just_chat/add_friend_constructor.dart';
import 'package:just_chat/chat_message_constructor.dart';
import 'package:just_chat/constants.dart';
import 'package:just_chat/widgets/loading.dart';
import '../widgets/message_bubble.dart';
import '../widgets/my_behavior.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
FirebaseStorage firebaseStorage = FirebaseStorage.instance;
FirebaseAuth auth = FirebaseAuth.instance;

Map selectedImage = {};
bool setOnce = false;

class ChatScreen extends StatefulWidget {
  const ChatScreen(
    Object arguments, {
    Key? key,
  }) : super(key: key);
  static const String id = '/chatScreen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  ScrollController scrollController = ScrollController();
  String text = '';
  bool isGallery = false;

  List listImagePath = [];

  @override
  Widget build(BuildContext context) {
    Reference ref = firebaseStorage.ref();
    User? user = auth.currentUser;
    String id = user!.uid;

    for (var i = 0; i < 1000; i++) {
      selectedImage[i] = false;
    }

    final AddFriendConstructor args =
        ModalRoute.of(context)!.settings.arguments as AddFriendConstructor;

    var result = id.compareTo(args.friendID);
    String documentID;

    if (result < 0) {
      //id is less than friendID
      documentID = args.friendID + id;
    } else {
      // id is greater than friendID
      documentID = id + args.friendID;
    }

    return Scaffold(
      appBar: buildAppBar(ref, args),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 10, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: firebaseFirestore
                      .collection('chats')
                      .doc(documentID)
                      .collection('message')
                      .orderBy('sentAt', descending: true)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Loading(),
                      );
                    }

                    final messages = snapshot.requireData;

                    List<MessageBubble> mBubble = [];
                    for (var i = 0; i < messages.size; i++) {
                      final messageText = messages!.docs[i]['messageText'];
                      final sentAt = messages!.docs[i]['sentAt'];
                      final sentBy = messages!.docs[i]['sentBy'];
                      final isSeen = messages!.docs[i]['isSeen'];
                      final isMe = id == sentBy;

                      if (!isSeen && !isMe) {
                        firebaseFirestore
                            .collection('chats')
                            .doc(documentID)
                            .collection('message')
                            .doc(snapshot.data.docs[i].id)
                            .update({
                          'isSeen': true,
                        });
                      }

                      final messageWidget = MessageBubble(
                        messageText: messageText,
                        sentAt: sentAt,
                        isMe: isMe,
                        isSeen: isSeen,
                      );

                      mBubble.add(messageWidget);
                    }

                    return ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.only(bottom: 10),
                        reverse: true,
                        children: mBubble,
                      ),
                    );
                  }),
            ),
            IntrinsicHeight(
              child: StatefulBuilder(builder: (BuildContext context,
                  void Function(void Function()) setState) {
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: GestureDetector(
                              onTap: () async {
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }

                                setState(() {
                                  if (isGallery) {
                                    isGallery = false;
                                    for (var i = 0; i < 1000; i++) {
                                      selectedImage[i] = false;
                                    }
                                  } else {
                                    isGallery = true;
                                  }
                                });
                              },
                              child: const Icon(
                                Icons.photo_outlined,
                                color: Colors.lightBlueAccent,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Container(
                            constraints: const BoxConstraints(
                              maxHeight: 110,
                            ),
                            child: DecoratedBox(
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                color: kTextFieldBgColor,
                              ),
                              child: ScrollConfiguration(
                                behavior: MyBehavior(),
                                child: TextField(
                                  controller: messageTextController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  autocorrect: false,
                                  onTap: () {
                                    setState(() {
                                      isGallery = false;

                                      for (var i = 0; i < 1000; i++) {
                                        selectedImage[i] = false;
                                      }
                                    });
                                  },
                                  onChanged: (value) {
                                    text = value;
                                  },
                                  decoration:
                                      kChatScreenTextFieldInputDecoration,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: GestureDetector(
                              onTap: () {
                                if (text != '') {
                                  messageTextController.clear();
                                  firebaseFirestore
                                      .collection('chats')
                                      .doc(documentID)
                                      .collection('message')
                                      .doc()
                                      .set(ChatMessageConstructor(
                                        messageText: text,
                                        sentBy: id,
                                        sentAt: DateTime.now().toString(),
                                        isSeen: false,
                                      ).toMap());
                                  text = '';
                                }
                              },
                              child: const Icon(
                                Icons.send,
                                color: Colors.lightBlueAccent,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    isGallery
                        ? FutureBuilder(
                            future: getPath(),
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                var data = snapshot.data;
                                var dir1 = Directory('${data[0]}/download');
                                List listImage = [];

                                dir1.list().forEach((element) {
                                  RegExp regExp = RegExp(
                                      "(.gif|jpe?g|tiff?|png|webp|bmp)",
                                      caseSensitive: false);
                                  // Only add in List if path is an image
                                  if (regExp.hasMatch('$element')) {
                                    listImage.add(element);
                                  }
                                  setState(() {
                                    listImagePath = listImage;
                                  });
                                });

                                return StatefulBuilder(
                                  builder: (BuildContext context,
                                      void Function(void Function()) setState) {
                                    List<Widget> listImages = [];

                                    for (var i = 0;
                                        i < listImagePath.length;
                                        i++) {
                                      listImages.add(
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (selectedImage[i]) {
                                                selectedImage[i] = false;
                                              } else {
                                                selectedImage[i] = true;
                                              }
                                            });
                                          },
                                          child: Stack(
                                            children: [
                                              Image.file(
                                                listImagePath[i],
                                                fit: BoxFit.cover,
                                              ),
                                              Align(
                                                alignment: Alignment.center,
                                                child: selectedImage[i]
                                                    ? const Text('selected')
                                                    : const Text('unselected'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                    return ScrollConfiguration(
                                      behavior: MyBehavior(),
                                      child: SizedBox(
                                        height: 150,
                                        child: GridView.count(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          primary: false,
                                          padding: const EdgeInsets.all(20),
                                          crossAxisSpacing: 4,
                                          mainAxisSpacing: 4,
                                          crossAxisCount: 3,
                                          children: listImages,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return const SizedBox(
                                    height: 150,
                                    child: Center(child: Loading()));
                              }
                            },
                          )
                        : const SizedBox(),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(Reference ref, AddFriendConstructor args) {
    return AppBar(
      backgroundColor: kBgColor,
      foregroundColor: Colors.black,
      title: Row(
        children: [
          Stack(
            children: [
              FutureBuilder(
                future: ref.child('profile/${args.profile}').getDownloadURL(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(snapshot.data.toString()),
                    );
                  } else {
                    return const CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage:
                          AssetImage('assets/images/offline_image.png'),
                    );
                  }
                },
              ),
              FutureBuilder(
                future: firebaseFirestore
                    .collection('users')
                    .doc(args.friendID)
                    .get(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                                border:
                                    Border.all(color: Colors.white, width: 2.0),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                          )
                        : Container();
                  }
                  return Container();
                },
              )
            ],
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                args.name,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              Text(
                args.description,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          )
        ],
      ),
      elevation: 0.2,
    );
  }

  Future<List<String>> getPath() {
    return ExternalPath.getExternalStorageDirectories();
  }
}
