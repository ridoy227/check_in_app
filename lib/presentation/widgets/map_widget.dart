import 'package:check_in/presentation/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({
    super.key,
    this.onSelectLocation,
    this.showMarkers = false,
    this.showCircles = false,
  });

  final Function(LatLng)? onSelectLocation;
  final bool showMarkers, showCircles;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
            builder: (context, provider, child) {
        return GoogleMap(
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          onTap: onSelectLocation,
          markers: showMarkers ? provider.markers : {},
          circles: showCircles ? provider.circles : {},
          onMapCreated: (controller) {
            provider.setController(controller);
          },
          initialCameraPosition: CameraPosition(
            target: provider.initialLocation,
            zoom: 16.0,
          ),
        );
      }
    );
  }
}
