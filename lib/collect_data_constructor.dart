class CollectData {
  CollectData({
    required this.name,
    required this.description,
    required this.job,
    required this.profile,
    required this.isActive,
  });

  final String name;
  final String description;
  final String job;
  final String profile;
  final bool isActive;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'job': job,
      'profile': profile,
      'isActive': isActive,
    };
  }
}
