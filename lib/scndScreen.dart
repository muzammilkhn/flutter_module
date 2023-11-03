import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  void initState() {
    super.initState();
    getLocation();
  }

  List<Marker> _markers = <Marker>[];
  LatLng? location;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      double lat = position.latitude;
      double long = position.longitude;

      setState(() {
        location = LatLng(lat, long);
        _markers.add(Marker(
            markerId: MarkerId('SomeId'),
            position: location!,
            infoWindow: InfoWindow(title: 'User Location')));
      });
      final GoogleMapController controller = await _controller.future;
      await controller
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: location ?? LatLng(37.42796133580664, -122.085749655962),
        zoom: 15,
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: location ?? LatLng(37.42796133580664, -122.085749655962),
          zoom: 15,
        ),
        markers: Set<Marker>.of(_markers),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
