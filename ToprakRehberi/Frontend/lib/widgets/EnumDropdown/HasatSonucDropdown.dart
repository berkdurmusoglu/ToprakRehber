import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HasatSonucDropdown extends StatefulWidget {
  final Function(String?) onSonucSelected;

  const HasatSonucDropdown({required this.onSonucSelected, super.key});

  @override
  State<HasatSonucDropdown> createState() => _HasatSonucDropdownState();
}

class _HasatSonucDropdownState extends State<HasatSonucDropdown> {
  List<String> sonucList = [];
  String? selectedHasatSonuc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchHasatSonuc();
  }

  Future<void> fetchHasatSonuc() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/other/hasat-sonuc'));

    if (response.statusCode == 200) {
      // Veriyi JSON'dan çözüp listeye dönüştürme
      setState(() {
        sonucList = List<String>.from(json.decode(utf8.decode(response.bodyBytes)));
      });
    } else {
      throw Exception('Failed to load land types');
    }
  }

  @override
  Widget build(BuildContext context) {
    return sonucList.isEmpty
        ? CircularProgressIndicator() // Veri yükleniyorsa göstermek için
        : DropdownButton<String>(
      hint: Text('Select Land Type'),
      value: selectedHasatSonuc,
      onChanged: (String? newValue) {
        setState(() {
          selectedHasatSonuc = newValue!;
        });
        widget.onSonucSelected(newValue); // Seçimi geri döndürmek için
      },
      items: sonucList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
