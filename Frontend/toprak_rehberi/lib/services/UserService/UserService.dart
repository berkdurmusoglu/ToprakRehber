import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

import '../../models/User/User.dart';

class UserService{
  final String baseUrl = 'http://10.0.2.2:8080/api';

  Future<User> getUser(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$id'));

    if (response.statusCode == 200) {
      final utf8Response = utf8.decode(response.bodyBytes);
      return User.fromJson(jsonDecode(utf8Response) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<void> uploadImage(File imageFile, int userId) async {
    try {
      // Determine the MIME type of the image file
      String? mimeType = lookupMimeType(imageFile.path);
      var request = http.MultipartRequest('POST', Uri.parse("$baseUrl/user/$userId/uploadImage"));

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

  Future<Uint8List?> getUserProfileImage(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/user/$userId/profileImage'));

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

  Future<bool> changePassword(int id, String mail,String telNo ,String password,String newPassword) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/user/changePassword'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "id":id,
        'mail': mail,
        'telNo': telNo,
        'password' : password,
        'newPassword' : newPassword
      }),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<bool> updateUser(int id, String name,String mail ,String phone) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/user/update'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "id":id,
        'name': name,
        'mail': mail,
        'telNo' : phone,
      }),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update user');
    }
  }
}