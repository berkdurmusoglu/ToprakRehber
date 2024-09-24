import 'dart:async';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toprak_rehberi/models/Other/Comment.dart';
import 'package:toprak_rehberi/screens/FarmingScreens/EkimDetailPage.dart';
import 'package:toprak_rehberi/services/FarmingService/EkimService.dart';
import 'package:toprak_rehberi/services/OtherService/CommentService.dart';

import '../../models/Farming/Ekim.dart';

class HomeScreen extends StatefulWidget {
  final int userID;

  const HomeScreen({required this.userID, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Ekim>> futureEkim;
  late Future<List<Comment>> futureComments;
  int _currentIndex = 0;
  EkimService ekimService = EkimService();
  CommentService commentService = CommentService();

  @override
  void initState() {
    super.initState();
    futureEkim = ekimService.fetchEkimUserID(widget.userID);
    futureComments = commentService.fetchCommentsDesc(widget.userID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ana Sayfa"),
      backgroundColor: Colors.teal,),
      body: Column(
        children: [
          // Diğer UI elemanları
          FutureBuilder<List<Ekim>>(
            future: futureEkim,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                List<Ekim> ekimler = snapshot.data!;

                return Column(
                  children: [
                    SizedBox(height: 20),
                    CarouselSlider.builder(
                      itemCount: ekimler.length,
                      itemBuilder: (context, index, realIndex) {
                        Ekim ekim = ekimler[index];
                        DateFormat trDate = DateFormat.yMMMMd('tr_TR');
                        String newDate = trDate.format(ekim.ekimTarihi);

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EkimDetailPage(ekimID: ekim.id),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 100,
                                  height: 120,
                                  margin: EdgeInsets.only(right: 10.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/basicProduct.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        ekim.product.productName,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text('Ekim Alanı: ${ekim.m2} kg'),
                                      SizedBox(height: 8),
                                      Text('Ekim Tarihi: $newDate'),
                                      SizedBox(height: 8),
                                      Text(
                                        'Ekim Yapılan Arazi: ${ekim.land
                                            .landDescription}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                      ),
                                      SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: 220,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        autoPlayInterval: Duration(seconds: 3),
                        viewportFraction: 0.8,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: ekimler
                          .asMap()
                          .entries
                          .map((entry) {
                        return GestureDetector(
                          onTap: () =>
                              setState(() {
                                _currentIndex = entry.key;
                              }),
                          child: Container(
                            width: 12.0,
                            height: 12.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (_currentIndex == entry.key
                                  ? Colors.green
                                  : Colors.grey),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                );
              }
            },
          ),
          Icon(Icons.add_a_photo,size: 200,),
          // Yeni eklediğiniz Yorumlar Bölümü
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(15,0,0,0),
                  child: Text(
                    'Geri Dönüşler', // Başlık
                    style: TextStyle(
                      fontSize: 24.0, // Yazı boyutu
                      fontWeight: FontWeight.bold, // Kalın yazı tipi
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100, // Arka plan rengi
                      borderRadius: BorderRadius.circular(10.0), // Köşeleri yuvarlat
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // Gölge rengi
                          spreadRadius: 5, // Gölge yayılma oranı
                          blurRadius: 7, // Gölge bulanıklık
                          offset: Offset(0, 3), // Gölgenin pozisyonu
                        ),
                      ],
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 10.0), // Dış boşluk
                    padding: EdgeInsets.all(10.0),
                    child: FutureBuilder<List<Comment>>(
                      future: futureComments, // Yorumları yükleyin
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Yorumlar Yüklenemedi: ${snapshot.error}'));
                        } else {
                          List<Comment> comments = snapshot.data!;

                          return ListView.builder(
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              Comment comment = comments[index];
                              String maskedUserName = comment.hasat.ekimId.land.user.name[0] + '***';
                              return Card(
                                color: Colors.yellow.shade200,
                                margin: EdgeInsets.symmetric(vertical: 10.0,
                                    horizontal: 15.0),
                                child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [

                                          Text(
                                            comment.hasat.ekimId.product.productName,
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            DateFormat.yMMMMd('tr_TR').format(comment.createdDate),
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Yorumun taşmasını önlemek ve alt satıra geçmesini sağlamak
                                          Expanded(
                                            child: Text(
                                              comment.body,
                                              softWrap: true, // Alt satıra geçmesini sağlar
                                              overflow: TextOverflow.visible, // Taşmayı engeller
                                            ),
                                          ),
                                          Text(
                                            " %${comment.rehber.sonuc}",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          // Maskelenmiş kullanıcı adı
                                          Text(
                                            maskedUserName,
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            " - ",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "${comment.hasat.ekimId.land.mahalle.ilceId.ilId} / ${comment.hasat.ekimId.land.mahalle.ilceId.ilceName}",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}