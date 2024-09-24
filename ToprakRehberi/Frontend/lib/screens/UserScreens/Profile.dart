import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:toprak_rehberi/screens/AuthScreens/LoginScreen.dart';
import 'package:toprak_rehberi/services/UserService/UserService.dart';

class Profile extends StatefulWidget {
  final int userID;

  const Profile({required this.userID, super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isEditing = false;
  UserService userservice = UserService();

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _loadUser();
  }

  Future<bool> _showImageChangeDialog() async {
    bool shouldChange = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      // Diyalog dışına tıklanarak kapatılmasını engeller
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Profil Resmi Değiştir'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Profil resminizi değiştirmek istediğinizden emin misiniz?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('İptal'),
              onPressed: () {
                shouldChange = false; // Kullanıcı iptal etti
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Değiştir'),
              onPressed: () {
                shouldChange = true; // Kullanıcı değiştirmek istedi
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    return shouldChange;
  }

  final ImagePicker _picker = ImagePicker();
  Uint8List? _profileImage;

  Future<void> _loadProfileImage() async {
    Uint8List? image = await userservice.getUserProfileImage(widget.userID);
    setState(() {
      _profileImage = image;
    });
  }

  Future<void> _loadUser() async {
    // API çağrısı yaparak mevcut kullanıcı bilgilerini al
    final userData = await userservice.getUser(widget.userID);
    setState(() {
      nameController.text = userData.name;
      mailController.text = userData.mail;
      phoneController.text = userData.telNo;
    });
  }

  Future<void> _pickAndUploadImage() async {
    try {
      // Pick an image
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        // Convert the picked image to a File
        File imageFile = File(image.path);

        // Call the addImage method with the selected file and userId
        bool shouldUpload = await _showImageChangeDialog();

        // Eğer kullanıcı "Değiştir" seçeneğine tıklamışsa resmi yükle
        if (shouldUpload) {
          await userservice.uploadImage(imageFile, widget.userID);
          _loadProfileImage();
        } else {
          print('Kullanıcı resim değişikliğini iptal etti.');
        }
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking or uploading image: $e');
    }
  }

  Future<void> _showChangePAssword() async {
    TextEditingController mailController = TextEditingController();
    TextEditingController telNoController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Şifreyi Değiştir'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'E-Mail'),
                controller: mailController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Telefon'),
                controller: telNoController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Eski Şifre'),
                controller: passwordController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Yeni Şifre'),
                controller: newPasswordController,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await userservice.changePassword(
                      widget.userID,
                      mailController.text,
                      telNoController.text,
                      passwordController.text,
                      newPasswordController.text);
                  Navigator.pop(context);
                } catch (e) {
                  Navigator.pop(context);
                }
              },
              child: Text('Şifreyi Değiştir'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateUser() async {
    if (!isEditing) return;

    final String name = nameController.text;
    final String mail = mailController.text;
    final String phone = phoneController.text;

    try {
      final bool isUpdated =
          await userservice.updateUser(widget.userID, name, mail, phone);
      print('Kullanıcı Güncellendi: ${widget.userID}');
    } catch (e) {
      print('Hata');
    }
  }

  void _loadUserData() {
    _loadProfileImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAF4F4),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, // İkon rengi siyah yapıldı
        ),
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.black), // Başlık rengi siyah
        ),
        backgroundColor: Colors.transparent,
        // Şeffaf appbar
        elevation: 0,
        // Gölge yok
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isEditing = !isEditing; // Düzenleme modunu değiştir
              });
            },
            icon: Icon(
                isEditing ? Icons.check : Icons.edit), // Buton ikonunu değiştir
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8,16,8,16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              // Profil Resmi
              Stack(
                children: [
                  Container(
                    width: 170, // Daha küçük boyutlar ayarlandı
                    height: 200,

                    child: _profileImage != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(15), // Aynı yuvarlatılmış köşeler
                      child: Image.memory(
                        _profileImage!,
                        fit: BoxFit.cover,
                      ),
                    )
                        : Center(child: Text('No profile image found')),
                  ),

                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 20, // Daha küçük ikon
                      backgroundColor: Colors.orange[200],
                      child: IconButton(
                        icon: Icon(Icons.add_a_photo, color: Colors.white),
                        onPressed: () => _pickAndUploadImage(),
                      ),
                    ),
                  ),

                ],
              ),

              SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.person, color: Colors.grey),
                      title: TextField(
                        controller: nameController,
                        readOnly: !isEditing,
                        // Sadece düzenleme modunda düzenlenebilir
                        decoration: InputDecoration(
                            labelText: 'İsim',
                            labelStyle: TextStyle(
                                fontSize: 25, color: Color(0xff629FAF))),
                        style: TextStyle(
                            fontSize: 20,
                            color: isEditing ? Colors.black: Colors.grey),
                      ),
                    ),
                    Divider(thickness: 1),
                    ListTile(
                      leading: Icon(Icons.email, color: Colors.grey),
                      title: TextField(
                        controller: mailController,
                        readOnly: !isEditing,
                        decoration: InputDecoration(
                            labelText: 'Mail',
                            labelStyle: TextStyle(
                                fontSize: 25, color: Color(0xff629FAF))),
                        style: TextStyle(
                            fontSize: 20,
                            color: isEditing ? Colors.black : Colors.grey),
                      ),
                    ),
                    Divider(thickness: 1),
                    ListTile(
                      leading: Icon(Icons.phone, color: Colors.grey),
                      title: TextField(
                        controller: phoneController,
                        readOnly: !isEditing,
                        decoration: InputDecoration(
                          labelText: 'Telefon',
                          labelStyle:
                          TextStyle(fontSize: 25, color: Color(0xff629FAF)),
                        ),
                        style: TextStyle(
                            fontSize: 20,
                            color: isEditing ? Colors.black: Colors.grey),
                      ),
                    ),
                    Divider(thickness: 0.5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end, // Butonu sağa yaslamak için
                      children: [
                        TextButton(
                          onPressed: () => _showChangePAssword(),
                          child: Text("Şifremi Değiştirmek İstiyorum."),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(thickness: 1),



              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Loginscreen(),
                    ),
                  );
                },
                child: Text("Çıkış Yap."),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(370, 50), // Butonu yatay olarak uzatır
                  side: BorderSide(color: Colors.black, width: 2), // Siyah çerçeve
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // İsterseniz köşeleri yuvarlayabilirsiniz
                  ),
                ),
              )
            ],
          ),
        ),
          ),

    );
  }
}
