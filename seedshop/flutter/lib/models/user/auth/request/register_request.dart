
class RegisterRequest{
  String email;
  String password;
  String username;

  RegisterRequest(this.email, this.password, this.username);

  Map<String, Object?> toMap(){
    return {
      "email":email,
      "password": password,
      "username": username
    };
  }
}