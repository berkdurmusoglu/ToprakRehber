import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/Farming/Ekim.dart';

class EkimService {
  String baseUrl = "http://10.0.2.2:8080/farming/ekim";

  Future<int> createEkim(int land_Id, String product_Id, String m2, String date) async {
        final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'land_Id': land_Id,
        'product_Id': product_Id,
        'm2': m2,
        'ekimTarihi': date
      }),
        );
        print(response.statusCode);
       if (response.statusCode == 200) {
       final responseData = jsonDecode(response.body);
      return responseData['id'];
          } else {
      String errorMessage =
              jsonDecode(response.body)['message'] ?? 'Unknown error occurred';
      throw Exception('Hata $errorMessage');
       }
  }

  Future<Ekim> fetchEkimId(int id) async{
    final response = await http.get(Uri.parse('$baseUrl/${id}'));

    if (response.statusCode == 200) {
      final ekimResponse = json.decode(utf8.decode(response.bodyBytes));
      return Ekim.fromJson(ekimResponse as Map<String, dynamic>);
    } else {
      throw Exception('Ekim Yüklenemedi');
    }
  }

  Future<List<Ekim>> fetchEkim(int landId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/lands/$landId'));

    if (response.statusCode == 200) {
      // Parse the JSON as a list
      List<dynamic> jsonList =
          json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;

      // Convert the list of JSON objects into a list of UserV2 objects
      return jsonList
          .map((json) => Ekim.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      String errorMessage = jsonDecode(utf8.decode(response.bodyBytes))['message'] ?? 'Unknown error occurred';
      throw Exception(errorMessage);
    }
  }

  Future<List<Ekim>> fetchEkimUserID(int userID) async {
    final response =
    await http.get(Uri.parse('$baseUrl/users/$userID'));

    if (response.statusCode == 200) {
      // Parse the JSON as a list
      List<dynamic> jsonList =
      json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;

      // Convert the list of JSON objects into a list of UserV2 objects
      return jsonList
          .map((json) => Ekim.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      String errorMessage =
          jsonDecode(response.body)['message'] ?? 'Unknown error occurred';
      throw Exception('Hata $errorMessage');
    }
  }

  Future<List<Ekim>> fetchEkimPage(int userId, int page, int size) async {
    final response = await http.get(Uri.parse('$baseUrl/page/$userId?page=$page&size=$size'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      return jsonList.map((json) => Ekim.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Ekimler Yüklenemedi');
    }
  }

  Future<List<Ekim>> fetchEkimByLandDesc(String query,int userID) async {
    final response = await http.get(Uri.parse('$baseUrl/filter/land?filter=$query&userID=$userID'));

    if (response.statusCode == 200) {
      List<dynamic> data = (json.decode(utf8.decode(response.bodyBytes)));
      return data.map((json) => Ekim.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load il');
    }
  }

  Future<List<Ekim>> fetchEkimByProduct(String query,int userID) async {
    final response = await http.get(Uri.parse('$baseUrl/filter/product?filter=$query&userID=$userID'));

    if (response.statusCode == 200) {
      List<dynamic> data = (json.decode(utf8.decode(response.bodyBytes)));
      return data.map((json) => Ekim.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load il');
    }
  }

  Future<List<Ekim>> filterProductSortAsc(String query,int userID) async {
    final response = await http.get(Uri.parse('$baseUrl/filter/product/sort/asc?filter=$query&userID=$userID'));

    if (response.statusCode == 200) {
      List<dynamic> data = (json.decode(utf8.decode(response.bodyBytes)));
      return data.map((json) => Ekim.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load il');
    }
  }

  Future<List<Ekim>> filterProductSortDesc(String query,int userID) async {
    final response = await http.get(Uri.parse('$baseUrl/filter/product/sort/desc?filter=$query&userID=$userID'));

    if (response.statusCode == 200) {
      List<dynamic> data = (json.decode(utf8.decode(response.bodyBytes)));
      return data.map((json) => Ekim.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load il');
    }
  }

  Future<List<Ekim>> filterLandSortAsc(String query,int userID) async {
    final response = await http.get(Uri.parse('$baseUrl/filter/land/sort/asc?filter=$query&userID=$userID'));

    if (response.statusCode == 200) {
      List<dynamic> data = (json.decode(utf8.decode(response.bodyBytes)));
      return data.map((json) => Ekim.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load il');
    }
  }

  Future<List<Ekim>> filterLandSortDesc(String query,int userID) async {
    final response = await http.get(Uri.parse('$baseUrl/filter/land/sort/desc?filter=$query&userID=$userID'));

    if (response.statusCode == 200) {
      List<dynamic> data = (json.decode(utf8.decode(response.bodyBytes)));
      return data.map((json) => Ekim.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load il');
    }
  }

  Future<List<Ekim>> sortM2Asc(int userID) async {
    final response = await http.get(Uri.parse('$baseUrl/$userID/sort/m2/asc'));

    if (response.statusCode == 200) {
      List<dynamic> data = (json.decode(utf8.decode(response.bodyBytes)));
      return data.map((json) => Ekim.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load il');
    }
  }

  Future<List<Ekim>> sortM2Desc(int userID) async {
    final response = await http.get(Uri.parse('$baseUrl/$userID/sort/m2/desc'));

    if (response.statusCode == 200) {
      List<dynamic> data = (json.decode(utf8.decode(response.bodyBytes)));
      return data.map((json) => Ekim.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load il');
    }
  }
  Future<List<Ekim>> sortDateAsc(int userID) async {
    final response = await http.get(Uri.parse('$baseUrl/$userID/sort/date/asc'));

    if (response.statusCode == 200) {
      List<dynamic> data = (json.decode(utf8.decode(response.bodyBytes)));
      return data.map((json) => Ekim.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load il');
    }
  }

  Future<List<Ekim>> sortDateDesc(int userID) async {
    final response = await http.get(Uri.parse('$baseUrl/$userID/sort/date/desc'));

    if (response.statusCode == 200) {
      List<dynamic> data = (json.decode(utf8.decode(response.bodyBytes)));
      return data.map((json) => Ekim.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load il');
    }
  }

}
