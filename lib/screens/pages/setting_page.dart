import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_chat/screens/login_screen.dart';
import 'package:flutter/services.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseStorage firebaseStorage = FirebaseStorage.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Reference ref = firebaseStorage.ref();
  bool isCopy = false;
  ImagePicker imagePicker = ImagePicker();

  XFile image = XFile('');
  bool isPick = false;

  @override
  Widget build(BuildContext context) {
    User? user = auth.currentUser;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FutureBuilder(
              future: firestore.collection('users').doc(user!.uid).get(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  var snapshotData = snapshot.data;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xffF0F0F0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            try {
                              image = (await imagePicker.pickImage(
                                  source: ImageSource.gallery))!;
                              await firebaseStorage
                                  .ref()
                                  .child('profile/${snapshotData['profile']}')
                                  .putFile(File(image.path));
                              setState(() {
                                isPick = true;
                              });
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  FutureBuilder(
                                    future: ref
                                        .child(
                                            'profile/${snapshotData['profile']}')
                                        .getDownloadURL(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<dynamic> snapshot) {
                                      if (snapshot.hasData) {
                                        return GestureDetector(
                                          onTap: () {
                                            //update profile
                                          },
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 40,
                                            backgroundImage: NetworkImage(
                                                snapshot.data.toString()),
                                          ),
                                        );
                                      } else {
                                        return const CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 40,
                                          backgroundImage: AssetImage(
                                              'assets/images/offline_image.png'),
                                        );
                                      }
                                    },
                                  ),
                                  Positioned(
                                    right: -1,
                                    bottom: -1,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color(0xffC0C0C0),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1.5,
                                          )),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.black87,
                                        size: 18,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    snapshotData['name'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  Text(
                                    snapshotData['job'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              user.uid,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  Clipboard.setData(
                                      ClipboardData(text: user.uid));

                                  isCopy = true;
                                });
                              },
                              child: Icon(
                                Icons.copy,
                                size: 18,
                                color: isCopy ? Colors.grey : Colors.black,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                }
                return const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 40,
                  backgroundImage:
                      AssetImage('assets/images/offline_image.png'),
                );
              }),
          GestureDetector(
            onTap: () {
              auth.signOut().whenComplete(
                    () => Navigator.popAndPushNamed(context, LoginScreen.id),
                  );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.logout,
                  size: 20,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
