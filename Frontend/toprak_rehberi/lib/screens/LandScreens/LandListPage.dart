import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toprak_rehberi/screens/LandScreens/LandCreationPage.dart';
import 'package:toprak_rehberi/services/LandService/LandService.dart';
import 'dart:typed_data';
import '../../models/Land/Land.dart';
import 'LandDetailPage.dart';

class LandListPage extends StatefulWidget {
  final int userID;

  const LandListPage({required this.userID, Key? key}) : super(key: key);

  @override
  State<LandListPage> createState() => _LandListPageState();
}

class _LandListPageState extends State<LandListPage> {
  late Future<List<Land>> futureLand;
  LandServices landService = LandServices();
  int currentPage = 0; // Başlangıçta 0. sayfa
  final int pageSize = 6; // Sayfa başına 6 kayıt
  bool hasMore = true;
  Uint8List? landImage;

  @override
  void initState() {
    _loadLand();
    super.initState();
  }

  void _loadLand() {
    setState(() {
      futureLand = landServices.fetchLandsPage(widget.userID, currentPage, pageSize);
    });
  }

  final LandServices landServices = LandServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LandCreationPage(userID: widget.userID),
              ),
            );
          }, icon: Icon(Icons.add_a_photo))
        ],
      ),
      backgroundColor: Color(0x80bcf4f5),
      body: FutureBuilder<List<Land>>(
        future: futureLand,
        builder: (context, landSnapshot) {
          if (landSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (landSnapshot.hasError) {
            return Center(child: Text('Bir hata oluştu.'));
          } else if (!landSnapshot.hasData || landSnapshot.data!.isEmpty) {
            return Center(child: Text('Arazi bulunamadı.'));
          } else {
            List<Land> lands = landSnapshot.data!;
            hasMore = lands.length == pageSize;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: lands.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LandCard(
                          userID: widget.userID,
                          land: lands[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LandDetailPage(userID: widget.userID, landID: lands[index].id),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: currentPage > 0
                          ? () {
                        setState(() {
                          currentPage--;
                          _loadLand();
                        });
                      }
                          : null, // Sayfa 0'dan küçükse önceki sayfa yüklenemez
                      child: Text('<'),
                    ),
                    Text(
                      'Sayfa ${currentPage + 1}', // Mevcut sayfa numarası (0-based olduğu için +1)
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: hasMore
                          ? () {
                        setState(() {
                          currentPage++;
                          _loadLand();
                        });
                      }
                          : null, // Eğer daha fazla veri yoksa buton devre dışı
                      child: Text('>'),
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

class LandCard extends StatelessWidget {
  final Land land;
  final VoidCallback onTap;
  final int userID;

  const LandCard({
    required this.land,
    required this.userID,
    required this.onTap,
  });

  Future<Uint8List?> _fetchLandImage() async {
    return await LandServices().getLandImage(land.id);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
                child: FutureBuilder<Uint8List?>(
                  future: _fetchLandImage(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError || snapshot.data == null) {
                      return Image.asset(
                        'assets/images/${land.landTip}.jpg',
                        fit: BoxFit.cover,
                      );
                    } else {
                      return Image.memory(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      );
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    land.landDescription,
                    style: GoogleFonts.audiowide(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${land.landTip}",
                    style: GoogleFonts.oswald(color: Colors.grey[700], fontSize: 17),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Arazi Alanı : ${land.m2} m2",
                    style: GoogleFonts.oswald(color: Colors.grey[700], fontSize: 17),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${land.mahalle.mahalleName} / ${land.mahalle.ilceId.ilceName}",
                    style: GoogleFonts.oswald(color: Colors.grey[700], fontSize: 17),
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
  }
}
