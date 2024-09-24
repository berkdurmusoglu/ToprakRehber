import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LandTypeDropdown extends StatefulWidget {
  final Function(String?) onChanged; // Seçilen değeri döndürmek için

  const LandTypeDropdown({Key? key, required this.onChanged}) : super(key: key);

  @override
  _LandTypeDropdownState createState() => _LandTypeDropdownState();
}

class _LandTypeDropdownState extends State<LandTypeDropdown> {
  List<String> landTypes = [];
  String? selectedLandType;

  @override
  void initState() {
    super.initState();
    fetchLandTypes();
  }

  Future<void> fetchLandTypes() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/other/land-types'));

    if (response.statusCode == 200) {
      // Veriyi JSON'dan çözüp listeye dönüştürme
      setState(() {
        landTypes = List<String>.from(json.decode(utf8.decode(response.bodyBytes)));
      });
    } else {
      throw Exception('Failed to load land types');
    }
  }

  @override
  Widget build(BuildContext context) {
    return landTypes.isEmpty
        ? CircularProgressIndicator() // Veri yükleniyorsa göstermek için
        : DropdownButtonFormField<String>(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white, // Arka planı beyaz yapıyoruz
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), // İçerik boşluklarını ayarlıyoruz
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0), // Kenarları yumuşatıyoruz
          borderSide: BorderSide.none, // Kenarlıkları kaldırıyoruz
        ),
      ),
      hint: Text('Select Land Type'),
      value: selectedLandType,
      onChanged: (String? newValue) {
        setState(() {
          selectedLandType = newValue!;
        });
        widget.onChanged(newValue); // Seçimi geri döndürmek için
      },
      items: landTypes.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
