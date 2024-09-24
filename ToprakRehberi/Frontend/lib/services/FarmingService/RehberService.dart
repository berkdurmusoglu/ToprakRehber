import 'dart:convert';

import '../../models/Farming/Rehber.dart';
import 'package:http/http.dart' as http;

class RehberService {
  String baseUrl = "http://10.0.2.2:8080/farming/rehber";

  Future<List<Rehber>> fetchRehberByMahalle(int mahalleId) async {
    final response = await http.get(
        Uri.parse('$baseUrl/mahalle/$mahalleId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });

    if (response.statusCode == 200) {
      List<Rehber> rehbers =
      (json.decode(utf8.decode(response.bodyBytes)) as List)
          .map((data) => Rehber.fromJson(data))
          .toList();
      return rehbers;
    } else {
      throw Exception('Failed to load Products');
    }
  }

  Future<List<Rehber>> fetchRehberByProduct(int productId) async {
    final response = await http.get(
        Uri.parse('$baseUrl/product/$productId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });

    if (response.statusCode == 200) {
      List<Rehber> rehbers =
      (json.decode(utf8.decode(response.bodyBytes)) as List)
          .map((data) => Rehber.fromJson(data))
          .toList();
      return rehbers;
    } else {
      throw Exception('Failed to load Products');
    }
  }
}