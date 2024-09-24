import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toprak_rehberi/services/FarmingService/EkimService.dart';

import '../../models/Farming/Ekim.dart';
import 'EkimCreationPage.dart';
import 'EkimDetailPage.dart';

class EkimListPage extends StatefulWidget {
  final int userID;

  const EkimListPage({required this.userID, super.key});

  @override
  State<EkimListPage> createState() => _EkimListPageState();
}

class _EkimListPageState extends State<EkimListPage> {
  late Future<List<Ekim>> futureEkim;
  final EkimService ekimService = EkimService();
  DateTime selectedDate = DateTime.now();
  bool hasMore = true;
  int currentPage = 0; // Başlangıçta 0. sayfa
  final int pageSize = 10;

  void _loadEkimData() {
    setState(() {
      futureEkim =
          ekimService.fetchEkimPage(widget.userID, currentPage, pageSize);
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
      backgroundColor: Color(0x80d3fac7),
      body: FutureBuilder(future: futureEkim, builder: (context, ekimSnapshot) {
        if (ekimSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (ekimSnapshot.hasError) {
          return Center(child: Text('Bir hata oluştu: ${ekimSnapshot  .error}'));
        } else if (!ekimSnapshot.hasData || ekimSnapshot.data!.isEmpty) {
          // Eğer ekim verisi yoksa, bir "Ekim Oluştur" butonu göster
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Text('Bu arazide herhangi bir ekim bulunmamaktadır.',style: TextStyle(fontSize: 30),),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EkimCreationPage(userID: widget.userID,),
                      ),
                    );
                  },
                  child: Text('Ekim Oluştur',style: TextStyle(fontSize: 30),),
                ),
              ],
            )
          );
        } else {
          List<Ekim> ekimler = ekimSnapshot.data!;
          hasMore = ekimler.length == pageSize;
          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Her satırda 2 kart olacak
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: ekimler.length,
                  itemBuilder: (context, index) {
                    return EkimCard(
                      ekim: ekimler[index],
                      onTap: () {},
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: currentPage > 0
                        ? () {
                      setState(() {
                        currentPage--;
                        _loadEkimData();
                      });
                    }
                        : null, // Sayfa 0'dan küçükse önceki sayfa yüklenemez
                    child: Text('Önceki'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EkimCreationPage(userID: widget.userID,),
                        ),
                      );
                    },
                    child: Text('Ekim Oluştur'),
                  ),
                  ElevatedButton(
                    onPressed: hasMore
                        ? () {
                      setState(() {
                        currentPage++;
                        _loadEkimData();
                      });
                    }
                        : null, // Eğer daha fazla veri yoksa buton devre dışı
                    child: Text('Sonraki'),
                  ),
                ],
              ),
            ],
          );
        }
      },
      ),
    );
  }
}

class EkimCard extends StatelessWidget {
  final Ekim ekim;
  final VoidCallback onTap; // Kart tıklama işlemi için callback

  const EkimCard({required this.ekim, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EkimDetailPage(ekimID: ekim.id), // ekimID'yi burada gönderin
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: SizedBox(
                height: 120,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/basicLand.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ekim.product.productName,
                    style: GoogleFonts.audiowide(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Ekim Tarihi : ${ekim.ekimTarihi.day}/${ekim.ekimTarihi.month}/${ekim.ekimTarihi.year}",
                    style: GoogleFonts.oswald(
                        color: Colors.grey[700], fontSize: 17),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Arazi Alanı : ${ekim.m2} m2",
                    style: GoogleFonts.oswald(
                        color: Colors.grey[700], fontSize: 17),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Ekilen Arazi : ${ekim.land.landDescription}",
                    style: GoogleFonts.oswald(
                        color: Colors.grey[700], fontSize: 17),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

