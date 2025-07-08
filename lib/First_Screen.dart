import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Coins_page.dart';
import 'Constants/CustomStyles.dart';
import 'Main_page.dart';
import 'Authuntication/Profile_page.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  int _selectedIndex = 1;
  int totalCoins=0;
  final List<Widget> _pages = [ProfilePage(), MainPage(), CoinsPage()];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.person,size: 29
              ),
              label: "حسابي"),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home,size: 29),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.money_dollar_circle,size: 29,),
            label: 'كوينز',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedIconTheme: IconThemeData(color: Color(0xFFf25d01)),
        onTap: _onItemTapped,
        selectedLabelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            fontFamily: "Almarai",
            color: Colors.green

        ),
        unselectedLabelStyle: CustomStyles.UnSelectedLabel,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff9ce1d4), // Start color
              Color(0xFFFFFFFF), // End color
            ],
            begin: Alignment.topCenter,
            end: Alignment.center,
          ),
        ),
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
    );
    //
  }
}
