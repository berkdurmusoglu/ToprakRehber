import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/Adres/Ilce.dart';



class IlceDropdown extends StatefulWidget {
  final Function(Ilce?) onChanged;
  final Ilce? selectedIlce;
  final int? ilId;

  IlceDropdown({required this.onChanged, this.selectedIlce, this.ilId});

  @override
  _IlceDropdownState createState() => _IlceDropdownState();
}

class _IlceDropdownState extends State<IlceDropdown> {
  final String baseUrl = 'http://10.0.2.2:8080/adres';

  Future<List<Ilce>> fetchIlceBySearchQuery(String query) async {
    if (widget.ilId == null) return [];

    final response = await http.get(Uri.parse('$baseUrl/ilce/search?ilId=${widget.ilId}&query=$query'));

    if (response.statusCode == 200) {
      List<dynamic> data = (json.decode(utf8.decode(response.bodyBytes)));
      return data.map((json) => Ilce.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load ilçe');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<Ilce>(
      popupProps: PopupProps.dialog(
        showSearchBox: true,
      ),
      asyncItems: (String filter) => fetchIlceBySearchQuery(filter),
      itemAsString: (Ilce u) => u.ilceName,
      onChanged: widget.onChanged,
      selectedItem: widget.selectedIlce,
      enabled: widget.ilId != null,
      dropdownBuilder: (context, Ilce? selectedIlce) {
        return Text(
          selectedIlce?.ilceName ?? "İlçe Seçiniz",
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
