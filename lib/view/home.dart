import 'package:delivery_track_system/view/registerLocation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../bottomNavBar/allBottomNavBar.dart';

import '../utils/reuseColors.dart';
import 'gotoMapview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Tracking',style: TextStyle(color: Colors.yellow,fontWeight: FontWeight.bold,fontSize: 30),),
        centerTitle: true,
        backgroundColor: AllColors.appBarColor,
      ),
      body:Container(
        child: FilledButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.yellow)
          ),
            onPressed: (){
              Get.to(()=>GoToMapView());
            },
            child: Icon(Icons.start_outlined)
        ),
      ) ,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
          focusElevation: 30,
          hoverColor: Colors.red,
          elevation: 20,
          foregroundColor: Colors.red,
          onPressed: (){
          Get.to(()=>RegisterLocation(), fullscreenDialog: true,curve: Curves.bounceOut,duration: Duration(seconds: 1));
          },
        child: Icon(Icons.add, applyTextScaling: true,fontWeight: FontWeight.bold,size: 40,weight: 50,),
      ),
      bottomNavigationBar:MyBottomNavigation(),
    );
  }
}
