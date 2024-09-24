
import 'package:flutter/material.dart';


import 'package:toprak_rehberi/services/AuthService/LoginService.dart';

import '../../widgets/CustomTextField.dart';
import '../NavigationPage.dart';
import 'RegisterScreen.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final LoginService loginService = LoginService();
  RegExp  get _emailRegex => RegExp ( r'^\S+@\S+$' );

  Future<void> _login() async {
    final String mail = mailController.text;
    final String password = passwordController.text;

    if (_formKey.currentState!.validate()) { // Form doğrulaması
      try {
        final int userID = await loginService.loginUser(mail, password);
        // Giriş başarılı olunca mesaj göstermek
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Giriş Başarılı Hoşgeldiniz'),
          ),
        );

        // Sayfa yönlendirmesi asenkron işlemden sonra yapılmalı
        if (!mounted) return; // Ekranın hala aktif olduğundan emin ol
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NavigationPage(userId: userID,initialIndex: 0,),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hatalı Mail veya Şifre')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arka plan resmi
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/a2.jpg'), // Arka plan resmini buraya ekleyin
                fit: BoxFit.cover,
              ),
            ),
          ),
          // İçerik
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextField(
                      labelText: 'E-Mail',
                      controller: mailController,
                      validator: (value) {
                        if (!_emailRegex.hasMatch(value!)) {
                          return 'E-posta adresi geçerli değil';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      labelText: 'Şifre',
                      controller: passwordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length < 6) {
                          return 'Şifrenizi kontrol edin';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          print('UYgunnnnnn');
                          _login();
                        }
                      },
                      child: const Text(
                        'Giriş Yap',
                        style: TextStyle(color: Color(0xffE0E0D8),fontSize: 35), // Metin stili
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff629FAF), // Arka plan rengi
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // Kenar köşe yuvarlatma
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                          "Yeni Hesap Oluştur",
                          style: TextStyle(fontSize: 20,color: Color(0xff1a474f))),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
