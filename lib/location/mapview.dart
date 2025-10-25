import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'devicelocation.dart';

class MapViewLocations extends StatefulWidget {
  const MapViewLocations({super.key});

  @override
  State<MapViewLocations> createState() => _MapViewLocationsState();
}

class _MapViewLocationsState extends State<MapViewLocations> {
  DeviceLocationController deviceLocationController =
  Get.put(DeviceLocationController());

  GoogleMapController? mapController;
  var destination = Get.arguments;
  Set<Polyline> polylines = {};

  // Smooth marker animation
  LatLng? previousPosition;
  LatLng? targetPosition;
  Marker movingMarker = const Marker(
    markerId: MarkerId('start'),
    position: LatLng(0, 0),
  );

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();

    final destLat = double.parse(destination['latitude']);
    final destLng = double.parse(destination['longitude']);

    polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        color: Colors.blue,
        width: 5,
        points: [
          LatLng(
            deviceLocationController.devicePositionChangeLatitude.value,
            deviceLocationController.devicePositionChangeLongitude.value,
          ),
          LatLng(destLat, destLng),
        ],
      ),
    );

    // Listen for device position changes
    deviceLocationController.devicePositionChangeLatitude.listen((lat) {
      final lng = deviceLocationController.devicePositionChangeLongitude.value;

      // Animate marker smoothly
      animateMarker(LatLng(lat, lng));

      // Animate camera to follow marker
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLng(LatLng(lat, lng)),
        );

        // Update polyline dynamically
        setState(() {
          polylines.removeWhere((p) => p.polylineId.value == 'route');
          polylines.add(
            Polyline(
              polylineId: const PolylineId('route'),
              color: Colors.blue,
              width: 5,
              points: [movingMarker.position, LatLng(destLat, destLng)],
            ),
          );
        });
      }
    });
  }

  // Smooth marker animation function
  void animateMarker(LatLng newPosition) {
    if (previousPosition == null) {
      previousPosition = newPosition;
      targetPosition = newPosition;
      setState(() {
        movingMarker = Marker(
          markerId: const MarkerId('start'),
          position: newPosition,
          infoWindow: const InfoWindow(title: 'Start Position'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        );
      });
      return;
    }

    targetPosition = newPosition;

    const int durationMs = 2000; // animation duration
    final int steps = 60; // number of frames
    int step = 0;

    Timer.periodic(Duration(milliseconds: durationMs ~/ steps), (timer) {
      step++;
      final double lat = previousPosition!.latitude +
          (targetPosition!.latitude - previousPosition!.latitude) * step / steps;
      final double lng = previousPosition!.longitude +
          (targetPosition!.longitude - previousPosition!.longitude) * step / steps;

      setState(() {
        movingMarker = Marker(
          markerId: const MarkerId('start'),
          position: LatLng(lat, lng),
          infoWindow: const InfoWindow(title: 'Start Position'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        );
      });

      if (step >= steps) {
        previousPosition = targetPosition;
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  deviceLocationController.devicePositionChangeLatitude.value,
                  deviceLocationController.devicePositionChangeLongitude.value,
                ),
                zoom: 16,
              ),
              markers: {
                movingMarker,
                Marker(
                  markerId: const MarkerId('destination'),
                  position: LatLng(
                    double.parse(destination["latitude"]),
                    double.parse(destination["longitude"]),
                  ),
                  infoWindow: InfoWindow(title: destination["place"]),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
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
                  backgroundColor: MaterialStatePropertyAll(Colors.red),
                ),
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
