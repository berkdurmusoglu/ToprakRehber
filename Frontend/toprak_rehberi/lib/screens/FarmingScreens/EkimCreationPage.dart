import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toprak_rehberi/screens/FarmingScreens/EkimListPage.dart';
import 'package:toprak_rehberi/screens/NavigationPage.dart';
import 'package:toprak_rehberi/screens/NavigationPages/Tasks.dart';
import 'package:toprak_rehberi/services/FarmingService/EkimService.dart';
import 'package:toprak_rehberi/services/LandService/LandService.dart';
import 'package:toprak_rehberi/widgets/DropdownSearchWidgets/MevsimSonbaharDropdown.dart';
import 'package:toprak_rehberi/widgets/DropdownSearchWidgets/MevsimİlkbaharDropdown.dart';
import 'package:toprak_rehberi/widgets/DropdownSearchWidgets/ProductDropdownSearch.dart';
import 'package:toprak_rehberi/widgets/DropdownWidgets/LandsDropdown.dart';

import '../../models/Land/Land.dart';
import '../../models/Other/Product.dart' as prd;
import '../../widgets/DropdownWidgets/RehberDropdown.dart';


class EkimCreationPage extends StatefulWidget {
  final int userID;
  final Land? land;

  const EkimCreationPage({required this.userID, this.land, super.key});

  @override
  State<EkimCreationPage> createState() => _EkimCreationPageState();
}

class _EkimCreationPageState extends State<EkimCreationPage> {
  Land? selectedLand; // Kullanıcının seçtiği araziyi tutacak değişken

  @override
  void initState() {
    super.initState();
    selectedLand =
        widget.land; // Başlangıçta parametre ile gelen araziyi kullan
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (selectedLand == null) {
        // Eğer land null ise arazi seçimi için dialog göster
        showSelectLandDialog();
      }
    });
  }

  // Arazi seçimi için dialog göster
  Future<void> showSelectLandDialog() async {
    Land? selected = await showDialog<Land>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bir arazi seçin'),
          content: LandsDropdown(
            userID: widget.userID,
            onLandSelected: (Land land) {
              Navigator.of(context).pop(land);
            },
          ),
        );
      },
    );

    if (selected != null && selected != selectedLand) {
      setState(() {
        selectedLand = selected;
        // Seçilen araziyi güncelle
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        NavigationPage(userId: widget.userID, initialIndex: 1),
                  ),
                );
              },
              icon: Icon(Icons.arrow_back),
            ),
            actions: [
              IconButton(onPressed: showSelectLandDialog,
                  icon: Icon(Icons.edit_location))
            ],
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car), text: "Ürün Listesi ile"),
                Tab(icon: Icon(Icons.directions_transit),
                    text: "Toprak Rehberi ile"),
                Tab(icon: Icon(Icons.directions_bike),
                    text: "Mevsim Listesi ile"),
              ],
            ),
            title: const Text('Ekim Oluştur'),
          ),
          body: selectedLand == null
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Lütfen bir arazi seçin"),
                ElevatedButton(
                  onPressed: showSelectLandDialog,
                  child: Text("Arazi Seç"),
                ),
              ],
            ),
          )
              : Column(
            children: [
              // Arazi bilgilerini üstte göster
              SelectedLandInfo(land: selectedLand!),
              Expanded(
                child: TabBarView(
                  children: [
                    // selectedLand güncellenince sayfalar da yeniden oluşturulacak
                    withProductList(
                      userID: widget.userID,
                      land: selectedLand!,

                    ),
                    withRehberList(
                      userID: widget.userID,
                      land: selectedLand!,

                    ),
                    withMevsimList(
                      userID: widget.userID,
                      land: selectedLand!,

                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectedLandInfo extends StatelessWidget {
  final Land land;
  final Uint8List? imageData;

  const SelectedLandInfo({required this.land, this.imageData,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border(
          bottom: BorderSide(
              color: Colors.grey,
              width: 1.0
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Seçilen Arazi: ${land.landDescription}', // Arazi adını göster
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
          ),
          SizedBox(height: 3,),
          Text('Büyüklüğü: ${land.m2} m2',
              style: TextStyle(fontSize: 16),),
          SizedBox(height: 5,),

          imageData != null
          ? ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.memory(
          imageData!,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
        ),
      )
          : ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          'assets/images/${land.landTip}.jpg', // Default resmi burada belirtin
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
        ),
      ),
          SizedBox(height: 5,),

          Text('Ekime Uygun Alan: ${land.ekimM2} m2',
            style: TextStyle(fontSize: 16),),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Arazi Adresi: ${land.mahalle.mahalleName} - ${land.mahalle.ilceId.ilceName}',
                style: TextStyle(fontSize: 16),),
              Text("${land.mahalle.ilceId.ilId} ",
                style: TextStyle(fontSize: 16),),
            ],
          ),
          ],
      ),
    );
  }
}

class withProductList extends StatefulWidget {
  final int userID;
  final Land? land;

  const withProductList({required this.userID, this.land, super.key});

  @override
  State<withProductList> createState() => _withProductListState();
}

class _withProductListState extends State<withProductList> {
  TextEditingController ekimM2Controller = TextEditingController();
  prd.Product? selectedProduct;
  DateTime? selectedDate;
  EkimService ekimService = EkimService();
  final LandServices landService = LandServices();
  late int landID;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Ekim yapılacak alanın büyüklüğü:',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                  controller: ekimM2Controller,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bu alanı doldurmanız gerekiyor';
                    }
                    final number = num.tryParse(value);
                    if (number == null) {
                      return 'Lütfen geçerli bir sayı girin';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Tarih Seçici
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(selectedDate == null
                        ? 'Tarih Seçilmedi'
                        : 'Seçilen Tarih: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}'), // Tarih formatı sadece gün/ay/yıl olacak
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2.0), // Daha belirgin kenar
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              selectedDate = pickedDate;
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Text('Tarih Seç'),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ProductDropdown(
                  onChanged: (prd.Product? product) {
                    setState(() {
                      selectedProduct = product;
                    });
                  },
                  selectedProduct: selectedProduct,
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('İptal'),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          if (selectedProduct != null &&
                              ekimM2Controller.text.isNotEmpty &&
                              selectedDate != null) {
                            try {
                              await ekimService.createEkim(
                                  widget.land?.id ?? landID,
                                  selectedProduct!.id.toString(),
                                  ekimM2Controller.text,
                                  selectedDate!.toIso8601String());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TaskList(userID: widget.userID)),
                              );
                            } catch (e) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TaskList(userID: widget.userID)),
                              );
                            }
                          } else {
                            print('Tüm Boşlukları Doldurunuz');
                          }
                        }
                      },
                      child: Text('Ekim Oluştur'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class withMevsimList extends StatefulWidget {
  final int userID;
  final Land? land;

  const withMevsimList({required this.userID, this.land, super.key});

  @override
  State<withMevsimList> createState() => _withMevsimListState();
}

class _withMevsimListState extends State<withMevsimList> {
  TextEditingController ekimM2Controller = TextEditingController();
  dynamic selectedProduct;
  DateTime? selectedDate;
  EkimService ekimService = EkimService();
  late int landID;
  final _formKey = GlobalKey<FormState>();
  bool isSpring = true;
  List<bool> isSelected = [true, false];


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          // Padding eklendi
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ToggleButtons(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text('İlkbahar'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text('Sonbahar'),
                  ),
                ],
                isSelected: isSelected,
                onPressed: (int index) {
                  setState(() {
                    isSelected = [index == 0, index == 1];
                    isSpring = index == 0;
                    selectedProduct = null;
                  });
                },
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,


                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Ekim yapılacak alanın büyüklüğü:',
                      ),
                      controller: ekimM2Controller,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bu alanı doldurmanız gerekiyor';
                        }
                        final number = num.tryParse(value);
                        if (number == null) {
                          return 'Lütfen geçerli bir sayı girin';
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(selectedDate == null
                            ? 'Tarih Seçilmedi'
                            : 'Seçilen Tarih: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}'), // Tarih formatı sadece gün/ay/yıl olacak
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 2.0), // Daha belirgin kenar
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  selectedDate = pickedDate;
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: Text('Tarih Seç'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (isSpring)
                      IlkbaharSearch(
                        onChanged: (product) {
                          setState(() {
                            selectedProduct = product;
                          });
                        },
                      )
                    else
                      SonbaharSearch(
                        onChanged: (product) {
                          setState(() {
                            selectedProduct = product;
                          });
                        },
                      ),
                    widget.land != null
                        ? Text(
                        "Seçilen Arazi ID:  ${widget.land?.landDescription}")
                        : LandsDropdown(
                      onLandSelected: (Land land) {
                        setState(() {
                          landID = land.id;
                        });
                      },
                      userID: widget.userID,
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('İptal'),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              if (selectedProduct != null &&
                                  ekimM2Controller.text.isNotEmpty &&
                                  selectedDate != null) {
                                try {
                                  await ekimService.createEkim(
                                      widget.land?.id ?? landID,
                                      selectedProduct!.id.toString(),
                                      ekimM2Controller.text,
                                      selectedDate!.toIso8601String());
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TaskList(
                                                userID: widget.userID)),
                                  );
                                } catch (e) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TaskList(
                                                userID: widget.userID)),
                                  );
                                }
                              } else {
                                print('Tüm Boşlukları Doldurunuz');
                              }
                            }
                          },
                          child: Text('Ekim Oluştur'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class withRehberList extends StatefulWidget {
  final Land? land;
  final int userID;

  withRehberList({required this.land, required this.userID, super.key});

  @override
  _withRehberListState createState() => _withRehberListState();
}

class _withRehberListState extends State<withRehberList> {
  TextEditingController ekimM2Controller = TextEditingController();
  DateTime? selectedDate;
  EkimService ekimService = EkimService();
  late Land selectedLand;
  final _formKey = GlobalKey<FormState>();
  int? selectedProductId;

  @override
  void initState() {
    super.initState();
    selectedLand = widget.land!;
  }

  @override
  void didUpdateWidget(covariant withRehberList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Eğer arazi değiştiyse selectedLand'i güncelle
    if (oldWidget.land != widget.land) {
      setState(() {
        selectedLand = widget.land!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Ekim yapılacak alanın büyüklüğü:',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                  controller: ekimM2Controller,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bu alanı doldurmanız gerekiyor';
                    }
                    final number = num.tryParse(value);
                    if (number == null) {
                      return 'Lütfen geçerli bir sayı girin';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(selectedDate == null
                        ? 'Tarih Seçilmedi'
                        : 'Seçilen Tarih: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}'), // Tarih formatı sadece gün/ay/yıl olacak
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2.0), // Daha belirgin kenar
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              selectedDate = pickedDate;
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Text('Tarih Seç'),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                SizedBox(height: 16),
                // RehberDropdown güncellendi
                RehberDropdown(
                  mahalleId: selectedLand.mahalle.id,
                  onChanged: (int productId) {
                    setState(() {
                      selectedProductId = productId;
                    });
                  },
                ),
                SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('İptal'),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          if (selectedProductId != null &&
                              ekimM2Controller.text.isNotEmpty &&
                              selectedDate != null) {
                            try {
                              await ekimService.createEkim(
                                selectedLand.id,
                                selectedProductId.toString(),
                                ekimM2Controller.text,
                                selectedDate!.toIso8601String(),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TaskList(userID: widget.userID)),
                              );
                            } catch (e) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TaskList(userID: widget.userID)),
                              );
                            }
                          } else {
                            print('Tüm Boşlukları Doldurunuz');
                          }
                        }
                      },
                      child: Text('Ekim Oluştur'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
