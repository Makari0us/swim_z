class UserProfile {
  final String id;
  final String name;
  final int? age;
  final String? swimTeam;
  final String? profilePictureUrl;
  final String? bio;

  UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.swimTeam,
    this.profilePictureUrl,
    this.bio,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map, String id) {
    return UserProfile(
      id: id,
      name: map['Name'] ?? '',
      age: map['Age'],
      swimTeam: map['Swim Team'],
      profilePictureUrl: map['Profile Picture'],
      bio: map['Bio'] ?? '',
    );
  }
}
