import 'package:delivery_track_system/view/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyBottomNavigation extends StatefulWidget {
  const MyBottomNavigation({super.key});

  @override
  State<MyBottomNavigation> createState() => _MyBottomNavigationState();
}

class _MyBottomNavigationState extends State<MyBottomNavigation> {

  // final List<Widget> allBottomNav = [
  //   HomePage(),
  //   ScanQrCode(),
  // ];


  var currentIndex = 0;

  void navigation() {
    switch (currentIndex) {
      case 0:
        Get.to(HomePage());
        break;

      case 1:
        Get.to(HomePage());

        break;
      default:
        Get.to(HomePage());
    }
  }


  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      iconSize: 30,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      selectedIconTheme: IconThemeData(size: 30),
      unselectedIconTheme: IconThemeData(size: 30),
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      currentIndex: currentIndex,
      onTap: (val) {
        setState(() {
          currentIndex = val;
          navigation();
        });
      },
      items:[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),

      ],
    );
  }
}