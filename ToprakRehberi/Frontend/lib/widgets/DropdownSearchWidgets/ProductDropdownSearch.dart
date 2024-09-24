import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/Other/Product.dart';

class ProductDropdown extends StatefulWidget {
  final Function(Product?) onChanged;
  final Product? selectedProduct;

  ProductDropdown({required this.onChanged, this.selectedProduct});

  @override
  _ProductDropdownState createState() => _ProductDropdownState();
}

class _ProductDropdownState extends State<ProductDropdown> {
  Future<List<Product>> fetchProductBySearchQuery(String query) async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/other/products/search?query=$query'));

    if (response.statusCode == 200) {
      List<dynamic> data = (json.decode(utf8.decode(response.bodyBytes)));
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Ürün Yüklemesi Hatalı');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<Product>(
      popupProps: PopupProps.dialog(
        showSearchBox: true,
      ),
      asyncItems: (String filter) => fetchProductBySearchQuery(filter),
      itemAsString: (Product u) => u.productName,
      onChanged: widget.onChanged,
      selectedItem: widget.selectedProduct,
      dropdownBuilder: (context, Product? selectedItem) {
        return Text(
          selectedItem?.productName ?? "Ürün Seçiniz",
          style: TextStyle(
            fontSize: 20, // Font boyutunu buradan ayarlayabilirsiniz
            color: Color(0xff1a474f), // İsteğe bağlı: Yazı rengi
          ),
        );
      },
    );
  }
}
