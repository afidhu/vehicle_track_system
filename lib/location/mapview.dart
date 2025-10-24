import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/locationsModel.dart';
import 'devicelocation.dart';

class MapViewLocations extends StatefulWidget {

  final devicePositionChange;
  const MapViewLocations({super.key, this.devicePositionChange});

  @override
  State<MapViewLocations> createState() => _MapViewLocationsState();
}
class _MapViewLocationsState extends State<MapViewLocations> {

  DeviceLocationController deviceLocationController = Get.put(DeviceLocationController());

  @override

  var destination = Get.arguments;
  // var startPosition = {
  //   "latitude": "-6.7589962",
  //   "longitude": "39.1815917"
  // };

  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();

    // final startLat = double.parse(startPosition['latitude']!);
    // final startLng = double.parse(startPosition['longitude']!);
    final destLat = double.parse(destination['latitude']);
    final destLng = double.parse(destination['longitude']);

    polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        color: Colors.blue,
        width: 5,
        points: [
          LatLng(double.parse(widget.devicePositionChange['latitude']), double.parse(widget.devicePositionChange['longitude'])),
          LatLng(destLat, destLng),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(()=> Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                double.parse(widget.devicePositionChange['latitude']),
                double.parse(widget.devicePositionChange['longitude']),
              ),
              zoom: 6,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('start'),
                position: LatLng(
                  double.parse(deviceLocationController.getDeviceLocationsLatitude.value),
                  double.parse(deviceLocationController.getDeviceLocationsLatitude.value),
                ),
                infoWindow: const InfoWindow(title: 'Start Position'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
              ),


              Marker(
                markerId: const MarkerId('destination'),
                position: LatLng(
                  double.parse(destination["latitude"]),
                  double.parse(destination["longitude"]),
                ),
                infoWindow: InfoWindow(title: destination["place"]),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed),
              ),
            },
            polylines: polylines,
          ),


          Positioned(
            left: Get.width * 0.03,
            top: Get.height * 0.03,
            child: IconButton(
              color: Colors.green,
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.red),
              ),
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 40,
                grade: 20,
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
