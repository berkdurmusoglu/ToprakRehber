import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/Adres/Mahalle.dart';


class MahalleDropdown extends StatefulWidget {
  final Function(Mahalle?) onChanged;
  final Mahalle? selectedMahalle;
  final int? ilceId;

  MahalleDropdown(
      {required this.onChanged, this.selectedMahalle, this.ilceId});

  @override
  _MahalleDropdownState createState() => _MahalleDropdownState();
}

class _MahalleDropdownState extends State<MahalleDropdown> {
  final String baseUrl = 'http://10.0.2.2:8080/adres';

  Future<List<Mahalle>> fetchMahalleBySearchQuery(String query) async {
    if (widget.ilceId == null) return [];

    final response = await http.get(Uri.parse(
        '$baseUrl/mahalle/search?ilceId=${widget.ilceId}&query=$query'));

    if (response.statusCode == 200) {
      List<dynamic> data = (json.decode(utf8.decode(response.bodyBytes)));
      return data.map((json) => Mahalle.fromJson(json)).toList();
    } else {
      throw Exception('Mahalleler Yüklenemedi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<Mahalle>(
      popupProps: PopupProps.dialog(
        showSearchBox: true,
      ),

      asyncItems: (String filter) => fetchMahalleBySearchQuery(filter),
      itemAsString: (Mahalle u) => u.mahalleName,
      onChanged: widget.onChanged,
      selectedItem: widget.selectedMahalle,
      enabled: widget.ilceId != null,
      dropdownBuilder: (context, Mahalle? selectedMahalle) {
        return Text(
          selectedMahalle?.mahalleName ?? "Mahalle Seçiniz",
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
