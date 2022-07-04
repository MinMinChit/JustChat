import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    required this.messageText,
    required this.sentAt,
    required this.isMe,
    required this.isSeen,
  }) : super(key: key);

  final String messageText;
  final String sentAt;
  final bool isMe;
  final bool isSeen;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: isMe
          ? MyMessageContainer(
              isSeen: isSeen,
              messageText: messageText,
            )
          : FriendMessageContainer(
              messageText: messageText,
            ),
    );
  }
}

class MyMessageContainer extends StatelessWidget {
  const MyMessageContainer({
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
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
              ],
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
  const FriendMessageContainer({Key? key, required this.messageText})
      : super(key: key);

  final String messageText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 60),
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
