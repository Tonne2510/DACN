
class LoginRequest {
  String email;
  String password;

  LoginRequest(this.email, this.password);

  Map<String, Object?> toMap() {
    return {
      "email": email,
      "password": password,
    };
  }
}