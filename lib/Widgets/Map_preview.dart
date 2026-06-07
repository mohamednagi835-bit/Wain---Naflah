import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPreview extends StatefulWidget {
  const MapPreview({super.key, required this.location});

  final LatLng location;

  @override
  State<MapPreview> createState() => _MapPreviewState();
}

class _MapPreviewState extends State<MapPreview> {
  final MapController mapController = MapController();

  @override
  void didUpdateWidget(covariant MapPreview oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.location != widget.location) {
      mapController.move(widget.location, 14);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),

      child: FlutterMap(
        mapController: mapController,

        options: MapOptions(initialCenter: widget.location, initialZoom: 12),

        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',

            userAgentPackageName: 'com.example.tourism_app',
          ),

          MarkerLayer(
            markers: [
              Marker(
                point: widget.location,

                width: 50,
                height: 50,

                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 50,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
