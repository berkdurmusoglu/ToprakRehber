import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/Adres/Il.dart';


class IlDropdown extends StatefulWidget {
  final Function(Il?) onChanged;
  final Il? selectedIl;

  IlDropdown({required this.onChanged, this.selectedIl});

  @override
  _IlDropdownState createState() => _IlDropdownState();
}

class _IlDropdownState extends State<IlDropdown> {
  final String baseUrl = 'http://10.0.2.2:8080/adres';

  Future<List<Il>> fetchIlBySearchQuery(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/il/search?query=$query'));

    if (response.statusCode == 200) {
      List<dynamic> data = (json.decode(utf8.decode(response.bodyBytes)));
      return data.map((json) => Il.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load il');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<Il>(
      popupProps: PopupProps.dialog(
        showSearchBox: true,
      ),
      asyncItems: (String filter) => fetchIlBySearchQuery(filter),
      itemAsString: (Il u) => u.ilName,
      onChanged: widget.onChanged,
      selectedItem: widget.selectedIl,
      dropdownBuilder: (context, Il? selectedIl) {
        return Text(
          selectedIl?.ilName ?? "Şehir seçiniz",
          style: TextStyle(
            fontSize: 20, // Font boyutunu buradan ayarlayabilirsiniz
            fontWeight: FontWeight.bold,
            color: Color(0xff1a474f), // İsteğe bağlı: Yazı rengi
          ),
        );
      },
    );
  }
}
