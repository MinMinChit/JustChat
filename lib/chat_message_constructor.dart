class ChatMessageConstructor {
  ChatMessageConstructor({
    required this.messageText,
    required this.sentBy,
    required this.sentAt,
    required this.isSeen,
  });

  final String messageText;
  final String sentBy;
  final String sentAt;
  final bool isSeen;

  toMap() {
    return {
      'messageText': messageText,
      'sentBy': sentBy,
      'sentAt': sentAt,
      'isSeen': isSeen,
    };
  }
}
