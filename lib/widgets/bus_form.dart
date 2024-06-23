import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../screens/selection_point.dart';

class BusForm extends StatefulWidget {
  final Function(String, int, bool, String?, List<Map<String, dynamic>>, String) onSaved;

  const BusForm({super.key, required this.onSaved});

  @override
  BusFormState createState() => BusFormState();
}

class BusFormState extends State<BusForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _capacityController = TextEditingController();
  bool _isActive = true;
  String? _imagePath;
  int _numPoints = 0;
  List<Map<String, dynamic>> _points = [];
  List<TextEditingController> _latControllers = [];
  List<TextEditingController> _longControllers = [];
  String? _selectedDriver;

  @override
  void dispose() {
    _nameController.dispose();
    _capacityController.dispose();
    for (var controller in _latControllers) {
      controller.dispose();
    }
    for (var controller in _longControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Bus')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Bus Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.directions_bus),
                  floatingLabelStyle: TextStyle(color: Color(0xFF9f9e9e)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF9f9e9e)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a bus name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _capacityController,
                decoration: const InputDecoration(
                  labelText: 'Capacity',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.event_seat),
                  floatingLabelStyle: TextStyle(color: Color(0xFF9f9e9e)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF9f9e9e)),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the bus capacity';
                  }
                  int? capacity = int.tryParse(value);
                  if (capacity == null || capacity < 5) {
                    return 'Capacity must be a number and at least 5';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Is Active'),
                value: _isActive,
                onChanged: (bool? value) {
                  setState(() {
                    _isActive = value ?? true;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Image Path (optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.image),
                  floatingLabelStyle: TextStyle(color: Color(0xFF9f9e9e)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF9f9e9e)),
                  ),
                ),
                onSaved: (value) {
                  _imagePath = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Number of Points',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                  floatingLabelStyle: TextStyle(color: Color(0xFF9f9e9e)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF9f9e9e)),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _numPoints = int.tryParse(value) ?? 0;
                    _points = List.generate(_numPoints, (index) => {'name': '', 'lat': 0.0, 'long': 0.0});
                    _latControllers = List.generate(_numPoints, (index) => TextEditingController());
                    _longControllers = List.generate(_numPoints, (index) => TextEditingController());
                  });
                },
              ),
              const SizedBox(height: 16),
              for (int i = 0; i < _numPoints; i++)
                Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Point ${i + 1} Name',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.place),
                        floatingLabelStyle: const TextStyle(color: Color(0xFF9f9e9e)),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF9f9e9e)),
                        ),
                      ),
                      onChanged: (value) {
                        _points[i]['name'] = value;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _latControllers[i],
                            decoration: const InputDecoration(
                              labelText: 'Latitude',
                              border: OutlineInputBorder(),
                              floatingLabelStyle: TextStyle(color: Color(0xFF9f9e9e)),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF9f9e9e)),
                              ),
                            ),
                            onChanged: (value) {
                              _points[i]['lat'] = double.tryParse(value) ?? 0.0;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _longControllers[i],
                            decoration: const InputDecoration(
                              labelText: 'Longitude',
                              border: OutlineInputBorder(),
                              floatingLabelStyle: TextStyle(color: Color(0xFF9f9e9e)),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF9f9e9e)),
                              ),
                            ),
                            onChanged: (value) {
                              _points[i]['long'] = double.tryParse(value) ?? 0.0;
                            },
                          ),
                        ),
                        IconButton(
                          icon: SizedBox(
                            width: 28,
                            height: 28,
                            child: Image.asset('images/map_icon.png'),
                          ),
                          onPressed: () async {
                            LatLng? selectedPoint = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const MapSelectionScreen(),
                              ),
                            );
                            if (selectedPoint != null) {
                              setState(() {
                                _points[i]['lat'] = selectedPoint.latitude;
                                _points[i]['long'] = selectedPoint.longitude;
                                _latControllers[i].text = selectedPoint.latitude.toString();
                                _longControllers[i].text = selectedPoint.longitude.toString();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Driver',
                  border: OutlineInputBorder(),
                  floatingLabelStyle: TextStyle(color: Color(0xFF9f9e9e)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF9f9e9e)),
                  ),
                ),
                items: ['Driver 1', 'Driver 2', 'Driver 3'].map((driver) {
                  return DropdownMenuItem(
                    value: driver,
                    child: Text(driver),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDriver = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.onSaved(
                      _nameController.text,
                      int.parse(_capacityController.text),
                      _isActive,
                      _imagePath,
                      _points,
                      _selectedDriver ?? '',
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
