import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/formValidation.dart';
import '../location/devicelocation.dart';
import '../location/mapview.dart';

class GoToMapView extends StatefulWidget {
  const GoToMapView({super.key});

  @override
  State<GoToMapView> createState() => _GoToMapViewState();
}

class _GoToMapViewState extends State<GoToMapView> {

  DeviceLocationController deviceLocationController = Get.put(DeviceLocationController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.red)
          ),

            onPressed: (){
              Get.to(() => MapViewLocations());
            },
            child: Icon(Icons.run_circle)
        ),
      ),
    );
  }
}
