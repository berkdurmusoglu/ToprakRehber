import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:toprak_rehberi/models/Other/Comment.dart';


class CommentService {
  final String baseUrl = 'http://10.0.2.2:8080/other/comments';

  Future<int> addLand(String body, int user_ID, int product_ID, int mahalle_ID,int hasat_ID) async {
    final response = await http.post(
      Uri.parse('$baseUrl'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'body': body,
        'user_ID': user_ID,
        'product_ID':product_ID,
        'mahalle_ID':mahalle_ID,
        'hasat_ID':hasat_ID,
      }),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['id'];
    } else {
      throw Exception('Arazi eklemesi başarısız.');
    }
  }

  Future<List<Comment>> fetchCommentsByUser(int userID) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$userID'));

    if (response.statusCode == 200) {
      // Parse the JSON as a list
      List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;

      // Convert the list of JSON objects into a list of UserV2 objects
      return jsonList.map((json) => Comment.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Kullanıcılar Yüklenemedi');
    }
  }

  Future<List<Comment>> fetchCommentsByRehber(int rehberID) async {
    final response = await http.get(Uri.parse('$baseUrl/rehber/$rehberID'));

    if (response.statusCode == 200) {
      // Parse the JSON as a list
      List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;

      // Convert the list of JSON objects into a list of UserV2 objects
      return jsonList.map((json) => Comment.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Kullanıcılar Yüklenemedi');
    }
  }

  Future<List<Comment>> fetchCommentsByHasat(int hasatID) async {
    final response = await http.get(Uri.parse('$baseUrl/hasat/$hasatID'));

    if (response.statusCode == 200) {
      // Parse the JSON as a list
      List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;

      // Convert the list of JSON objects into a list of UserV2 objects
      return jsonList.map((json) => Comment.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Kullanıcılar Yüklenemedi');
    }
  }

  Future<List<Comment>> fetchCommentsDesc(int userID) async {
    final response = await http.get(Uri.parse('$baseUrl/all/$userID'));

    if (response.statusCode == 200) {
      // Parse the JSON as a list
      List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;

      // Convert the list of JSON objects into a list of UserV2 objects
      return jsonList.map((json) => Comment.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      print(response.statusCode);
      throw Exception('Yorumlar Yüklenemedi.');
    }
  }
}