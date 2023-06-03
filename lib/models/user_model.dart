class UserModel {
  final String? id;
  late final String username;
  late final String email;
  late final String phone;
  late final String password;

  UserModel({
    this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
  });

  toJson() {
    return {
      "Username": username,
      "Email": email,
      "Phone": phone,
      "Password": password,
    };
  }
}
