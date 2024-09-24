import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:toprak_rehberi/screens/AuthScreens/LoginScreen.dart';
import 'package:toprak_rehberi/screens/AuthScreens/RegisterScreen.dart';
import 'package:toprak_rehberi/screens/FarmingScreens/EkimCreationPage.dart';

import 'package:toprak_rehberi/screens/NavigationPage.dart';
import 'package:toprak_rehberi/screens/NavigationPages/Tasks.dart';

void main()  async{

  await initializeDateFormatting('tr_TR', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NavigationPage(userId: 2,initialIndex: 1,),
    );

  }
}

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
          ),
          // İçerik
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Başlık
              Padding(
                padding: const EdgeInsets.only(top: 280),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        'Toprak',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1a474f),
                        ),
                      ),
                      Text(
                        'Rehberi',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1a474f),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff629FAF), // Buton rengi
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Kayıt Ol',
                        style:
                        TextStyle(fontSize: 30, color: Color(0xffE0E0D8)),
                      ),
                    ),
                    SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: () {
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff629FAF), // Buton rengi
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Zaten Bir Hesabınız Var Mı? Giriş Yap',
                        style:
                        TextStyle(color: Color(0xffE0E0D8), fontSize: 15),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}

