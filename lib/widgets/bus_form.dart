import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart'; // For formatting time
import 'dart:io'; // For File
import 'package:awesome_dialog/awesome_dialog.dart';
import '../models/driver.dart';
import '../screens/selection_point.dart';
import '../services/bus.dart';
import '../services/driver.dart';

class BusForm extends StatefulWidget {
  const BusForm({super.key});

  @override
  BusFormState createState() => BusFormState();
}

class BusFormState extends State<BusForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _capacityController = TextEditingController();
  final _departureTimeController = TextEditingController();
  final _departureTimeIsoController =
      TextEditingController(); // ISO format controller
  final _arrivalTimeController = TextEditingController();
  final _arrivalTimeIsoController =
      TextEditingController(); // ISO format controller
  final _imageController = TextEditingController();
  bool _isActive = true;
  File? _imageFile;
  int _numPoints = 0;
  List<Map<String, dynamic>> _points = [];
  List<TextEditingController> _latControllers = [];
  List<TextEditingController> _longControllers = [];
  List<TextEditingController> _pickupTimeControllers = [];
  List<TextEditingController> _pickupTimeIsoControllers = [];
  List<Driver> _drivers = [];
  String? _selectedDriverId;

  @override
  void initState() {
    super.initState();
    _fetchDrivers();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _capacityController.dispose();
    _departureTimeController.dispose();
    _departureTimeIsoController.dispose(); // Dispose ISO controller
    _arrivalTimeController.dispose();
    _arrivalTimeIsoController.dispose(); // Dispose ISO controller
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
    for (var controller in _pickupTimeIsoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _fetchDrivers() async {
    try {
      DriverService driverService = DriverService();
      List<Driver> drivers = await driverService.getAllDrivers();
      setState(() {
        _drivers = drivers;
      });
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _selectTime(
      BuildContext context,
      TextEditingController displayController,
      TextEditingController isoController,
      {int? index}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final now = DateTime.now();
      final selectedTime =
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      final isoFormattedTime = selectedTime.toUtc().toIso8601String();

      final formattedTime = DateFormat('h:mm a').format(selectedTime);

      setState(() {
        displayController.text = formattedTime;
        isoController.text = isoFormattedTime;
        if (index != null) {
          _points[index]['pickupTime'] = isoFormattedTime;
        }
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

  Future<void> _showDialog(BuildContext context, bool isSuccess) async {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: isSuccess ? DialogType.success : DialogType.error,
      showCloseIcon: true,
      title: isSuccess ? 'Success' : 'Failure',
      desc: isSuccess
          ? 'Bus Created successfully.'
          : 'Bus creation failed. Please try again.',
      btnOkOnPress: () {
        if (isSuccess) {
          Navigator.of(context).pop();
        }
      },
      btnOkColor: isSuccess ? const Color(0xFF13DC2E) : const Color(0xDFD22525),
      // btnOkIcon: isSuccess ? Icons.check_circle : Icons.error,
      onDismissCallback: (type) {
        if (isSuccess) {
          Navigator.of(context).pop();
        }
      },
    ).show();
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
                  labelText: 'Select Image',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF9f9e9e)),
                  ),
                  prefixIcon: Icon(Icons.image),
                ),
                readOnly: true,
                onTap: _pickImage,
                validator: (value) {
                  if (_imageFile == null) {
                    return 'Please select an image';
                  }
                  return null;
                },
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Arrival Time';
                  }
                  return null;
                },
                readOnly: true,
                onTap: () => _selectTime(
                    context, _arrivalTimeController, _arrivalTimeIsoController),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Departure Time';
                  }
                  return null;
                },
                readOnly: true,
                onTap: () => _selectTime(context, _departureTimeController,
                    _departureTimeIsoController),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number of points';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _numPoints = int.tryParse(value) ?? 0;
                    _points = List.generate(
                        _numPoints,
                        (index) => {
                              'name': '',
                              'latitude': 0.0,
                              'longitude': 0.0,
                              'pickupTime': '',
                            });
                    _latControllers = List.generate(
                        _numPoints, (index) => TextEditingController());
                    _longControllers = List.generate(
                        _numPoints, (index) => TextEditingController());
                    _pickupTimeControllers = List.generate(
                        _numPoints, (index) => TextEditingController());
                    _pickupTimeIsoControllers = List.generate(
                        _numPoints, (index) => TextEditingController());
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
                        floatingLabelStyle:
                            const TextStyle(color: Color(0xFF9f9e9e)),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF9f9e9e)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter point name';
                        }
                        return null;
                      },
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
                              floatingLabelStyle:
                                  TextStyle(color: Color(0xFF9f9e9e)),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF9f9e9e)),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select point';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _points[i]['latitude'] =
                                  double.tryParse(value) ?? 0.0;
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
                              floatingLabelStyle:
                                  TextStyle(color: Color(0xFF9f9e9e)),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF9f9e9e)),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select point';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _points[i]['longitude'] =
                                  double.tryParse(value) ?? 0.0;
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
                            LatLng? selectedPoint =
                                await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MapSelectionScreen(),
                              ),
                            );
                            if (selectedPoint != null) {
                              setState(() {
                                _points[i]['latitude'] = selectedPoint.latitude;
                                _points[i]['longitude'] =
                                    selectedPoint.longitude;
                                _latControllers[i].text =
                                    selectedPoint.latitude.toString();
                                _longControllers[i].text =
                                    selectedPoint.longitude.toString();
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
                        floatingLabelStyle:
                            const TextStyle(color: Color(0xFF9f9e9e)),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF9f9e9e)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Pickup Time';
                        }
                        return null;
                      },
                      readOnly: true,
                      onTap: () => _selectTime(
                          context,
                          _pickupTimeControllers[i],
                          _pickupTimeIsoControllers[i],
                          index: i),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Select Driver',
                  border: OutlineInputBorder(),
                  floatingLabelStyle: TextStyle(color: Color(0xFF9f9e9e)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF9f9e9e)),
                  ),
                  prefixIcon: Icon(Icons.person),
                ),
                value: _selectedDriverId,
                items: _drivers.map((Driver driver) {
                  return DropdownMenuItem<String>(
                    value: driver.id,
                    child: Text(driver.name),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDriverId = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a driver';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          await BusLines().createBus(
                            name: _nameController.text,
                            capacity: int.parse(_capacityController.text),
                            isActive: _isActive,
                            imageFile: _imageFile,
                            busPoints: _points,
                            departureTime: _departureTimeIsoController.text,
                            arrivalTime: _arrivalTimeIsoController.text,
                            driverId: _selectedDriverId!,
                          );
                          //_showDialog(context, true);
                        } catch (e) {
                          //_showDialog(context, false);
                        }
                      }
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(fontSize: 20, color: Color(0xFF13DC2E)),
                    ),
                  ),
                  const SizedBox(width: 30.0),
                  ElevatedButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text('Reset',
                        style:
                            TextStyle(fontSize: 20, color: Color(0xFFD22525))),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
