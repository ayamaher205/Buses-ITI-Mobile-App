import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // For formatting time
import 'dart:io'; // For File
import 'package:latlong2/latlong.dart';

import '../screens/selection_point.dart';

class BusForm extends StatefulWidget {
  final Function(String, int, bool, String?, List<Map<String, dynamic>>, String, String) onSaved;

  const BusForm({super.key, required this.onSaved});

  @override
  BusFormState createState() => BusFormState();
}

class BusFormState extends State<BusForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _capacityController = TextEditingController();
  final _departureTimeController = TextEditingController();
  final _arrivalTimeController = TextEditingController();
  final _imageController = TextEditingController();
  bool _isActive = true;
  File? _imageFile;
  int _numPoints = 0;
  List<Map<String, dynamic>> _points = [];
  List<TextEditingController> _latControllers = [];
  List<TextEditingController> _longControllers = [];
  List<TextEditingController> _pickupTimeControllers = [];

  @override
  void dispose() {
    _nameController.dispose();
    _capacityController.dispose();
    _departureTimeController.dispose();
    _arrivalTimeController.dispose();
    for (var controller in _latControllers) {
      controller.dispose();
    }
    for (var controller in _longControllers) {
      controller.dispose();
    }
    _imageController.dispose();
    for (var controller in _pickupTimeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final now = DateTime.now();
        final time = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
        controller.text = DateFormat.Hm().format(time);
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _imageController.text = pickedFile.name;
      });
    }
  }

  String _formatTimeToIso8601(String time) {
    final DateFormat inputFormat = DateFormat.Hm();
    final DateTime dateTime = inputFormat.parse(time);
    final now = DateTime.now();
    final DateTime fullDateTime = DateTime(now.year, now.month, now.day, dateTime.hour, dateTime.minute);
    return fullDateTime.toIso8601String();
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: 'Select Image (optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.image),
                ),
                readOnly: true,
                onTap: _pickImage,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _departureTimeController,
                decoration: const InputDecoration(
                  labelText: 'Departure Time',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.departure_board),
                  floatingLabelStyle: TextStyle(color: Color(0xFF9f9e9e)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF9f9e9e)),
                  ),
                ),
                readOnly: true,
                onTap: () => _selectTime(context, _departureTimeController),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _arrivalTimeController,
                decoration: const InputDecoration(
                  labelText: 'Arrival Time',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                  floatingLabelStyle: TextStyle(color: Color(0xFF9f9e9e)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF9f9e9e)),
                  ),
                ),
                readOnly: true,
                onTap: () => _selectTime(context, _arrivalTimeController),
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
                    _points = List.generate(_numPoints, (index) => {'name': '', 'lat': 0.0, 'long': 0.0, 'pickupTime': ''});
                    _latControllers = List.generate(_numPoints, (index) => TextEditingController());
                    _longControllers = List.generate(_numPoints, (index) => TextEditingController());
                    _pickupTimeControllers = List.generate(_numPoints, (index) => TextEditingController());
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
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _pickupTimeControllers[i],
                      decoration: InputDecoration(
                        labelText: 'Pickup Time for Point ${i + 1}',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.access_time),
                        floatingLabelStyle: const TextStyle(color: Color(0xFF9f9e9e)),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF9f9e9e)),
                        ),
                      ),
                      readOnly: true,
                      onTap: () => _selectTime(context, _pickupTimeControllers[i]),
                      onChanged: (value) {
                        _points[i]['pickupTime'] = value;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final departureTimeIso = _formatTimeToIso8601(_departureTimeController.text);
                    final arrivalTimeIso = _formatTimeToIso8601(_arrivalTimeController.text);
                    for (int i = 0; i < _points.length; i++) {
                      if (_pickupTimeControllers[i].text.isNotEmpty) {
                        _points[i]['pickupTime'] = _formatTimeToIso8601(_pickupTimeControllers[i].text);
                      }
                    }
                    widget.onSaved(
                      _nameController.text,
                      int.parse(_capacityController.text),
                      _isActive,
                      _imageFile?.path,
                      _points,
                      departureTimeIso,
                      arrivalTimeIso,
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
