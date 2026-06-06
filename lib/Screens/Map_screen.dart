import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController searchController = TextEditingController();

  final MapController mapController = MapController();

  LatLng place = LatLng(30.0444, 31.2357);
  List<dynamic> suggestions = [];
  Timer? debounce;

  Future<void> searchPlace(String query) async {
    if (query.isEmpty) {
      setState(() {
        suggestions = [];
      });

      return;
    }

    final url =
        'https://nominatim.openstreetmap.org/search'
        '?q=$query'
        '&format=jsonv2'
        '&limit=5';
    final response = await http.get(
      Uri.parse(url),

      headers: {'User-Agent': 'tourism-app', 'Accept-Language': 'ar,en'},
    );

    if (response.statusCode != 200) {
      return;
    }

    if (response.statusCode == 200) {
      setState(() {
        suggestions = jsonDecode(response.body);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mapController.move(place, 12);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map Test')),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),

            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      debounce?.cancel();
                      debounce = Timer(const Duration(milliseconds: 500), () {
                        searchPlace(value);
                      });
                    },

                    decoration: const InputDecoration(
                      hintText: 'Search city...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: suggestions.length,

            itemBuilder: (context, index) {
              final placeData = suggestions[index];

              return ListTile(
                leading: const Icon(Icons.location_on),

                title: Text(placeData['display_name']),

                onTap: () {
                  final lat = double.parse(placeData['lat']);

                  final lon = double.parse(placeData['lon']);

                  setState(() {
                    place = LatLng(lat, lon);

                    suggestions = [];
                  });

                  mapController.move(place, 14);
                },
              );
            },
          ),
          Expanded(
            child: FlutterMap(
              mapController: mapController,

              options: MapOptions(initialCenter: place, initialZoom: 12),

              children: [
                TileLayer(
                  //  urlTemplate:
                  //  'https://a.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.tourism_app',
                  errorImage: const AssetImage('assets/error.png'),
                ),

                MarkerLayer(
                  markers: [
                    Marker(
                      point: place,

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
          ),
        ],
      ),
      //  FlutterMap(
      //   options: MapOptions(
      //     initialCenter: place,
      //     initialZoom: 12,

      //     onTap: (tapPosition, point) {
      //       setState(() {
      //         place = point;
      //       });

      //       print(
      //         'Lat: ${point.latitude}, '
      //         'Lng: ${point.longitude}',
      //       );
      //     },
      //   ),

      //   children: [
      //     TileLayer(
      //       urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      //       userAgentPackageName: 'com.example.tourism_app',
      //     ),

      //     MarkerLayer(
      //       markers: [
      //         Marker(
      //           point: place,
      //           width: 30,
      //           height: 30,

      //           child: const Icon(
      //             Icons.location_pin,
      //             color: Colors.red,
      //             size: 50,
      //           ),
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
    debounce?.cancel();
  }
}
