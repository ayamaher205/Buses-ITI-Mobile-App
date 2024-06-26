import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapSelectionScreen extends StatefulWidget {
  const MapSelectionScreen({super.key});

  @override
  _MapSelectionScreenState createState() => _MapSelectionScreenState();
}

class _MapSelectionScreenState extends State<MapSelectionScreen> {
  LatLng? _selectedPoint;
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();
  List<SearchResult> _searchResults = [];

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    setState(() {
      _selectedPoint = point;
    });
  }

  void _confirmSelection() {
    Navigator.of(context).pop(_selectedPoint);
  }

  Future<void> _searchLocation(String query) async {
    final response = await http.get(Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&countrycodes=eg'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _searchResults = data.map((e) => SearchResult.fromJson(e)).toList();
      });
    } else {
      // Handle the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.statusCode}')),
      );
    }
  }

  void _onSearchResultTap(SearchResult result) {
    final point = LatLng(result.lat, result.lon);
    setState(() {
      _selectedPoint = point;
      _mapController.move(point, 15.0);
      _searchResults.clear();
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Point'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search location',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchLocation(_searchController.text),
                ),
              ),
              onSubmitted: _searchLocation,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(30.0406, 31.8025), // Center of Egypt
              initialZoom: 8.0,
              onTap: _onMapTap,
            ),
            children: [
              TileLayer(
                urlTemplate:
                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              if (_selectedPoint != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedPoint!,
                      width: 80,
                      height: 80,
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          if (_searchResults.isNotEmpty)
            Positioned(
              top: 80,
              left: 15,
              right: 15,
              child: Card(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final result = _searchResults[index];
                    return ListTile(
                      title: Text(result.displayName),
                      onTap: () => _onSearchResultTap(result),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _confirmSelection,
        child: const Icon(Icons.check),
      ),
    );
  }
}

class SearchResult {
  final double lat;
  final double lon;
  final String displayName;

  SearchResult({
    required this.lat,
    required this.lon,
    required this.displayName,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      lat: double.parse(json['lat']),
      lon: double.parse(json['lon']),
      displayName: json['display_name'],
    );
  }
}
