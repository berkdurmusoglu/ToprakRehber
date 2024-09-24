import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/Farming/Hasat.dart';

class HasatService {

  String baseUrl = "http://10.0.2.2:8080/farming/hasat";


  Future<void> createHasat(int ekimId, String hasatMiktari, String hasatSonuc, String hasatTarihi) async {
      final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'ekim_Id': ekimId,
        'hasatMiktari': hasatMiktari,
        'hasatSonuc': hasatSonuc,
        'hasatTarihi': hasatTarihi
      }),
      );
     print(response.statusCode);
        if (response.statusCode == 200) {
          } else {
      String errorMessage =
            jsonDecode(response.body)['message'] ?? 'Unknown error occurred';
         throw Exception('Hata $errorMessage');
        }
  }

  Future<List<Hasat>> fetchHasatByuserID(int userID) async {
    final response =
    await http.get(Uri.parse('$baseUrl/users/$userID'));

    if (response.statusCode == 200) {
      // Parse the JSON as a list
      List<dynamic> jsonList =
      json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;

      // Convert the list of JSON objects into a list of UserV2 objects
      return jsonList
          .map((json) => Hasat.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      String errorMessage =
          jsonDecode(response.body)['message'] ?? 'Unknown error occurred';
      throw Exception('Hata $errorMessage');
    }
  }

  Future<List<Hasat>> fetchHasatByLandID(int landID) async {
    final response =
    await http.get(Uri.parse('$baseUrl/hasat/lands/$landID'));

    if (response.statusCode == 200) {
      // Parse the JSON as a list
      List<dynamic> jsonList =
      json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;

      // Convert the list of JSON objects into a list of UserV2 objects
      return jsonList
          .map((json) => Hasat.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      String errorMessage =
          jsonDecode(response.body)['message'] ?? 'Unknown error occurred';
      throw Exception('Hata $errorMessage');
    }
  }

  Future<Hasat> fetchHasat(int hasatID) async {
    final response = await http.get(Uri.parse("$baseUrl/details/$hasatID"));

    print(response.statusCode);
    if (response.statusCode == 200) {
      final hasatResponse = json.decode(utf8.decode(response.bodyBytes));
      return Hasat.fromJson(hasatResponse as Map<String, dynamic>);
    } else {
      throw Exception('Hasat Yüklenemedi');
    }
  }

  Future<Hasat> fetchHasatByEkimID(int ekimID) async {
    final response = await http.get(Uri.parse("$baseUrl/ekim/$ekimID"));

    print(response.statusCode);
    if (response.statusCode == 200) {
      final hasatResponse = json.decode(utf8.decode(response.bodyBytes));
      return Hasat.fromJson(hasatResponse as Map<String, dynamic>);
    } else {
      throw Exception('Hasat Yüklenemedi');
    }
  }
}