import 'dart:convert';

import 'package:toprak_rehberi/models/Other/Product.dart';
import 'package:http/http.dart' as http;

class ProductService {
  final String baseUrl = 'http://10.0.2.2:8080/other/products';

  Future<Product?> fetchProductById(int productId) async {
    final response = await http.get(Uri.parse('$baseUrl/product/${productId}'));
    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }
}