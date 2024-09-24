import 'package:flutter/material.dart';
import 'package:toprak_rehberi/models/Farming/Ekim.dart';
import 'package:toprak_rehberi/screens/AuthScreens/LoginScreen.dart';
import 'package:toprak_rehberi/screens/CommentsPage.dart';
import 'package:toprak_rehberi/screens/FarmingScreens/EkimDetailPage.dart';

import 'package:toprak_rehberi/screens/LandScreens/LandDetailPage.dart';
import 'package:toprak_rehberi/screens/NavigationPage.dart';
import 'package:toprak_rehberi/services/FarmingService/EkimService.dart';
import 'package:toprak_rehberi/services/FarmingService/HasatService.dart';
import 'package:toprak_rehberi/services/LandService/LandService.dart';
import 'package:toprak_rehberi/services/UserService/UserService.dart';

import '../models/Farming/Hasat.dart';
import '../models/Land/Land.dart' as lnd;
import '../models/User/User.dart';

class ProfilePage extends StatefulWidget {
  final int userID;

  const ProfilePage({required this.userID, super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<User> futureUser;
  late Future<List<lnd.Land>> futureLands;
  late Future<List<Ekim>> futureEkim;
  late Future<List<Hasat>> futureHasat;
  final UserService userService = UserService();
  final LandServices landServices = LandServices();
  final EkimService ekimService = EkimService();
  final HasatService hasatService = HasatService();


  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    futureUser = userService.getUser(widget.userID);
    futureLands = landServices.fetchLands(widget.userID);
    futureEkim = ekimService.fetchEkimUserID(widget.userID);
    futureHasat = hasatService.fetchHasatByuserID(widget.userID);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(

        title: Text("Hoşgeldiniz"),
        leading: IconButton(onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NavigationPage(userId: widget.userID,initialIndex: 2,),
            ),
          );
        }, icon: Icon(Icons.arrow_back)),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommentsPage(userID: widget.userID),
              ),
            );
          }, icon: Icon(Icons.comment),iconSize: 35,),
          IconButton(onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Loginscreen()),
                  (Route<dynamic> route) => false,
            );
          }, icon: Icon(Icons.logout),iconSize: 35,),

        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<User>(
                future: futureUser,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    return _buildUserDetails(snapshot.data!);
                  } else {
                    return Center(child: Text('User data not found.'));
                  }
                },
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Arazilerim",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NavigationPage(userId: widget.userID,initialIndex: 0,), // 1, "Arazilerim" sekmesi
                      ),
                    );
                  }, child: Text("Tüm Arazilerim",
                    style: TextStyle(color: Colors.green),))
                ],
              ),
              SizedBox(height: 16),

              // **FutureBuilder with horizontal ListView for Lands**
              FutureBuilder<List<lnd.Land>>(
                future: futureLands,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text("Error loading fields");
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text("No fields found");
                  } else {
                    final lands = snapshot.data!;
                    return SizedBox(
                      height: 150, // Sabit yükseklik
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal, // Yatay liste
                        itemCount: lands.length,
                        itemBuilder: (context, index) {
                          final land = lands[index];
                          return GestureDetector(
                            onTap: () {
                              // Tıklama işlemi
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LandDetailPage(userID: widget.userID,landID: land.id),
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
                                    image: AssetImage('assets/images/${land.landTip}.jpg'),
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
                                      "${land.landDescription}\n${land.m2} m2", // Arazi adı ve büyüklüğü
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),


              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ekimlerim",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NavigationPage(userId: widget.userID,initialIndex: 3,),
                      ),
                    );
                  }, child: Text("Tüm Ekimlerim",
                    style: TextStyle(color: Colors.green),))
                ],
              ),
              // Current Tasks Section
              FutureBuilder<List<Ekim>>(
                future: futureEkim,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text("No fields found");
                  } else {
                    final ekimler = snapshot.data!;
                    return SizedBox(
                      height: 150, // Sabit yükseklik
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal, // Yatay liste
                        itemCount: ekimler.length,
                        itemBuilder: (context, index) {
                          final ekim = ekimler[index];
                          return GestureDetector(
                            onTap: () {
                              // Tıklama işlemi
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
                                    child: Text(
                                      "${ekim.product.productName}\n${ekim.ekimTarihi.day}/${ekim.ekimTarihi.month}/${ekim.ekimTarihi.year}", // Arazi adı ve büyüklüğü
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hasatlarım",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NavigationPage(userId: widget.userID,initialIndex: 3,),
                      ),
                    );
                  }, child: Text("Tüm Hasatlarım",
                    style: TextStyle(color: Colors.green),))
                ],
              ),
              // Current Tasks Section
              FutureBuilder<List<Ekim>>(
                future: futureEkim,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text("Error loading fields");
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text("No fields found");
                  } else {
                    final hasatlar = snapshot.data!;
                    return SizedBox(
                      height: 150, // Sabit yükseklik
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal, // Yatay liste
                        itemCount: hasatlar.length,
                        itemBuilder: (context, index) {
                          final hasat = hasatlar[index];
                          return GestureDetector(
                            onTap: () {

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
                                      "${hasat.product.productName}\n Ekim Tarihi : ${hasat.ekimTarihi.day}/${hasat.ekimTarihi.month}/${hasat.ekimTarihi.year}", // Arazi adı ve büyüklüğü
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
              Column(
                children: [

                ],
              )
            ],
          ),
        ),
      ),

    );
  }

}
class EkimCard extends StatelessWidget {
  final int userID;

  const EkimCard({Key? key, required this.userID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(
            "Ekim",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              "",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildUserDetails(User user) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Color(0xff629FAF),
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Üstten hizalama
      children: [
        // Expanded ile metin alanını genişletiyoruz
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.person, color: Color(0xff1a474f), size: 25),
                  SizedBox(width: 10),
                  Expanded(  // İkonun yanında esneklik sağlıyoruz
                    child: Text(
                      user.name.toUpperCase(),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.mail, color: Color(0xff1a474f), size: 25),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      user.mail,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.phone_android, color: Color(0xff1a474f), size: 25),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      user.telNo,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // İkon alanı, metinlerin yanında sabit genişlikte kalacak
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.add_a_photo, size: 110),
        ),
      ],
    ),
  );
}
