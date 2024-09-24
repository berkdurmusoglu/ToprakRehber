import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final PageController _pageController = PageController();

  static const List<Widget> _pages = <Widget>[
    Center(child: Text('Home Page')),
    Tasks(),
    Center(child: Text('Fields Page')),
    Center(child: Text('Profile Page')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // BottomNavigationBar ile sayfa değiştirildiğinde PageView'i de değiştirelim
    _pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Navigation Example')),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,  // Sayfa değiştirildiğinde BottomNavigationBar'ı güncelle
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: 'İşlemler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.agriculture),
            label: 'Arazilerim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.ac_unit),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  int _selectedIndex = 0; // 0 for Ekim, 1 for Hasat
  final TextEditingController _searchController = TextEditingController();

  // Mock data for Ekim and Hasat operations
  final List<String> _ekimIslemleri = [
    'Buğday ekimi',
    'Mısır ekimi',
    'Patates ekimi',
  ];

  final List<String> _hasatIslemleri = [
    'Buğday hasadı',
    'Mısır hasadı',
    'Patates hasadı',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ekim ve Hasat İşlemleri'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2, // TextField'ı daha küçük yapmak için flex değerini düşürdüm
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Ara...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 1, // Filtreleme ikonu ile TextField arasında denge sağlamak için flex ekledim
                  child: IconButton(
                    icon: Icon(Icons.filter_list),
                    onPressed: () {
                      // Filtreleme işlemleri buraya gelecek
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ToggleButtons(
              borderRadius: BorderRadius.circular(8), // Köşeleri yuvarladım
              fillColor: Colors.green[100], // Seçildiğinde dolgu rengi
              selectedColor: Colors.green, // Seçilen metnin rengi
              constraints: BoxConstraints(minHeight: 60, minWidth: 150), // Butonların minimum genişlik ve yükseklik değerleri
              children: [
                Text('Ekim', style: TextStyle(fontSize: 18)), // Metin boyutunu da büyüttüm
                Text('Hasat', style: TextStyle(fontSize: 18)),
              ],
              isSelected: [_selectedIndex == 0, _selectedIndex == 1],
              onPressed: (int newIndex) {
                setState(() {
                  _selectedIndex = newIndex;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedIndex == 0
                  ? _ekimIslemleri.length
                  : _hasatIslemleri.length,
              itemBuilder: (context, index) {
                final item = _selectedIndex == 0
                    ? _ekimIslemleri[index]
                    : _hasatIslemleri[index];
                return ListTile(
                  title: Text(item),
                  onTap: () {
                    // İşlem seçildiğinde yapılacaklar
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

