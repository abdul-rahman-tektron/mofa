class LoginRequest {
  final int? userId;
  final String username;
  final String password;

  LoginRequest({this.userId = 0, required this.username, required this.password});

  Map<String, dynamic> toJson() => {
    'userId': userId ?? 0,
    'username': username,
    'password': password,
  };
}

class LoginTokenRequest {
  final String email;
  final String password;

  LoginTokenRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
}
