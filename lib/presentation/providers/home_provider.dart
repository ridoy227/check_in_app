import 'dart:developer';
import 'package:check_in/core/services/firestore_service.dart';
import 'package:check_in/core/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeProvider extends ChangeNotifier {
  final LatLng initialLocation = const LatLng(23.788422, 90.425025);
  GoogleMapController? mapController;
  LatLng? currentLocation;
  int _totalCheckIns = 0;
  String _checkInStatus = 'Not Checked In';
  Set<Marker> markers = {};
  Set<Circle> circles = {};
  LatLng? selectedLocation;
  double locationRadius = 0.0;
  bool showHomeRadius = false;
  bool showCheckinButton = false;


  final firestoreService = FirestoreService();

  int get totalCheckIns => _totalCheckIns;
  String get getCheckInStatus => _checkInStatus;

  void setController(GoogleMapController controller) {
    mapController = controller;
    getCurrentLocation();
  }

  void getCurrentLocation() async {
    try {
      // checking Location Permnission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        // show toast for permissiom denied
        ToastUtil.showErrorToast('Location permissions are denied');
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        // show error toast for permission denied forever
        ToastUtil.showErrorToast('Location permissions are denied forever');
        return;
      }
      // fetch current location of user in everytime
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 5,
          ),
        ).listen((Position position) {
          currentLocation = LatLng(position.latitude, position.longitude);
          focusOnCurrentLocation(currentLocation!);
          checkLocationStatus();
        });
      }
    } catch (e) {
      ToastUtil.showErrorToast('Something went wrong while fetching location');
      log("Location Fetching Error: $e");
    }
  }

  void focusOnCurrentLocation(LatLng location) async {
    // return if controller is not set
    if (mapController == null) return;

    // return if currentLcoation is null
    if (currentLocation == null) return;

    // move camera to current location
    mapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: location, zoom: 16.0)));
  }

  void addCheckInPoint(LatLng location) {
    // increment total check ins
    _totalCheckIns += 1;
    _checkInStatus = 'Checked In';
    selectedLocation = location;

    if (markers.isNotEmpty || circles.isNotEmpty) {
      markers.clear();
      circles.clear();
    }

    // add marker to the map
    markers.add(Marker(
      markerId: MarkerId('checkin_$_totalCheckIns'),
      position: location,
      infoWindow: InfoWindow(
        title: 'Check-In Point $_totalCheckIns',
        snippet:
            'Lat: ${location.latitude.toStringAsFixed(4)}, Lng: ${location.longitude.toStringAsFixed(4)}',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    ));
    circles.add(
      Circle(
        circleId: const CircleId('radius_circle'),
        center: selectedLocation ?? initialLocation,
        radius: locationRadius, // radius in meters
        fillColor: Colors.blue.withAlpha((0.2 * 255).round()),
        strokeColor: Colors.blueAccent,
        strokeWidth: 2,
      ),
    );

    focusOnCurrentLocation(location);

    notifyListeners();
  }

  void updateRadius(double radius) {
    locationRadius = radius;

    if (selectedLocation != null) {
      circles.clear();
      circles.add(
        Circle(
          circleId: const CircleId('radius_circle'),
          center: selectedLocation!,
          radius: locationRadius, // radius in meters
          fillColor: Colors.blue.withAlpha((0.2 * 255).round()),
          strokeColor: Colors.blueAccent,
          strokeWidth: 2,
        ),
      );
      notifyListeners();
    }
  }


  Future<void> createCheckIn() async {
    if (selectedLocation == null) {
      ToastUtil.showErrorToast('Please select a location first');
      return;
    }
    try {
      await firestoreService.createCheckInPoint({
        'latitude': selectedLocation!.latitude,
        'longitude': selectedLocation!.longitude,
        'radius': locationRadius,
        'timestamp': DateTime.now().toIso8601String(),
      });
      ToastUtil.showSuccessToast('Check-In Point Created Successfully');
      fetchCheckInPoints();
    } catch (e) {
      ToastUtil.showErrorToast('Failed to create Check-In Point');
      log("Firestore Error: $e");
    }
  }


  Future<void> fetchCheckInPoints() async {
    try {
      final points = await firestoreService.fetchCheckInPoints();
      if (points.isNotEmpty) {
        _totalCheckIns = points.length;
        log("Items ========= $points");
        // Clear existing markers and circles
        markers.clear();
        circles.clear();

        for (var point in points) {
          final lat = point['latitude'] as double;
          final lng = point['longitude'] as double;
          final radius = point['radius'] as double;
          locationRadius = point['radius'] as double;

          final location = LatLng(lat, lng);

          // Add marker
          markers.add(Marker(
            markerId: MarkerId('checkin_${markers.length + 1}'),
            position: location,
            infoWindow: InfoWindow(
              title: 'Check-In Point ${markers.length + 1}',
              snippet:
                  'Lat: ${lat.toStringAsFixed(4)}, Lng: ${lng.toStringAsFixed(4)}',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ));

          // Add circle
          circles.add(
            Circle(
              circleId: CircleId('circle_${circles.length + 1}'),
              center: location,
              radius: radius,
              fillColor: Colors.blue.withAlpha((0.2 * 255).round()),
              strokeColor: Colors.blueAccent,
              strokeWidth: 2,
            ),
          );
        }
        log("Markers: $markers");
        log("Circles: $circles");
        showHomeRadius = true;
        checkLocationStatus();
        notifyListeners();
      }
    } catch (e) {
      ToastUtil.showErrorToast('Failed to fetch Check-In Points');
      log("Firestore Fetch Error: $e");
    }
  }


  // checking if user is within the check-in radius
  Future<void> checkLocationStatus() async {


    if (currentLocation == null || markers.isEmpty) {
      _checkInStatus = 'Not Checked In';
      notifyListeners();
      return;
    }

    final distance = Geolocator.distanceBetween(
      currentLocation!.latitude,
      currentLocation!.longitude,
      markers.first.position.latitude,
      markers.first.position.longitude,
    );

    if (distance <= locationRadius) {
      showCheckinButton = true;
      log("User is within the check-in radius.");
    } else {
      showCheckinButton = false;
      log("User is not within the check-in radius.");
    }
    notifyListeners();
  }

  
}
