class User {
  final String userName;
  final String profileImage;
  final String accessToken;

  User({
    required this.userName,
    required this.profileImage,
    required this.accessToken,
  });

  factory User.empty() {
    return User(userName: "", profileImage: "", accessToken: "");
  }
}
