import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

import '../../models/Land/Land.dart';

class LandServices{
  final String baseUrl = 'http://10.0.2.2:8080/api/land';

  Future<List<Land>> fetchLands(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$userId'));

    if (response.statusCode == 200) {
      // Parse the JSON as a list
      List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;

      // Convert the list of JSON objects into a list of UserV2 objects
      return jsonList.map((json) => Land.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Kullanıcılar Yüklenemedi');
    }
  }

  Future<List<Land>> fetchLandsPage(int userId, int page, int size) async {
    final response = await http.get(Uri.parse('$baseUrl/usersP/$userId?page=$page&size=$size'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      return jsonList.map((json) => Land.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Araziler Yüklenemedi');
    }
  }

  Future<int> addLand(String landTip, String m2,String landDescription  ,int user_Id,   int mahalle_Id) async {
    final response = await http.post(
      Uri.parse('$baseUrl'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'landTip': landTip,
        'm2': m2,
        'landDescription' : landDescription,
        'user_Id': user_Id,
        'mahalle_Id': mahalle_Id,
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

  Future<Land> fetchLand(int id) async{
    final response = await http.get(Uri.parse('$baseUrl/${id}'));

    if (response.statusCode == 200) {
      final landResponse = json.decode(utf8.decode(response.bodyBytes));
      return Land.fromJson(landResponse as Map<String, dynamic>);
    } else {
      throw Exception('Arazi Yüklenemedi');
    }
  }

  Future<void> deleteLand(int landId) async {
    final http.Response response = await http.delete(
      Uri.parse('$baseUrl/$landId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 204) {

    } else {
      // If the server did not return a "200 OK response",
      // then throw an exception.
      throw Exception('Failed to delete album.');
    }
  }

  Future<void> uploadImage(File imageFile, int landId) async {
    try {
      // Determine the MIME type of the image file
      String? mimeType = lookupMimeType(imageFile.path);
      var request = http.MultipartRequest('POST', Uri.parse("$baseUrl/$landId/uploadImage"));

      // Add the image file to the request
      var fileStream = http.ByteStream(imageFile.openRead());
      var fileLength = await imageFile.length();
      var multipartFile = http.MultipartFile(
        'image',
        fileStream,
        fileLength,
        filename: basename(imageFile.path),
        contentType: MediaType.parse(mimeType!), // image/jpeg, etc.
      );
      request.files.add(multipartFile);

      // Send the request
      var response = await request.send();

      // Check the response
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
      } else {

        print('Failed to upload image');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<Uint8List?> getLandImage(int landId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$landId/landImage'));

      if (response.statusCode == 200) {
        return response.bodyBytes; // Profil resmini byte dizisi olarak döndür
      } else {
        print('Failed to load profile image');
        return null; // Başarısız olursa null döndür
      }
    } catch (e) {
      print('Error fetching profile image: $e');
      return null;
    }
  }
}
