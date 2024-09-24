import 'package:flutter/material.dart';
import 'package:toprak_rehberi/screens/FarmingScreens/EkimListPage.dart';
import 'package:toprak_rehberi/screens/FarmingScreens/RehberScreen.dart';

import 'NavigationPages/Tasks.dart';
import 'LandScreens/LandListPage.dart';
import 'NavigationPages/HomeScreen.dart';
import 'UserScreens/Profile.dart';

class NavigationPage extends StatefulWidget {
  final int userId;
  final int initialIndex;

  const NavigationPage({required this.userId, required this.initialIndex,super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _selectedIndex = 0;
  late List<Widget> _pages;
  final PageController _pageController = PageController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pages = [
      HomeScreen(userID: widget.userId,),
      TaskList(userID: widget.userId),  //
      LandListPage(userID: widget.userId,),
      Profile(userID: widget.userId,),

    ];
  }
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  RehberScreen(userID: widget.userId,),
            ),
          );
        },
        child: Icon(Icons.ac_unit),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
