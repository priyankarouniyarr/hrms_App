class LoginScreenModel {
  String username;
  String password;

  LoginScreenModel({
    required this.username,
    required this.password,
  });

  factory LoginScreenModel.fromJson(Map<String, dynamic> json) {
    return LoginScreenModel(
      username: json["Username"],
      password: json["Password"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Username": username,
      "Password": password,
    };
  }
}
