import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../controller/formValidation.dart';
import 'mapview.dart';

class DeviceLocationController extends GetxController {

  MyFormValidateController formValidateController = Get.put(MyFormValidateController());


  @override
  void onInit() {
    super.onInit();
    getPositionAfter5Secs();
    getLocationFromServer();
    recievedData();
  }



  var getDeviceLocationsLatitude = ''.obs;
  var getDeviceLocationsLongtude = ''.obs;

  // Store last position for filtering
  double _lastLat = 0.0;
  double _lastLng = 0.0;

  // Distance threshold (meters)
  final double _minDistance = 3.0;

  // Buffers for smoothing (average of last 20 readings)
  List<double> latBuffer = [];
  List<double> lngBuffer = [];

  // Stationary detection
  var isStationary = false.obs;          // Whether device is stationary
  int stationaryCount = 0;               // Consecutive cycles the device is stationary
  final int stationaryThreshold = 3;     // Number of cycles to confirm stationary

  void getPositionAfter5Secs() {
    Timer.periodic(const Duration(seconds: 3), (_) {
      determinePosition();
    });
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
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

    // Get current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // --- Stationary detection ---
    if (position.speed < 0.5) {
      stationaryCount++;
      if (stationaryCount >= stationaryThreshold) {
        isStationary.value = true;
      }
    } else {
      stationaryCount = 0;
      isStationary.value = false;
    }

    // Calculate distance from last position
    double distance = 0;
    if (_lastLat != 0.0 && _lastLng != 0.0) {
      distance = Geolocator.distanceBetween(
        _lastLat,
        _lastLng,
        position.latitude,
        position.longitude,
      );
    }

    // Only update if device moved enough OR is moving
    if (distance < _minDistance && isStationary.value) {
      print("📍 Device stationary, marker frozen. Distance=$distance m");
      return position;
    }

    // Update last position
    _lastLat = position.latitude;
    _lastLng = position.longitude;

    // Apply smoothing before sending
    _updateSmoothedPosition(position);

    print(
        '✅ Smoothed Position: Lat=${getDeviceLocationsLatitude.value}, Lng=${getDeviceLocationsLongtude.value}');
    return position;
  }

  // Smooth the GPS position by averaging last 20 readings
  void _updateSmoothedPosition(Position position) {
    latBuffer.add(position.latitude);
    lngBuffer.add(position.longitude);

    if (latBuffer.length > 20) latBuffer.removeAt(0);
    if (lngBuffer.length > 20) lngBuffer.removeAt(0);

    double avgLat = latBuffer.reduce((a, b) => a + b) / latBuffer.length;
    double avgLng = lngBuffer.reduce((a, b) => a + b) / lngBuffer.length;

    getDeviceLocationsLatitude.value = avgLat.toString();
    getDeviceLocationsLongtude.value = avgLng.toString();

    sendCurrentPositionToSocketIo();
  }

  void sendCurrentPositionToSocketIo() {
    var currentDevicePosition = {
      'latitude': getDeviceLocationsLatitude.value,
      'longitude': getDeviceLocationsLongtude.value,
    };
    print('📡 currentDevicePosition: $currentDevicePosition');
    formValidateController.socket!.emit('get_deviceLocation', currentDevicePosition);
  }

  var devicePositionChangeLatitude = 0.0.obs;
  var devicePositionChangeLongitude = 0.0.obs;

  void getLocationFromServer() {
    formValidateController.socket!.on('send_deviceLocation', (data) {
      print('📨 Data received from server: $data');
      devicePositionChangeLatitude.value = double.parse(data['latitude']);
      devicePositionChangeLongitude.value = double.parse(data['longitude']);
    });
  }


  void recievedData(){
    formValidateController.socket!.on('received_location', (data) {
      print("data from server_are $data");
      if(data['latitude'] != null && data['longitude'] != null){
        Get.to(()=>MapViewLocations(), fullscreenDialog: true, transition: Transition.downToUp,arguments:data);
      }
      else{
        print('dataNotGetFromServer');
      }
    });

  }
}


