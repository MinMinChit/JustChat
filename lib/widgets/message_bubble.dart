import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

FirebaseStorage firebaseStorage = FirebaseStorage.instance;

class MessageBubble extends StatefulWidget {
  const MessageBubble({
    Key? key,
    required this.messageText,
    required this.sentAt,
    required this.isMe,
    required this.isSeen,
    required this.isText,
  }) : super(key: key);

  final String messageText;
  final String sentAt;
  final bool isMe;
  final bool isSeen;
  final bool isText;
  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: widget.isMe
          ? widget.isText
              ? MyMessageTextContainer(
                  isSeen: widget.isSeen,
                  messageText: widget.messageText,
                )
              : MyMessageImageContainer(
                  isMe: widget.isMe,
                  isSeen: widget.isSeen,
                  messageText: widget.messageText,
                )
          : widget.isText
              ? FriendMessageContainer(
                  messageText: widget.messageText,
                  isText: widget.isText,
                )
              : MyMessageImageContainer(
                  isMe: widget.isMe,
                  isSeen: widget.isSeen,
                  messageText: widget.messageText,
                ),
    );
  }
}

class MyMessageImageContainer extends StatefulWidget {
  const MyMessageImageContainer({
    Key? key,
    required this.isSeen,
    required this.messageText,
    required this.isMe,
  }) : super(key: key);

  final bool isSeen;
  final String messageText;
  final bool isMe;

  @override
  State<MyMessageImageContainer> createState() =>
      _MyMessageImageContainerState();
}

class _MyMessageImageContainerState extends State<MyMessageImageContainer> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: widget.isMe
                ? const EdgeInsets.only(left: 70, right: 15)
                : const EdgeInsets.only(right: 70),
            child: Column(
              crossAxisAlignment: widget.isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: firebaseStorage
                      .ref('images')
                      .child(widget.messageText)
                      .getDownloadURL(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      return SizedBox(
                          height: 200,
                          width: 200,
                          child: Image.network(snapshot.data));
                    } else {
                      return const SizedBox(
                        height: 200,
                        width: 200,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
        widget.isMe
            ? Positioned(
                bottom: -9,
                right: -6,
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset(
                    'assets/images/seen_by.png',
                    color: widget.isSeen
                        ? Colors.lightBlueAccent
                        : const Color(0xffC0C0C0),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}

class MyMessageTextContainer extends StatelessWidget {
  const MyMessageTextContainer({
    Key? key,
    required this.messageText,
    required this.isSeen,
  }) : super(key: key);

  final String messageText;
  final bool isSeen;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(left: 70, right: 15),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: const BoxDecoration(
                color: Colors.lightBlueAccent,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(-1, 0.5),
                    spreadRadius: -2,
                    blurRadius: 5,
                    color: Colors.grey,
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
              ),
              child: Text(
                messageText,
                softWrap: true,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -9,
          right: -6,
          child: SizedBox(
            width: 30,
            height: 30,
            child: Image.asset(
              'assets/images/seen_by.png',
              color: isSeen ? Colors.lightBlueAccent : const Color(0xffC0C0C0),
            ),
          ),
        ),
      ],
    );
  }
}

class FriendMessageContainer extends StatelessWidget {
  const FriendMessageContainer({
    Key? key,
    required this.messageText,
    required this.isText,
  }) : super(key: key);

  final String messageText;
  final bool isText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 70),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xffF0F0F0),
              boxShadow: [
                BoxShadow(
                  offset: Offset(1, 0.5),
                  spreadRadius: -2,
                  blurRadius: 5,
                  color: Colors.grey,
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
            ),
            child: Text(
              messageText,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
