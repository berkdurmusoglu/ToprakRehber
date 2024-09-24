import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/Farming/Ekim.dart';
import '../../models/Other/Product.dart';



class IlkbaharSearch extends StatefulWidget {
  final Function(Product?) onChanged;
  final Product? selectedProduct;

  IlkbaharSearch({required this.onChanged, this.selectedProduct});

  @override
  _IlkbaharSearchState createState() => _IlkbaharSearchState();
}

class _IlkbaharSearchState extends State<IlkbaharSearch> {
  Future<List<Product>> fetchProductBySearchQuery(String query) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/other/products/ilkbahar/search?query=$query'));

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
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Ürün Seçiniz",
        ),
      ),
      asyncItems: (String filter) => fetchProductBySearchQuery(filter),
      itemAsString: (Product u) => u.productName,
      onChanged: widget.onChanged,
      selectedItem: widget.selectedProduct,
    );
  }
}
