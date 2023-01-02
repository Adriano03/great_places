import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isReadyonly;

  const MapScreen({
    super.key,
    this.initialLocation = const PlaceLocation(
      latitude: -25.394560,
      longitude: -51.482376,
    ),
    this.isReadyonly = false,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedPosition;

  void _selectPosition(LatLng position) {
    setState(() {
      _pickedPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione...'),
        centerTitle: true,
        actions: [
          if (!widget.isReadyonly)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _pickedPosition == null
                  ? null
                  : () {
                      Navigator.of(context).pop(_pickedPosition);
                    },
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 13,
        ),
        onTap: widget.isReadyonly ? null : _selectPosition,
        markers: (_pickedPosition == null && !widget.isReadyonly)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('p1'),
                  position: _pickedPosition ?? widget.initialLocation.toLatLng(),
                ),
              },
      ),
    );
  }
}
