class AppUser {
  final String userId;
  final String userName;
  final String email;
  final String accessToken;
  final String phoneNumber;
  final String role;
  final bool banned;

  AppUser({
    required this.userId,
    required this.userName,
    required this.email,
    required this.accessToken,
    required this.role,
    required this.banned,
    required this.phoneNumber,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      userId: json['userId'],
      userName: json['userName'],
      email: json['email'],
      accessToken: json['accessToken'],
      role: json['role'],
      banned: json['banned'],
      phoneNumber: json['phoneNumber'],
    );
  }

  static AppUser fromMap(Map<String, dynamic> map) {
    return AppUser(
      userId: map['userId'],
      userName: map['userName'],
      email: map['email'],
      accessToken: map['accessToken'],
      phoneNumber: map['phoneNumber'],
      role: map['role'],
      banned: map['banned'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'email': email,
      'accessToken': accessToken,
      'phoneNumber': phoneNumber,
      'role': role,
      'banned': banned,
    };
  }
}
