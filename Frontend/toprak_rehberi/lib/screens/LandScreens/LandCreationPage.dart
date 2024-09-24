import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toprak_rehberi/screens/NavigationPage.dart';

import 'package:toprak_rehberi/screens/NavigationPages/Tasks.dart';

import '../../models/Adres/Il.dart';
import '../../models/Adres/Ilce.dart';
import '../../models/Adres/Mahalle.dart';
import '../../services/LandService/LandService.dart';
import '../../widgets/DropdownSearchWidgets/IlDropdownSearch.dart';
import '../../widgets/DropdownSearchWidgets/IlceDropdownSearch.dart';
import '../../widgets/DropdownSearchWidgets/MahalleDropdownSearch.dart';
import '../../widgets/EnumDropdown/LandTypeDropdown.dart';

class LandCreationPage extends StatefulWidget {
  final int userID;

  const LandCreationPage({required this.userID,super.key});

  @override
  State<LandCreationPage> createState() => _LandCreationPageState();
}

class _LandCreationPageState extends State<LandCreationPage> {
  TextEditingController m2Controller = TextEditingController();
  TextEditingController landDescriptionController = TextEditingController();
  LandServices landServices = LandServices();
  Il? selectedIl;
  Ilce? selectedIlce;
  Mahalle? selectedMahalle;
  String? selectedTypeName; // Seçilen arazi tipi adı
  String? selectedType; // Seçilen arazi tipi ID
  final _formKey = GlobalKey<FormState>();
  FocusNode m2FocusNode = FocusNode();  // Yeni FocusNode
  FocusNode descriptionFocusNode = FocusNode();

  Future<void> _createLand() async {
    final String m2 = m2Controller.text;
    final String landDescription = landDescriptionController.text;

    if (selectedMahalle != null && selectedTypeName != null) {
      try {
        final int landId = await landServices.addLand(
            selectedTypeName!, m2, landDescription, widget.userID,
            selectedMahalle!.id);
        print('Arazi Oluşturuldu: $landId');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NavigationPage(userId: widget.userID,initialIndex: 2,),
          ),
        );
      } catch (e) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NavigationPage(userId: widget.userID,initialIndex: 2,),
          ),
        );
      }
    } else {
      print('Tüm Boşlukları Doldurunuz');
    }
  }

  @override
  void dispose() {
    // FocusNode'ları serbest bırakmayı unutmayın
    m2FocusNode.dispose();
    descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskList(userID: widget.userID),
            ),
          );
        }, icon: Icon(Icons.arrow_back)),
      ),
      backgroundColor: Color(0x80b4ebca),

      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("ARAZİ",style: GoogleFonts.audiowide(fontSize: 33),),
                Text("OLUŞTUR",style: GoogleFonts.audiowide(fontSize: 33),),
                SizedBox(height: 35,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Arazi Tipi',
                      style: GoogleFonts.oswald(fontSize: 18,fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    LandTypeDropdown(
                      onChanged: (String? selectedType) {
                        setState(() {
                          selectedTypeName = selectedType;
                        });
                        print("Selected Land Type : $selectedTypeName");
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Arazi İsmi',
                      style: GoogleFonts.oswald(fontSize: 18,fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      focusNode: descriptionFocusNode,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Arazi başlığı girin',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0), // Kenarları yumuşat
                          borderSide: BorderSide.none, // Kenarlık kaldır
                        ),
                      ),

                      controller: landDescriptionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Arazi başlığını girmeniz gerekiyor';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Arazi Büyüklüğü',
                      style: GoogleFonts.oswald(fontSize: 18,fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      focusNode: m2FocusNode,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Metrekare',
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0), // Kenarları yumuşat
                          borderSide: BorderSide.none, // Kenarlık kaldır
                        ),
                      ),
                      controller: m2Controller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Metrekare bilgisi girmeniz gerekiyor';
                        }
                        final number = num.tryParse(value);
                        if (number == null || number <= 0) {
                          return 'Geçerli bir metrekare girin';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Arazinizin Bulunduğu Şehir',
                      style: GoogleFonts.oswald(fontSize: 18,fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8,),
                    IlDropdown(
                      onChanged: (Il? il) {
                        setState(() {
                          selectedIl = il;
                          selectedIlce = null;
                          selectedMahalle = null;
                        });
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      selectedIl: selectedIl,
                    ),
                    SizedBox(height: 12,),
                    Text(
                      'Arazinizin Bulunduğu İlçe',
                      style: GoogleFonts.oswald(fontSize: 18,fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8,),
                    IlceDropdown(
                      onChanged: (Ilce? ilce) {
                        setState(() {
                          selectedIlce = ilce;
                          selectedMahalle = null;
                        });
                        FocusScope.of(context).requestFocus(FocusNode());// Odaklanmayı kaldırıyoruz
                      },

                      selectedIlce: selectedIlce,
                      ilId: selectedIl?.id,
                    ),
                    SizedBox(height: 12,),
                    Text(
                      'Arazinizin Bulunduğu Mahalle',
                      style: GoogleFonts.oswald(fontSize: 18,fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8,),
                    MahalleDropdown(
                      onChanged: (Mahalle? mahalle) {
                        setState(() {
                          selectedMahalle = mahalle;
                        });
                        FocusScope.of(context).requestFocus(FocusNode()); // Odaklanmayı kaldırıyoruz
                      },
                      selectedMahalle: selectedMahalle,
                      ilceId: selectedIlce?.id,
                    ),
                    SizedBox(height: 16),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _createLand();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lütfen formdaki hataları düzeltin')),
                      );
                    }
                  },
                  child: Text('Kaydet',style: GoogleFonts.oswald(fontSize: 30),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}