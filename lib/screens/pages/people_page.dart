import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:just_chat/constants.dart';
import 'package:just_chat/widgets/loading.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseStorage firebaseStorage = FirebaseStorage.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;

class PeoplePage extends StatefulWidget {
  const PeoplePage({Key? key}) : super(key: key);

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  User? user = auth.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firestore
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
              itemCount: data.size,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                        ]),
                    child: Row(
                      children: [
                        FutureBuilder(
                          future: firebaseStorage
                              .ref()
                              .child('profile/${data!.docs[index]['profile']}')
                              .getDownloadURL(),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.hasData) {
                              return CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.white,
                                  backgroundImage:
                                      NetworkImage(snapshot.data.toString()));
                            } else {
                              return const CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage(
                                    'assets/images/offline_image.png'),
                              );
                            }
                          },
                        ),
                        const SizedBox(width: 10),
                        Text(
                          data!.docs[index]['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        });
  }
}
