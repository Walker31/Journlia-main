class AppUser {
  String userId;
  String userName;
  String email;
  String accessToken;
  String role;
  bool banned;
  String phoneNumber;

  AppUser({
    required this.userId,
    required this.userName,
    required this.email,
    required this.accessToken,
    required this.role,
    required this.banned,
    required this.phoneNumber,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      userId: map['userId'] ?? '', // Provide default value if null
      userName: map['userName'] ?? '',
      email: map['email'] ?? '',
      accessToken: map['accessToken'] ?? '',
      role: map['role'] ?? '',
      banned: map['banned'] ?? false,
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'email': email,
      'accessToken': accessToken,
      'role': role,
      'banned': banned,
      'phoneNumber': phoneNumber,
    };
  }
}
