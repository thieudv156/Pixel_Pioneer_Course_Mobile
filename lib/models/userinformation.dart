class UserInformation {
  final int id;
  final String fullName;
  final String email;
  final String username;
  final List<String> roles;

  UserInformation({
    required this.id,
    required this.fullName,
    required this.email,
    required this.username,
    required this.roles,
  });

  factory UserInformation.fromJson(Map<String, dynamic> json) {
    return UserInformation(
      id: json['id'] ?? 0,
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      roles: List<String>.from(json['authorities'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'username': username,
      'roles': roles,
    };
  }
}
