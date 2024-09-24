import 'package:flutter/material.dart';
import 'package:toprak_rehberi/services/FarmingService/RehberService.dart';

import '../../models/Farming/Rehber.dart';

class RehberDropdown extends StatefulWidget {
  final int mahalleId;
  final Function(int) onChanged;

  RehberDropdown({required this.mahalleId, required this.onChanged});

  @override
  _RehberDropdownState createState() => _RehberDropdownState();
}

class _RehberDropdownState extends State<RehberDropdown> {
  late Future<List<Rehber>> futureRehberList;
  Rehber? selectedRehber;
  RehberService rehberService = RehberService();

  @override
  void initState() {
    super.initState();
    _loadRehberList();
  }

  @override
  void didUpdateWidget(covariant RehberDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mahalleId != widget.mahalleId) {
      setState(() {
        selectedRehber = null;
        _loadRehberList();
      });
    }
  }

  void _loadRehberList() {
    futureRehberList = rehberService.fetchRehberByMahalle(widget.mahalleId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Rehber>>(
      future: futureRehberList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Hata: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('Bu mahallede ekim yapılmamış.');
        } else {
          List<Rehber> rehberList = snapshot.data!;

          return Container(
            padding: EdgeInsets.all(8),  // İçerik padding
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),  // Yuvarlak köşeler
              border: Border.all(
                color: Colors.black,  // Kenarlık rengi
                width: 1.5,  // Kenarlık kalınlığı
              ),
            ),
            child: DropdownButton<Rehber>(
              value: selectedRehber,
              hint: Text('Ürün Seçin'),
              isExpanded: true,
              underline: SizedBox(),  // Alt çizgiyi kaldırır
              items: rehberList.asMap().entries.map((entry) {
                int index = entry.key;
                Rehber rehber = entry.value;

                Color backgroundColor = Color.lerp(Colors.greenAccent, Colors.red, index / rehberList.length)!;

                return DropdownMenuItem<Rehber>(
                  value: rehber,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    color: backgroundColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${rehber.product.productName} - ${rehber.sonuc.toStringAsFixed(2)} ',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text("${rehber.mevsim}", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onChanged: (Rehber? newValue) {
                setState(() {
                  selectedRehber = newValue;
                });
                widget.onChanged(newValue!.product.id);
              },
            ),
          );
        }
      },
    );
  }
}
