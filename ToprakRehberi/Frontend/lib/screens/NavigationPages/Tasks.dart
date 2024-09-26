import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toprak_rehberi/screens/FarmingScreens/EkimCreationPage.dart';
import 'package:toprak_rehberi/screens/FarmingScreens/EkimDetailPage.dart';
import 'package:toprak_rehberi/services/FarmingService/EkimService.dart';
import 'package:toprak_rehberi/services/FarmingService/HasatService.dart';

import '../../models/Farming/Ekim.dart';
import '../../models/Farming/Hasat.dart';
import '../FarmingScreens/HasatDetailPage.dart';

class TaskList extends StatefulWidget {
  final int userID;
  const TaskList({required this.userID, super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  late Future<List<Ekim>> futureEkim;
  late Future<List<Hasat>> futureHasat;
  EkimService ekimService = EkimService();
  HasatService hasatService = HasatService();


  int currentPage = 0; // Başlangıç sayfası
  final int pageSize = 6; // Her sayfada gösterilecek işlem sayısı
  bool isEkimSelected = true; // Toggle için kontrol
  bool isLoading = false; // Veri yüklenirken gösterilecek loading durumu
  List<Ekim> ekimList = [];
  List<Hasat> hasatList = [];
  String selectedFilter = 'Arazi';
  String searchQuery = '';
  final List<String> filters = ['Arazi', 'Ürün'];
  TextEditingController searchController = TextEditingController();

  Future<void> _filterEkimList() async {
    List<Ekim> newEkimList = [];
    if (selectedFilter == 'Arazi') {
        newEkimList = await ekimService.fetchEkimByLandDesc(searchQuery, widget.userID);
    } else if (selectedFilter == 'Ürün') {
        newEkimList = await ekimService.fetchEkimByProduct(searchQuery, widget.userID);
    }



    // Liste güncelleme
    setState(() {
      ekimList = newEkimList;
    });
  }

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _scrollController.addListener(_scrollListener); // Kaydırma için listener
  }

  void _loadUserData() async {
    setState(() {
      isLoading = true;
    });
    List<Ekim> newEkim = await ekimService.fetchEkimPage(
        widget.userID, currentPage, pageSize);
    List<Hasat> newHasat = await hasatService.fetchHasatByuserID(widget.userID);
    setState(() {
      ekimList.addAll(newEkim); // Gelen ekim verilerini ekle
      hasatList.addAll(newHasat); // Gelen hasat verilerini ekle
      isLoading = false;
    });
  }

  void _clearFilter() {
    searchController.clear(); // TextField'ı temizle
    setState(() {
      searchQuery = '';
      _filterEkimList();// Arama sorgusunu temizle
    });
     // İlk ekim listesini tekrar getir
  }


  void _scrollListener() {
    if (_scrollController.position.extentAfter < 300 && !isLoading) {
      setState(() {
        currentPage++;
      });
      _loadUserData();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose(); // ScrollController'ı temizliyoruz
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ekim ve Hasatlar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Filtreleme için Dropdown ve TextField
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButton<String>(
                    value: selectedFilter,
                    onChanged: (newValue) {
                      setState(() {
                        selectedFilter = newValue!;
                      });
                    },
                    items: filters.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: TextField(
                    controller: searchController, // TextField'a kontrolcü ekliyoruz
                    decoration: InputDecoration(
                      labelText: 'Arama',
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.search),
                            onPressed: _filterEkimList, // Arama butonuna basıldığında listeyi güncelle
                          ),
                          IconButton(
                            icon: Icon(Icons.clear), // Filtreyi kaldırmak için clear ikonu
                            onPressed: _clearFilter,  // Filtreyi kaldırma fonksiyonunu çağır
                          ),
                        ],
                      ),
                    ),
                    onChanged: (value) {
                      searchQuery = value; // Kullanıcının girdiği sorgu
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Ekim ve Hasat Toggle Butonları
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleButtons(
                  isSelected: [isEkimSelected, !isEkimSelected],
                  onPressed: (int index) {
                    setState(() {
                      isEkimSelected = index == 0;
                    });
                  },
                  color: Colors.grey,
                  selectedColor: Colors.white,
                  fillColor: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('Ekimler'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('Hasatlar'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Ekim veya Hasat kartları
            Expanded(
              child: isEkimSelected ? _buildEkimList() : _buildHasatList(),
            ),
          ],
        ),
      ),
      floatingActionButton: isEkimSelected
          ? FloatingActionButton(
        heroTag: "btnCreate",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    EkimCreationPage(userID: widget.userID)),
          );
        },
        child: const Icon(Icons.add), // "+" ikonu
        tooltip: 'Ekim Oluştur', // Açıklama
      )
          : null,
    );
  }

  Widget _buildEkimList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: ekimList.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == ekimList.length) {
          return const Center(child: CircularProgressIndicator());
        }
        Ekim ekim = ekimList[index];

        DateFormat trDate = DateFormat.yMMMMd('tr_TR'); // "12 Eylül 2024" formatı
        String newDate = trDate.format(ekim.ekimTarihi);

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EkimDetailPage(ekimID: ekimList[index].id),
              ),
            );
          },
          child: Card(
            color: Colors.blue.shade100,
            margin: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Ürünün resmi - Sol tarafa yerleştirilmiş
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: SizedBox(
                    height: 120,
                    width: 120,
                    // Resim boyutunu sabitlemek için genişlik veriyoruz
                    child: Image.asset(
                      'assets/images/basicProduct.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Resim ile metinler arasında boşluk
                // Ekim bilgileri - Sağ tarafa yerleştirilmiş
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ekim.product.productName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2, // Metin en fazla 2 satır olacak
                        overflow: TextOverflow.ellipsis, // Metin taşarsa üç nokta ile kesilecek
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Ekim Tarihi: $newDate',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Ekim Alanı: ${ekim.m2} m²',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Ekim Yapılan Arazi: ${ekim.land.landDescription}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Adres: ${ekim.land.mahalle.mahalleName} - ${ekim.land.mahalle.ilceId.ilId}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  Widget _buildHasatList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: hasatList.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == hasatList.length) {
          return const Center(child: CircularProgressIndicator());
        }
        Hasat hasat = hasatList[index];

        DateFormat trDate = DateFormat.yMMMMd(
            'tr_TR'); // "12 Eylül 2024" formatı
        String newDate = trDate.format(hasat.hasatTarihi);

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HasatDetailPage(hasatID: hasat.id,userID: widget.userID,),
              ),
            );
          },
          child: Card(
            color: Colors.blue.shade100,
            margin: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Ürünün resmi - Sol tarafa yerleştirilmiş
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12)),
                  child: SizedBox(
                    height: 120,
                    width: 120,
                    // Resim boyutunu sabitlemek için genişlik veriyoruz
                    child: Image.asset(
                      'assets/images/basicProduct.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Resim ile metinler arasında boşluk

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasat.ekimId.product.productName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2, // Metin en fazla 2 satır olacak
                        overflow: TextOverflow
                            .ellipsis, // Metin taşarsa üç nokta ile kesilecek
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Hasat Tarihi: $newDate',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Hasat Sonucu: ${hasat.hasatMiktari} kg',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Hasat edilen Arazi: ${hasat.ekimId.land
                            .landDescription}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Adres: ${hasat.ekimId.land.mahalle
                            .mahalleName} - ${hasat.ekimId.land.mahalle.ilceId
                            .ilId}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
