
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class Helper {


  void decodeJWT(String token) {
    final jwt = JWT.decode(token);

    // Print the decoded payload
    print('Payload: ${jwt.payload}');

    // Access specific claims
    final userId = jwt.payload['sub'];
    final userRole = jwt.payload['role'];
    print('User ID: $userId');
    print('User Role: $userRole');
  }

}