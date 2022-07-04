import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_chat/collect_data_constructor.dart';
import 'package:just_chat/constants.dart';
import 'package:just_chat/screens/chat_lists_screen.dart';
import 'package:just_chat/widgets/button_gesture.dart';
import 'package:just_chat/widgets/loading.dart';
import '../widgets/setup_text_field.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({Key? key}) : super(key: key);

  static const String id = '/setupScreen';
  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  ImagePicker imagePicker = ImagePicker();

  XFile image = XFile('');
  bool isPick = false;
  String name = '';
  String description = '';
  String job = '';

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    User? user = auth.currentUser;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'Setup an Account',
                      style: kLoginTextStyle.copyWith(fontSize: 30),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Just Save to Just Chat\nBecome a member, you will enjoy.',
                    textAlign: TextAlign.start,
                    style: kSetupTextStyle,
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      try {
                        image = (await imagePicker.pickImage(
                            source: ImageSource.gallery))!;

                        setState(() {
                          isPick = true;
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Center(
                      child: Stack(
                        children: [
                          isPick
                              ? Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(File(image.path)),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(50)),
                                  ),
                                )
                              : Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    image: const DecorationImage(
                                      image: AssetImage(
                                          'assets/images/offline_image.png'),
                                      fit: BoxFit.cover,
                                    ),
                                    border: Border.all(
                                      color: const Color(0xffC0C0C0),
                                      width: 1.5,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(50)),
                                  ),
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
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.black87,
                                size: 18,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SetupTextField(
                    onChanged: (value) {
                      name = value;
                    },
                    hintText: 'Enter name',
                    labelText: 'username',
                  ),
                  const SizedBox(height: 10),
                  SetupTextField(
                    onChanged: (value) {
                      description = value;
                    },
                    hintText: 'describe yourself',
                    labelText: 'description',
                  ),
                  const SizedBox(height: 10),
                  SetupTextField(
                      onChanged: (value) {
                        job = value;
                      },
                      hintText: "worked at ...",
                      labelText: 'Job'),
                  const SizedBox(height: 20),
                  Center(
                    child: ButtonGesture(
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });
                          if (name != '' &&
                              description != '' &&
                              job != '' &&
                              image != XFile('')) {
                            try {
                              await firebaseStorage
                                  .ref()
                                  .child('profile/${user?.uid}/${image.name}')
                                  .putFile(File(image.path));

                              firebaseFirestore
                                  .collection('users')
                                  .doc(user?.uid.toString())
                                  .set(
                                    CollectData(
                                      name: name,
                                      description: description,
                                      job: job,
                                      profile: '${user?.uid}/${image.name}',
                                      isActive: false,
                                    ).toMap(),
                                  )
                                  .whenComplete(() {
                                Navigator.popAndPushNamed(
                                    context, ChatListScreen.id);
                              });
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                              print(e);
                            }
                          }
                        },
                        buttonText: 'Save'),
                  ),
                ],
              ),
              isLoading
                  ? const Align(
                      alignment: Alignment.center,
                      child: Loading(),
                    )
                  : const Text(''),
            ],
          ),
        ),
      ),
    );
  }
}
