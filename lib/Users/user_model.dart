class UserModel {
  final String? id;
  final String username;
  final String phone;
  final String email;
  final String password;

  const UserModel({
    this.id,
    required this.email,
    required this.username,
    required this.phone,
    required this.password,
  });

  toJson() {
    return {
      "username": username,
      "email": email,
      "phone": phone,
      "password": password,
    };
  }
}
