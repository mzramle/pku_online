class UserModel {
  final String? id;
  late final String fullName;
  late final String email;
  late final String phone;
  late final String password;

  UserModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
  });

  toJson() {
    return {
      "FullName": fullName,
      "Email": email,
      "Phone": phone,
      "Password": password,
    };
  }
}
