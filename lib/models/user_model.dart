class User {
  final String id;
  final String email;
  final String phone;
  final String fullName;
  final String username;

  User({
    required this.id,
    required this.email,
    required this.phone,
    required this.fullName,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      fullName: json['fullName'] ?? '',
      username: json['username'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'fullName': fullName,
      'username': username,
    };
  }
}