import 'dart:async';
import 'package:eco_vision/view/const/EcoVisionColor.dart';
import 'package:eco_vision/view/page/activity/PloggingBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  Location location = Location();
  bool isLocationInitialized = false;
  late LocationData locationData;
  double? latitude;
  double? longitude;
  late String currentLocation;

  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> initLocation() async {
    locationData = await location.getLocation();
    latitude = locationData.latitude;
    longitude = locationData.longitude;

    String gpsUrl =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latitude},${longitude}&key=apikey&language=ko';
    final responseGps = await http.get(Uri.parse(gpsUrl));
    Map<String, dynamic> result = jsonDecode(responseGps.body);
    String address = result['results'][1]['formatted_address'];
    currentLocation = (address.split(' ').length < 4)
        ? address.split(' ').sublist(1, address.split(' ').length).join(' ')
        : address.split(' ').sublist(1, 4).join(' ');
  }

  @override
  void initState() {
    super.initState();
    initLocation().then((_) {
      setState(() {
        isLocationInitialized = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EcoVisionColor.background,
      appBar: AppBar(
        backgroundColor: EcoVisionColor.background,
        title: isLocationInitialized
            ? Text(
                currentLocation,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            : const Text(''),
      ),
      body: SafeArea(
        child: Center(
          child: !isLocationInitialized
              ? const CircularProgressIndicator() // 위치 데이터가 준비되지 않은 경우 로딩 표시
              : GoogleMap(
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                      zoom: 15, target: LatLng(latitude!, longitude!)),
                ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 100,
        height: 100,
        child: FloatingActionButton(
          backgroundColor: EcoVisionColor.mainGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Icon(
            Icons.directions_walk_outlined,
            color: Colors.white,
            size: 65,
          ),
          onPressed: () {
            showBottomSheet(
                enableDrag: false,
                context: context,
                builder: (context) {
                  return PloggingBottomSheet(currentLocation: currentLocation);
                });
          },
        ),
      ),
    );
  }
}
