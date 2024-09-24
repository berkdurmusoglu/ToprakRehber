import 'package:flutter/material.dart';
// Comment modelinizi ekleyin
import 'dart:convert'; // JSON parse işlemleri için
import 'package:http/http.dart' as http;
import 'package:toprak_rehberi/services/OtherService/CommentService.dart';

import '../../models/Farming/Rehber.dart';
import '../../models/Other/Comment.dart' as com; // HTTP istekleri için

class RehberDetailPage extends StatefulWidget {
  final Rehber rehber;
  final Color backgroundColor;

  const RehberDetailPage({required this.rehber, required this.backgroundColor, Key? key}) : super(key: key);

  @override
  _RehberDetailPageState createState() => _RehberDetailPageState();
}

class _RehberDetailPageState extends State<RehberDetailPage> {
  late Future<List<com.Comment>> futureComments;
  CommentService commentService = CommentService();

  @override
  void initState() {
    super.initState();
    futureComments = commentService.fetchCommentsByRehber(widget.rehber.id);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ürün Detayları'),
        backgroundColor: widget.backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: widget.rehber.product.image != null
                    ? Image.network(
                  widget.rehber.product.image!,
                  height: 250,
                  width: 250,
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
              SizedBox(height: 20),
              Text('Ürün Adı: ${widget.rehber.product.productName}', style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              Text('Önerilen Ekim Mevsimi: ${widget.rehber.product.ekimMevsimi}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('Önerilen Hasat Mevsimi: ${widget.rehber.product.hasatMevsimi}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('Sonuç: ${widget.rehber.sonuc.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),

              // Yorumlar Bölümü
              Text('Yorumlar:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              FutureBuilder<List<com.Comment>>(
                future: futureComments,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Henüz yorum yok.'));
                  } else {
                    List<com.Comment> comments = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true, // Scrollable alanın boyutunu sınırlamak için
                      physics: NeverScrollableScrollPhysics(), // Dikey kaydırma devre dışı
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        com.Comment comment = comments[index];
                        return Card(
                          color: Colors.green,
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text(comment.user.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(comment.body),
                                Text('Tarih: ${comment.createdDate.day} / ${comment.createdDate.month} / ${comment.createdDate.year}'),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
