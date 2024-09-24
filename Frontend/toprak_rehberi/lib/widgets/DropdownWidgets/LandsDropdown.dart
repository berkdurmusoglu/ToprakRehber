
import 'package:flutter/material.dart';

import 'package:toprak_rehberi/services/LandService/LandService.dart';

import '../../models/Land/Land.dart';




class LandsDropdown extends StatefulWidget {
  final Function(Land) onLandSelected;
  final int userID;

  LandsDropdown({required this.onLandSelected,required this.userID});

  @override
  _LandsDropdownState createState() => _LandsDropdownState();
}

class _LandsDropdownState extends State<LandsDropdown> {
  List<Land> landList = [];
  Land? selectedLand;
  LandServices landServices = LandServices();

  @override
  void initState() {
    super.initState();
    landServices.fetchLands(widget.userID).then((data) {
      setState(() {
        landList = data;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return DropdownButton<Land>(
      hint: Text("Arazi Seçiniz"),
      value: selectedLand,
      items: landList.map((Land land) {
        return DropdownMenuItem<Land>(
          value: land,
          child: Text(land.landDescription),
        );
      }).toList(),
      onChanged: (Land? newLand) {
        setState(() {
          selectedLand = newLand!;
        });
        widget.onLandSelected(selectedLand!);
      },
    );
  }
}