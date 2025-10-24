import 'dart:async';

import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

import '../controller/formValidation.dart';
import 'mapview.dart';

class DeviceLocationController extends GetxController{


  MyFormValidateController myFormValidateController = Get.put(MyFormValidateController());



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // determinePosition();
    getPositionAfter5Secs();
  }

  var getDeviceLocationsLatitude = ''.obs;
  var getDeviceLocationsLongtude = ''.obs;
  // var getDeviceLocations =''.obs;


  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  ///

  void getPositionAfter5Secs(){

    Timer.periodic(Duration(seconds: 3), (_){
      determinePosition();
      getLocationFromServer();
    });

  }
  ///
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Open location settings for the user
      await Geolocator.openLocationSettings();
      return Future.error(
          'Location services are disabled. Please enable them.');
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied. Please enable them in app settings.');
    }

    // Permissions are granted, get location

    // Position position = await Geolocator.getCurrentPosition();
    // print('DevicePosition: $position');

    Position? position = await Geolocator.getLastKnownPosition();
    // Position? position1 = await Geolocator.getCurrentPosition();
    // getDeviceLocations.value = await Geolocator.getLastKnownPosition().toString();
    if (position != null) {
      getDeviceLocationsLatitude.value =position.latitude.toString();
      getDeviceLocationsLongtude.value =position.longitude.toString();
      sendCurrentPositionToSocketIo();
      print('Last Known Position: $position');
    } else {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,);
      Future.delayed(Duration(seconds: 5));
      print('Current Position: $position');
      print('Current Position: ${position.latitude}');
      getDeviceLocationsLatitude.value =position.latitude.toString();
      getDeviceLocationsLongtude.value =position.longitude.toString();

      sendCurrentPositionToSocketIo();

    }
    return position;
  }

  void sendCurrentPositionToSocketIo(){

    var currentDevicePosition = {
      'latitude': getDeviceLocationsLatitude.value,
      'longitude': getDeviceLocationsLongtude.value,
    };
    myFormValidateController.socket!.emit('get_deviceLocation',currentDevicePosition);
  }

  void getLocationFromServer(){
    myFormValidateController.socket!.on('send_deviceLocation',(data){
      print('dara, $data');
      MapViewLocations(devicePositionChange: data);
    });

  }


}