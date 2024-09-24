import 'dart:convert';

import 'package:http/http.dart' as http;

class LoginService {
  Future<int> loginUser(String mail, String password) async {
    final response = await http.post(
      Uri.parse("http://10.0.2.2:8080/api/user/login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'mail': mail,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['id'];
    } else {
      String errorMessage =
          jsonDecode(response.body)['error'] ?? 'Unknown error occurred';
      throw Exception('Hata $errorMessage');
    }
  }
}
