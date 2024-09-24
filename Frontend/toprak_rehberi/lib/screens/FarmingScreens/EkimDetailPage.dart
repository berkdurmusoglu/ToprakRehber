import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toprak_rehberi/models/Farming/Ekim.dart';

import 'package:toprak_rehberi/screens/NavigationPage.dart';
import 'package:toprak_rehberi/services/FarmingService/EkimService.dart';
import 'package:toprak_rehberi/services/FarmingService/HasatService.dart';
import 'package:toprak_rehberi/widgets/EnumDropdown/HasatSonucDropdown.dart';

class EkimDetailPage extends StatefulWidget {
  final int ekimID;

  const EkimDetailPage({required this.ekimID, super.key});

  @override
  State<EkimDetailPage> createState() => _EkimDetailPageState();
}

class _EkimDetailPageState extends State<EkimDetailPage> {
  late Future<Ekim> futureEkim;
  EkimService ekimService = EkimService();
  bool showHarvestFields = false; // Hasat textfieldlarını gösterip gizlemek için
  TextEditingController hasatMiktariController = TextEditingController();
  DateTime? selectedDate;
  String? selectedHasatSonuc;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    futureEkim = ekimService.fetchEkimId(widget.ekimID);
  }

  String getSeason(DateTime date) {
    int month = date.month;
    if (month >= 3 && month <= 5) {
      return 'İlkbahar';
    } else if (month >= 6 && month <= 8) {
      return 'Yaz';
    } else if (month >= 9 && month <= 11) {
      return 'Sonbahar';
    } else {
      return 'Kış';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x80d3fac7),
      appBar: AppBar(title: Text("Ekim Detayı")),
      body: FutureBuilder<Ekim>(
        future: futureEkim,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final ekim = snapshot.data!;
            final ekimDate = ekim.ekimTarihi;
            final date2 = DateTime.now();
            final difference = date2.difference(ekimDate).inDays;
            final localMevsim = getSeason(DateTime.now());
            final hasatMevsimi = ekim.product.hasatMevsimi;
            final hasatZamani = localMevsim == hasatMevsimi;
            DateFormat trDate = DateFormat.yMMMMd('tr_TR'); // "12 Eylül 2024" formatı
            String newDate = trDate.format(ekim.ekimTarihi);
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8,15,8,15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Üst kısımda ürünün resmi
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Image.asset(
                        'assets/images/basicProduct.jpg', // Ürünün resmi burada
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Ekim bilgileri
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Text("Ürün Adı: ${ekim.product.productName}",
                              style: GoogleFonts.audiowide(fontSize: 33)),
                          SizedBox(height: 8),
                          Text("Ekim Tarihi: $newDate",
                              style: TextStyle(fontSize: 18)),
                          SizedBox(height: 8),
                          Text("Arazi Açıklaması: ${ekim.land.landDescription}",
                              style: TextStyle(fontSize: 18)),
                          Text(
                              "Arazi Adresi: ${ekim.land.mahalle
                                  .mahalleName} / ${ekim.land.mahalle.ilceId
                                  .ilceName}",
                              style: TextStyle(fontSize: 18)),
                          Text("İl: ${ekim.land.mahalle.ilceId.ilId}",
                              style: TextStyle(fontSize: 18)),
                          Text("Ekim Süresi: $difference",
                              style: TextStyle(fontSize: 18)),
                          SizedBox(height: 8),
                          Text("Tahmini Hasat Mevsimi: ${ekim.product
                              .hasatMevsimi}",
                              style: TextStyle(fontSize: 18)),
                          SizedBox(height: 8),
                          hasatZamani
                              ? Text(
                            "Tahmini hasat mevsimindesiniz!",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                              : Text(
                            "Tahmini Hasat mevsimine henüz gelmediniz!",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),


                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    // Hasat Et butonu
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showHarvestFields =
                          !showHarvestFields; // Butona basıldığında textfieldlar görünsün
                        });
                      },
                      child: Text(showHarvestFields
                          ? 'Hasat Alanını Gizle'
                          : 'Hasat Et'),
                    ),

                    // TextFieldlar, başlangıçta gizli
                    Visibility(
                      visible: showHarvestFields,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey, // Form anahtarı
                          child: Column(
                            children: [
                              TextFormField(
                                controller: hasatMiktariController,
                                decoration: InputDecoration(
                                  labelText: 'Hasat Miktarı (kg)',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number, // Yalnızca sayısal giriş kabul ediliyor
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Lütfen hasat miktarını giriniz';
                                  }

                                  final double? hasatMiktari = double.tryParse(value);
                                  if (hasatMiktari == null) {
                                    return 'Geçerli bir miktar giriniz';
                                  }


                                  if (ekim.land.m2  == 0) {
                                    return 'Geçersiz arazi büyüklüğü bilgisi';
                                  }

                                  if (hasatMiktari > ekim.land.m2) {
                                    return 'Hasat miktarı arazi büyüklüğünü aşamaz (${ekim.land.m2} m²)!';
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
                                      : 'Seçilen Tarih: ${selectedDate!.toLocal()}'),
                                  TextButton(
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
                                    child: Text('Tarih Seç'),
                                  ),
                                ],
                              ),

                              // Tarih doğrulaması
                              if (selectedDate == null)
                                Text(
                                  'Lütfen bir tarih seçin.',
                                  style: TextStyle(color: Colors.red),
                                ),

                              SizedBox(height: 16),

                              // Hasat Sonucu Dropdown
                              HasatSonucDropdown(
                                onSonucSelected: (String? selectedSonuc) {
                                  setState(() {
                                    selectedHasatSonuc = selectedSonuc;
                                    print(selectedHasatSonuc);
                                  });
                                },
                              ),

                              // Hasat Sonucu doğrulaması
                              if (selectedHasatSonuc == null)
                                Text(
                                  'Lütfen hasat sonucu seçin.',
                                  style: TextStyle(color: Colors.red),
                                ),

                              SizedBox(height: 16),

                              ElevatedButton(
                                onPressed: () {
                                  // Tüm alanlar doğrulanmış mı kontrol et
                                  if (_formKey.currentState!.validate() &&
                                      selectedDate != null &&
                                      selectedHasatSonuc != null) {
                                    // Hasat işlemini gerçekleştir
                                    HasatService().createHasat(
                                      widget.ekimID,
                                      hasatMiktariController.text,
                                      selectedHasatSonuc!,
                                      selectedDate!.toIso8601String(),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Hasat başarıyla tamamlandı')),
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NavigationPage(userId: 2, initialIndex: 1),
                                      ),
                                    );
                                  } else {
                                    // Eğer tarih ya da hasat sonucu seçilmediyse, ek bir kontrol
                                    if (selectedDate == null || selectedHasatSonuc == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Lütfen tüm alanları doldurun')),
                                      );
                                    }
                                  }
                                },
                                child: Text("Hasatı Tamamla"),
                              ),
                            ],
                      ),
                    ),
                  ),
                ) ],
                ),
              ),
            );
          } else {
            return Center(child: Text('Veri bulunamadı'));
          }
        },
      ),
    );
  }
}
