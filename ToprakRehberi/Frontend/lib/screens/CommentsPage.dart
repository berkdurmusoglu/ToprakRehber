import 'package:flutter/material.dart';
import 'package:toprak_rehberi/models/Other/Comment.dart';
import 'package:toprak_rehberi/screens/FarmingScreens/HasatDetailPage.dart';
import 'package:toprak_rehberi/screens/FarmingScreens/HasatListPage.dart';

import 'package:toprak_rehberi/screens/ProfilePage.dart';
import 'package:toprak_rehberi/services/OtherService/CommentService.dart';

class CommentsPage extends StatefulWidget {
  final int userID;
  const CommentsPage({required this.userID,super.key});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  late Future<List<Comment>> futureComments;
  CommentService commentService = CommentService();

  @override
  void initState() {
    super.initState();
    _loadEkimData();

  }

  void _loadEkimData() {
    setState(() {
      futureComments = commentService.fetchCommentsByUser(widget.userID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yorumlarım"),
        leading: IconButton(onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(userID: widget.userID),
            ),
          );
        }, icon: Icon(Icons.arrow_back)),
      ),
      backgroundColor: Color(0x80ffb7c3),
      body: FutureBuilder<List<Comment>>(
        future: futureComments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Hasat bulunamadı.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Comment comment = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    // Hasat detay sayfasına yönlendirme
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HasatDetailPage(hasatID: comment.hasat.id,userID: widget.userID,),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.all(8.0),
                    child: Container(
                      height: 350, // Kartların aynı boyutta olması için yükseklik belirledik
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hasat Edilen Ürün: ${comment.rehber.product.productName}",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text("Adres: ${comment.rehber.mahalleId.mahalleName} - ${comment.rehber.mahalleId.ilceId.ilceName}\n ${comment.rehber.mahalleId.ilceId.ilId}"),
                          SizedBox(height: 4),
                          Text("Yorum: ${comment.body}"),
                          SizedBox(height: 4),
                          Text("Verim Oranı: ${comment.rehber.sonuc}"),
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

