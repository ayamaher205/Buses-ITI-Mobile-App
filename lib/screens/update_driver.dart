import 'package:flutter/material.dart';
import 'package:bus_iti/services/driver.dart';
import 'package:bus_iti/utils/app_styles.dart';
import 'package:bus_iti/models/driver.dart';

class UpdateDriverScreen extends StatefulWidget {
  final String driverId;
  final String driverName;
  final String driverPhoneNumber;
  final Function(String, String) onUpdate;

  const UpdateDriverScreen({
    super.key,
    required this.driverId,
    required this.driverName,
    required this.driverPhoneNumber,
    required this.onUpdate,
  });

  @override
  State<UpdateDriverScreen> createState() => _UpdateDriverScreenState();
}

class _UpdateDriverScreenState extends State<UpdateDriverScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _driverPhoneNumber;
  late String _selectedDriverId;
  late List<Driver> _drivers;
  final DriverService _driverService = DriverService();

  @override
  void initState() {
    super.initState();
    _driverPhoneNumber = widget.driverPhoneNumber;
    _selectedDriverId = widget.driverId;
    _loadDrivers();
  }

  Future<void> _loadDrivers() async {
    try {
      final drivers = await _driverService.getAllDrivers();
      setState(() {
        _drivers = drivers;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load drivers: $e')),
      );
    }
  }

  void _updateDriver() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final updatedDriver = await _driverService.updateDriver(
          driverId: _selectedDriverId,
          name: _drivers.firstWhere((driver) => driver.id == _selectedDriverId).name,
          phoneNumber: _driverPhoneNumber,
        );

        widget.onUpdate(updatedDriver.name, _driverPhoneNumber);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Driver details updated successfully')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the driver phone number';
    }
    String pattern = r'^01[0-2]{1}[0-9]{8}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid Egyptian phone number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Bus Details'),
        titleTextStyle: AppStyles.appBarTitleStyle,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_drivers.isEmpty)
                  const CircularProgressIndicator()
                else
                  DropdownButtonFormField<String>(
                    value: _selectedDriverId,
                    items: _drivers.map((driver) {
                      return DropdownMenuItem<String>(
                        value: driver.id,
                        child: Text(driver.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDriverId = value!;
                      });
                    },
                    decoration: AppStyles.inputDecoration.copyWith(
                      labelText: 'Select Driver',
                    ),
                  ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _driverPhoneNumber,
                  decoration: AppStyles.inputDecoration.copyWith(
                    labelText: 'Driver Phone Number',
                  ),
                  style: const TextStyle(color: Colors.black),
                  validator: _validatePhoneNumber,
                  onSaved: (value) {
                    _driverPhoneNumber = value!;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateDriver,
                  style: AppStyles.elevatedButtonStyle,
                  child: const Text('Update', style: AppStyles.buttonTextStyle),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
