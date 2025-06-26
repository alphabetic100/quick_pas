class User {
  final String userId;
  final String userName;
  final String profileImage;
  final String accessToken;

  User({
    required this.userId,
    required this.userName,
    required this.profileImage,
    required this.accessToken,
  });

  factory User.empty() {
    return User(userId: "", userName: "", profileImage: "", accessToken: "");
  }
}
