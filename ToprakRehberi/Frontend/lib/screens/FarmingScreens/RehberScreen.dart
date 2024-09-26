import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toprak_rehberi/screens/FarmingScreens/RehberDetailPage.dart';
import 'package:toprak_rehberi/screens/NavigationPage.dart';
import 'package:toprak_rehberi/services/FarmingService/RehberService.dart';
import 'package:toprak_rehberi/widgets/DropdownSearchWidgets/IlDropdownSearch.dart';
import 'package:toprak_rehberi/widgets/DropdownSearchWidgets/IlceDropdownSearch.dart';
import 'package:toprak_rehberi/widgets/DropdownSearchWidgets/MahalleDropdownSearch.dart';
import 'package:toprak_rehberi/widgets/DropdownSearchWidgets/ProductDropdownSearch.dart';

import '../../models/Adres/Il.dart';
import '../../models/Adres/Ilce.dart';
import '../../models/Adres/Mahalle.dart';
import '../../models/Farming/Rehber.dart';
import '../../models/Other/Product.dart' as prd;

class RehberScreen extends StatefulWidget {
  final int userID;

  const RehberScreen({required this.userID, super.key});
  @override
  _RehberScreenState createState() => _RehberScreenState();
}

class _RehberScreenState extends State<RehberScreen> with SingleTickerProviderStateMixin {
  List<Rehber> rehberList = [];
  RehberService rehberService = RehberService();
  late Future<List<Rehber>> futureRehber;
  Il? selectedIl;
  Ilce? selectedIlce;
  Mahalle? selectedMahalle;
  prd.Product? selectedProduct;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    selectedIl = Il(id: 1, ilName: "ADANA");
    selectedIlce = Ilce(id: 1, ilceName: "ALADAĞ", ilId: 1);
    selectedMahalle = Mahalle(id: 1, mahalleName: "AKÖREN", ilceId: 1);
    selectedProduct = prd.Product(id: 242, productName: "ACI BAKLA", image: "https://tr.wikipedia.org/wiki/Ac%C4%B1_bakla#/media/Dosya:Lupinus_polyphyllus3.JPG", hasatMevsimi: "Yaz", ekimMevsimi: "İlkbahar");
    _tabController = TabController(length: 2, vsync: this);
    _loadUserData();
  }

  void _loadUserData() {
    if (_tabController.index == 0) {
      futureRehber = rehberService.fetchRehberByMahalle(selectedMahalle!.id);
    } else if (selectedProduct != null) {
      futureRehber = rehberService.fetchRehberByProduct(selectedProduct!.id);
    }
  }

  void _loadRehberByIlce(int ilceID) {
    setState(() {
      futureRehber = rehberService.fetchRehberByIlce(ilceID);
    });
  }

  void _loadRehberByMahalle(int mahalleID) {
    setState(() {
      futureRehber = rehberService.fetchRehberByMahalle(mahalleID);
    });
  }

  Map<double, Color> _assignColorsByResult(List<Rehber> rehberList) {
    Map<double, Color> colorMap = {};
    List<double> uniqueResults = rehberList.map((r) => r.sonuc).toSet().toList()..sort();
    for (int i = 0; i < uniqueResults.length; i++) {
      double result = uniqueResults[i];
      colorMap[result] = Color.lerp(Colors.red, Colors.green, i / uniqueResults.length)!;
    }
    return colorMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NavigationPage(userId: widget.userID, initialIndex: 0,)),
          );
        }, icon: Icon(Icons.arrow_back_sharp)),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('TOPRAK REHBERİ', style: GoogleFonts.oswald(color: Color(0xffE0E0D8), fontSize: 30),),
        backgroundColor: Color(0xff1a474f),
        iconTheme: IconThemeData(
          color: Color(0xffE0E0D8),
        ),
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            setState(() {
              _loadUserData();
            });
          },
          indicatorColor: Colors.orange[200],
          labelColor: Colors.orange[200],
          unselectedLabelColor: Color(0xffE0E0D8),
          tabs: [
            Tab(text: 'Mahalleye Göre'),
            Tab(text: 'Ürüne Göre'),
          ],
        ),
      ),
      body: Column(
        children: [
          Column(
            children: [
              if (_tabController.index == 0) ...[
                IlDropdown(
                  onChanged: (Il? il) {
                    setState(() {
                      selectedIl = il;
                      selectedIlce = null;
                      selectedMahalle = null;
                    });
                  },
                  selectedIl: selectedIl,
                ),
                IlceDropdown(
                  onChanged: (Ilce? ilce) {
                    setState(() {
                      selectedIlce = ilce;
                      selectedMahalle = null;
                      _loadRehberByIlce(ilce!.id);
                    });
                  },
                  selectedIlce: selectedIlce,
                  ilId: selectedIl?.id,
                ),
                MahalleDropdown(
                  onChanged: (Mahalle? mahalle) {
                    setState(() {
                      selectedMahalle = mahalle;
                      _loadRehberByMahalle(mahalle!.id);
                    });
                  },
                  selectedMahalle: selectedMahalle,
                  ilceId: selectedIlce?.id,
                ),
              ] else ...[
                ProductDropdown(
                  onChanged: (prd.Product? product) {
                    setState(() {
                      selectedProduct = product;
                      _loadUserData();
                    });
                  },
                  selectedProduct: selectedProduct,
                ),
              ],
            ],
          ),
          Expanded(
            child: FutureBuilder<List<Rehber>>(
              future: futureRehber,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Rehber bulunamadı.'));
                } else {
                  List<Rehber> rehberList = snapshot.data!;
                  Map<double, Color> colorMap = _assignColorsByResult(rehberList);
                  return ListView.builder(
                    itemCount: rehberList.length,
                    itemBuilder: (context, index) {
                      Rehber rehber = rehberList[index];
                      Color backgroundColor = colorMap[rehber.sonuc]!;

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RehberDetailPage(
                                rehber: rehber,
                                backgroundColor: backgroundColor,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                          color: backgroundColor,
                          child: ListTile(
                            title: Text('Ekilen Ürünün Adı: ${rehber.product.productName}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Başarı Yüzdesi:  %${rehber.sonuc.toStringAsFixed(2)}'),
                                Text('İl: ${rehber.mahalleId.ilceId.ilId}'),
                                Text('İlçe: ${rehber.mahalleId.ilceId.ilceName}'),
                                Text('Mahalle: ${rehber.mahalleId.mahalleName}'),
                              ],
                            ),
                            textColor: Colors.white,
                            trailing: Icon(Icons.info, color: Colors.white),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
