import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class EnvironmentPage extends StatefulWidget {
  const EnvironmentPage({super.key});

  @override
  State<EnvironmentPage> createState() => _EnvironmentPageState();
}

class _EnvironmentPageState extends State<EnvironmentPage> {
  GoogleMapController? _mapController;
  LocationData? _currentLocation;
  Location _location = Location();

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  void _initLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check if the location services are enabled.
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        // Handle case where user doesn't enable location services.
        return;
      }
    }

    // Check location perms
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        // Handle case where user doesn't grant location permissions.
        return;
      }
    }

    // Current user location
    LocationData currentLocation = await _location.getLocation();
    setState(() {
      _currentLocation = currentLocation;
    });

    // Map camera moveement to user's location
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(_currentLocation!.latitude ?? 0.0,
              _currentLocation!.longitude ?? 0.0),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Environment Page',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.blue[600],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(0, 0),
              zoom: 16,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            markers: _currentLocation != null
                ? {
                    Marker(
                      markerId: MarkerId('currentLocation'),
                      position: LatLng(_currentLocation!.latitude ?? 0.0,
                          _currentLocation!.longitude ?? 0.0),
                    ),
                  }
                : {},
          ),
          _currentLocation != null
              ? Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    color: Colors.white,
                    child: Text(
                        'Lat: ${_currentLocation!.latitude!.toStringAsFixed(4)}\n'
                        'Lng: ${_currentLocation!.longitude!.toStringAsFixed(4)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
