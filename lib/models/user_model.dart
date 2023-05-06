class UserModel {
  final String? id;
  final String fullName;
  final String email;
  final String phone;
  final String password;

  const UserModel({
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
