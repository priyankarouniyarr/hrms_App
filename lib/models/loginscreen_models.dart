class LoginScreenModel {
  String username;
  String password;

  LoginScreenModel({
    required this.username,
    required this.password,
  });

  // Factory method to create a model from JSON
  factory LoginScreenModel.fromJson(Map<String, dynamic> json) {
    return LoginScreenModel(
      username: json["Username"],
      password: json["Password"],
    );
  }

  // Method to convert the model to JSON
  Map<String, dynamic> toJson() {
    return {
      "Username": username,
      "Password": password,
    };
  }
}
