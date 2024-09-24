import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toprak_rehberi/screens/FarmingScreens/HasatDetailPage.dart';
import 'package:toprak_rehberi/services/FarmingService/HasatService.dart';
import '../../models/Farming/Hasat.dart';

class HasatListPage extends StatefulWidget {
  final int userID;

  const HasatListPage({Key? key, required this.userID}) : super(key: key);

  @override
  _HasatListPageState createState() => _HasatListPageState();
}

class _HasatListPageState extends State<HasatListPage> {
  late Future<List<Hasat>> futureHasat;
  final HasatService hasatService = HasatService();

  void _loadEkimData() {
    setState(() {
      futureHasat = hasatService.fetchHasatByuserID(widget.userID);
    });
  }

  @override
  void initState() {
    _loadEkimData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x80ffb7c3),
      body: FutureBuilder<List<Hasat>>(
        future: futureHasat,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Hasat bulunamadı.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Hasat hasat = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    // Hasat detay sayfasına yönlendirme
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HasatDetailPage(hasatID: hasat.id,userID: widget.userID,),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.all(8.0),
                    child: Container(
                      height: 150, // Kartların aynı boyutta olması için yükseklik belirledik
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Metinlerin olduğu kısım
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hasat Edilen Ürün: ${hasat.ekimId.product.productName}",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text("Hasat Tarihi: ${hasat.hasatTarihi.day}/${hasat.hasatTarihi.month}/${hasat.hasatTarihi.year}"),
                                SizedBox(height: 4),
                                Text("Hasat Miktarı: ${hasat.hasatMiktari}"),
                                SizedBox(height: 4),
                                Text("Hasat Sonucu: ${hasat.hasatSonuc}"),
                              ],
                            ),
                          ),
                          // Resim kısmı
                          Expanded(
                            flex: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0), // Resim köşelerini oval yapar
                              child: hasat.ekimId.product.image != null
                                  ? Image.network(
                                hasat.ekimId.product.image!,
                                height: 100, // Resim boyutunu belirleyin
                                width: 100, // Resim boyutunu belirleyin
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.image_not_supported,
                                    size: 100,
                                    color: Colors.grey,
                                  );
                                },
                              )
                                  : Icon(
                                Icons.image_not_supported,
                                size: 100,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}