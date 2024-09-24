import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toprak_rehberi/models/Farming/asd.dart';
import 'package:toprak_rehberi/screens/NavigationPage.dart';
import 'package:toprak_rehberi/screens/NavigationPages/Tasks.dart';
import 'package:toprak_rehberi/services/FarmingService/HasatService.dart';
import 'package:toprak_rehberi/services/OtherService/CommentService.dart';

import '../../models/Farming/Hasat.dart';
import '../../models/Other/Comment.dart' as com;

class HasatDetailPage extends StatefulWidget {
  final int hasatID;
  final int userID;

  const HasatDetailPage({required this.hasatID,required this.userID, super.key});

  @override
  State<HasatDetailPage> createState() => _HasatDetailPageState();
}

class _HasatDetailPageState extends State<HasatDetailPage> {
  late Future<Hasat> futureHasat;
  late Future<List<com.Comment>> futureComment;
  HasatService hasatService = HasatService();
  CommentService commentService = CommentService();
  final _formKey = GlobalKey<FormState>();

  // Yorum alanını açıp kapatmak için değişken
  bool _showCommentField = false;

  // Yorum için kontrolör
  final TextEditingController _commentController = TextEditingController();

  void _loadHasatData(){
    futureHasat = hasatService.fetchHasat(widget.hasatID);
    futureComment = commentService.fetchCommentsByHasat(widget.hasatID);
  }
  @override
  void initState() {
    super.initState();
    _loadHasatData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x80d3fac7),
      appBar: AppBar(title: Text("Ekim Detayı"),
      leading: IconButton(onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NavigationPage(userId: widget.userID,initialIndex:2,),
          ),
        );
      }, icon: Icon(Icons.arrow_back)),),
      body: FutureBuilder<Hasat>(
        future: futureHasat,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final hasat = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 20,10,20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Image.asset(
                        'assets/images/basicProduct.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Ürün Adı: ${hasat.ekimId.product.productName}",
                            style: GoogleFonts.audiowide(fontSize: 33)),
                        SizedBox(height: 8),
                        Text("Ekim Tarihi: ${hasat.ekimId.ekimTarihi.day}/${hasat.ekimId.ekimTarihi.month}/${hasat.ekimId.ekimTarihi.year}",
                            style: TextStyle(fontSize: 18)),
                        SizedBox(height: 8),
                        Text("Hasat Tarihi: ${hasat.hasatTarihi.day}/${hasat.hasatTarihi.month}/${hasat.hasatTarihi.year}",
                            style: TextStyle(fontSize: 18)),
                        SizedBox(height: 8),
                        Text("Hasat Yapılan Arazi: ${hasat.ekimId.land.landDescription}",
                            style: TextStyle(fontSize: 18)),
                        Text(
                            "Arazi Adresi: ${hasat.ekimId.land.mahalle
                                .mahalleName} / ${hasat.ekimId.land.mahalle.ilceId
                                .ilceName}",
                            style: TextStyle(fontSize: 18)),
                        Text("${hasat.ekimId.land.mahalle.ilceId.ilId}",
                            style: TextStyle(fontSize: 18)),
                        Text("Hasat Miktarı: ${hasat.hasatMiktari}",
                            style: TextStyle(fontSize: 18)),
                        Text("Hasat Sonucu: ${hasat.hasatSonuc}",
                            style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Yorum butonu
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showCommentField = !_showCommentField; // Yorum alanını aç/kapat
                        });
                      },
                      child: Text(_showCommentField ? "Yorumu Kapat" : "Yorum Yap"),
                    ),

                    // Yorum alanı gösterildiğinde ekrana TextField gelir
                    if (_showCommentField)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _commentController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                labelText: "Yorumunuzu yazın",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () async {
                                if (_commentController.text.isNotEmpty) {
                                  try {
                                    int id = await CommentService().addLand(_commentController.text, hasat.ekimId.land.user.id, hasat.ekimId.product.id, hasat.ekimId.land.mahalle.id,hasat.id);
                                    print("Yorum başarıyla kaydedildi. ID: $id");
                                    setState(() {
                                      _commentController.clear();
                                      _showCommentField = false; // Yorum alanı kapatılır
                                    });

                                    // Kullanıcıya başarı mesajı göster
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Yorum başarıyla gönderildi!")),
                                    );
                                    _loadHasatData();

                                  } catch (e) {
                                    // Hata durumunda kullanıcıya hata mesajı göster
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Yorum gönderilemedi! Hata: $e")),
                                    );
                                    _loadHasatData();
                                    setState(() {
                                      _commentController.clear();
                                      _showCommentField = false; // Yorum alanı kapatılır
                                    });
                                  }
                                } else {
                                  // Yorum boşsa uyarı gösterebilir
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Yorum boş olamaz!")),
                                  );
                                }
                              },
                              child: Text("Yorumu Gönder"),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    Text("Yorumlar", style: GoogleFonts.audiowide(fontSize: 22)),
                    const SizedBox(height: 10),
                    FutureBuilder<List<com.Comment>>(
                      future: futureComment,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text("Yorumlar yüklenemedi: ${snapshot.error}"));
                        } else if (snapshot.hasData) {
                          final comments = snapshot.data!;
                          if (comments.isEmpty) {
                            return const Text("Henüz yorum yapılmamış.");
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              final comment = comments[index];
                              return Card(
                                child: ListTile(
                                  title: Text(comment.body),
                                  subtitle: Text("Verim Oranı: ${comment.rehber.sonuc}"),
                                ),
                              );
                            },
                          );
                        } else {
                          return const Text("Yorum bulunamadı.");
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('Veri bulunamadı'));
          }
        },
      ),
    );
  }
}