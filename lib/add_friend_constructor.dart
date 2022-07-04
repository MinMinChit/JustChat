class AddFriendConstructor {
  AddFriendConstructor({
    required this.name,
    required this.profile,
    required this.friendID,
    required this.description,
  });

  final String name;
  final String profile;
  final String friendID;
  final String description;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profile': profile,
      'friendID': friendID,
      'description': description,
    };
  }
}
