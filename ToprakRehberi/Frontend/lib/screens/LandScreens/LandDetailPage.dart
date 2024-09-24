
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toprak_rehberi/models/Farming/Hasat.dart';
import 'package:toprak_rehberi/screens/FarmingScreens/HasatListPage.dart';
import 'package:toprak_rehberi/screens/NavigationPage.dart';
import 'package:toprak_rehberi/services/FarmingService/EkimService.dart';
import 'package:toprak_rehberi/services/FarmingService/HasatService.dart';

import '../../models/Farming/Ekim.dart';
import '../../models/Land/Land.dart' as lnd;
import '../../services/LandService/LandService.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';

import '../FarmingScreens/EkimCreationPage.dart';
import '../FarmingScreens/EkimDetailPage.dart';


class LandDetailPage extends StatefulWidget {
  final int landID;
  final int userID;

  const LandDetailPage({required this.landID,required this.userID, super.key});

  @override
  State<LandDetailPage> createState() => _LandDetailPageState();
}

class _LandDetailPageState extends State<LandDetailPage> {
  late Future<lnd.Land> futureLand;
  late Future<List<Ekim>> futureEkim;
  final LandServices landService = LandServices();
  late Future<List<Hasat>> futureHasat;
  final HasatService hasatService = HasatService();
  final EkimService ekimService = EkimService();
  Uint8List? landImage;
  final ImagePicker _picker = ImagePicker();


  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    futureLand = landService.fetchLand(widget.landID);
    futureEkim = ekimService.fetchEkim(widget.landID);
    futureHasat = hasatService.fetchHasatByLandID(widget.landID);
    _loadLandImage();
  }

  Future<void> _pickAndUploadLandImage() async {
    try {
      // Pick an image
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        // Convert the picked image to a File
        File imageFile = File(image.path);

        // Call the addImage method with the selected file and userId
        await landService.uploadImage(imageFile, widget.landID);
        _loadLandImage();
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking or uploading image: $e');
    }
  }

  Future<void> _loadLandImage() async {
    Uint8List? image = await landService.getLandImage(widget.landID);
    setState(() {
      landImage = image;
    });
  }

  Future<void> _confirmDelete() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.orange.withOpacity(0.90),
          title: Text('Silmek istiyor musunuz?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bu işlemi geri alamazsınız.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Sil'),
              onPressed: () async {
                try {
                  await LandServices().deleteLand(widget.landID);
                  Navigator.pop(context);
                  Navigator.pop(
                      context); // Bu ekranı kapat ve önceki ekrana dön
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Arazi başarıyla silindi.'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Arazi silinirken bir hata oluştu.'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () => _pickAndUploadLandImage(), icon: Icon(Icons.add_a_photo)),
          IconButton(
            onPressed: () async {
              _confirmDelete();
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20,10,20),
        child: FutureBuilder<lnd.Land>(
          future: futureLand,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Hata: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final land = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Üst kısımda ürünün resmi
                    Container(
                      height: 160,
                      width: 400,
                      decoration: BoxDecoration(
                        color: Color(0xff629FAF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          landImage != null
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(
                              landImage!,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          )
                              : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/${land.landTip}.jpg', // Default resmi burada belirtin
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: 500,
                        height: 300,
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white70, // Arka plan rengi
                          borderRadius: BorderRadius.circular(12.0), // Ana Container köşe yuvarlama
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.9),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // Gölge konumu
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(// Çerçeve rengi
                                borderRadius: BorderRadius.circular(8.0), // Çerçeve köşeleri
                              ),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Arazi Adı: ", // Açıklama kısmı
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
                                    ),
                                    TextSpan(
                                      text: "${land.landDescription}", // Değer kısmı
                                      style: TextStyle(color: Colors.black, fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Arazi Tipi: ",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
                                    ),
                                    TextSpan(
                                      text: "${land.landTip}",
                                      style: TextStyle(color: Colors.black, fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Arazi Büyüklüğü: ",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
                                    ),
                                    TextSpan(
                                      text: "${land.m2} m²",
                                      style: TextStyle(color: Colors.black, fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Ekime Uygun Alan: ",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
                                    ),
                                    TextSpan(
                                      text: "${land.ekimM2}",
                                      style: TextStyle(color: Colors.black, fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(

                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Arazi Adresi: ",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
                                    ),
                                    TextSpan(
                                      text: "${land.mahalle.mahalleName} / ${land.mahalle.ilceId.ilceName}",
                                      style: TextStyle(color: Colors.black, fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "İl: ",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
                                    ),
                                    TextSpan(
                                      text: "${land.mahalle.ilceId.ilId}",
                                      style: TextStyle(color: Colors.black, fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),




                    SizedBox(height: 10),
                    ElevatedButton(onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EkimCreationPage(userID: widget.userID,land: land,),
                        ),
                      );
                    }, child: Text("Ekim Oluştur")),

                    SizedBox(height: 26),
                    // Current Tasks Section
                    EkimHasatToggle(futureEkim: futureEkim,userID: widget.userID,futureHasat: futureHasat,),
                  ],
                ),
              );
            } else {
              return Center(child: Text('Veri bulunamadı'));
            }
          },
        ),
      ),
    );
  }
}


class EkimHasatToggle extends StatefulWidget {
  final Future<List<Ekim>> futureEkim;
  final Future<List<Hasat>> futureHasat;
  final int userID;

  EkimHasatToggle({
    required this.futureEkim,
    required this.futureHasat,
    required this.userID,
  });

  @override
  _EkimHasatToggleState createState() => _EkimHasatToggleState();
}

class _EkimHasatToggleState extends State<EkimHasatToggle> {
  int selectedIndex = 0; // 0: Ekim, 1: Hasat

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ToggleButtons(
          splashColor: Colors.blue.shade50,
          color:Colors.blue.shade50 ,
          isSelected: [selectedIndex == 0, selectedIndex == 1],
          onPressed: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Ekimleri Göster'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Hasatları Göster'),
            ),
          ],
        ),
        SizedBox(height: 10), // Toggle ile içerik arasında boşluk

        if (selectedIndex == 0) ...[
          // Ekimleri Göster
          FutureBuilder<List<Ekim>>(
            future: widget.futureEkim,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                return Text("Bu arazide herhangi bir ekim işlemi bulunmamaktadır.");
              } else {
                final ekimler = snapshot.data!;

                return Column(
                  children: [
                    SizedBox(
                      height: 150, // Sabit yükseklik
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal, // Yatay liste
                        itemCount: ekimler.length,
                        itemBuilder: (context, index) {
                          final ekim = ekimler[index];
                          DateFormat trDate = DateFormat.yMMMMd('tr_TR'); // "12 Eylül 2024" formatı
                          String newDate = trDate.format(ekim.ekimTarihi);
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EkimDetailPage(ekimID: ekim.id),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Container(
                                width: 200, // Sabit genişlik
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/basicLand.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(color: Colors.white), // Genel stil
                                        children: [
                                          TextSpan(
                                            text:
                                            "${ekim.product.productName}\n${newDate}",
                                          ),
                                          TextSpan(
                                            text: "       ", // Boşluk bırakmak için
                                          ),
                                          TextSpan(
                                            text: "${ekim.m2} m²", // m² bilgisi
                                            style: TextStyle(fontWeight: FontWeight.bold), // Stil değişikliği
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10), // Buton ile liste arasında boşluk
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NavigationPage(userId: widget.userID, initialIndex: 1),
                          ),
                        );
                      },
                      child: Text("Tüm Ekimlerim"),
                    ),
                  ],
                );
              }
            },
          ),
        ] else if (selectedIndex == 1) ...[
          // Hasatları Göster
          FutureBuilder<List<Hasat>>(
            future: widget.futureHasat,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                return Text("Bu arazide gerçekleşmiş bir hasat işlemi bulunmamaktadır.");
              } else {
                final hasatlar = snapshot.data!;
                return Column(
                  children: [
                    SizedBox(
                      height: 150, // Sabit yükseklik
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal, // Yatay liste
                        itemCount: hasatlar.length,
                        itemBuilder: (context, index) {
                          final hasat = hasatlar[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HasatListPage(userID: widget.userID),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Container(
                                width: 200, // Sabit genişlik
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/basicLand.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      "${hasat.ekimId.product.productName}\n${hasat.ekimId.ekimTarihi.day}/${hasat.ekimId.ekimTarihi.month}/${hasat.ekimId.ekimTarihi.year}\n${hasat.hasatSonuc} - ${hasat.hasatMiktari}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10), // Buton ile liste arasında boşluk
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NavigationPage(userId: widget.userID, initialIndex: 1),
                          ),
                        );
                      },
                      child: Text("Tüm Hasatlarım"),
                    ),
                  ],
                );
              }
            },
          ),
        ]
      ],
    );
  }
}