import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toprak_rehberi/screens/NavigationPage.dart';
import 'package:toprak_rehberi/services/AuthService/RegisterService.dart';

import '../../widgets/CustomTextField.dart';

import 'LoginScreen.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController telNoController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  RegisterService registerService = RegisterService();

  RegExp get _emailRegex =>
      RegExp(
          r'^[a-zA-Z0-9._%+-]+@(gmail\.com|hotmail\.com|yahoo\.com|outlook.com)$');

  Future<void> _register() async {
    final String name = nameController.text;
    final String telNo = telNoController.text;
    final String mail = mailController.text;
    final String password = passwordController.text;

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Passwords do not match!'),
        ),
      );
      return;
    }
    try {
      final int userID = await registerService.registerUser(
          name, telNo, mail, password);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text("Kayıt Başarılı. Hoşgeldiniz"),),);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NavigationPage(userId: userID,initialIndex: 0,),
        ),
      );
    }catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hatalı Kayıt')),
      );
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
                image: AssetImage('assets/images/a2.jpg'),
                // Arka plan resmini buraya ekleyin
                fit: BoxFit.cover,
              ),
            ),
          ),
          // İçerik
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(
                    labelText: "İsim",
                    controller: nameController,
                    prefixIcon: Icons.abc,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 3) {
                        return value!.isEmpty
                            ? 'Lütfen isminizi girin'
                            : "İsminizi kontrol edin.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    labelText: 'Telefon Numarası',
                    controller: telNoController,
                    prefixIcon: Icons.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty ||
                          value.length != 11) {
                        return value!.isEmpty
                            ? 'Lütfen telefon numaranızı girin'
                            : "Telefon Numaranızı kontrol edin.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    labelText: 'E-posta',
                    controller: mailController,
                    prefixIcon: Icons.mail,
                    validator: (value) {
                      if (!_emailRegex.hasMatch(value!)) {
                        return 'E-posta adresi geçerli değil';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    labelText: 'Şifre',
                    controller: passwordController,
                    obscureText: true,
                    prefixIcon: Icons.lock,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 6) {
                        return value!.isEmpty
                            ? 'Lütfen bir şifre oluşturun'
                            : "Şifre geçerli değil, daha uzun bir şifre deneyin.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    labelText: 'Şifre Kontrol',
                    controller: confirmPasswordController,
                    obscureText: true,
                    prefixIcon: Icons.lock,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen şifrenizi tekrar girin.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _register();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Loginscreen(),
                        ),
                      );
                    }
                  },
                    child: Text('Kayıt Ol', style: TextStyle(
                        color: Color(0xffE0E0D8), fontSize: 35)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff629FAF), // Arka plan rengi
                      padding: EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            12), // Kenar köşe yuvarlatma
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Loginscreen(),
                        ),
                      );
                    },
                    child: Text(
                        "Zaten bir hesabınız var mı",
                        style: TextStyle(
                            fontSize: 20, color: Color(0xff1a474f))),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}