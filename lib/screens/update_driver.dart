import 'package:flutter/material.dart';
import 'package:bus_iti/services/driver.dart';
import 'package:bus_iti/utils/app_styles.dart';

class UpdateDriverScreen extends StatefulWidget {
  final String driverId;
  final String driverName;
  final String driverPhoneNumber;

  const UpdateDriverScreen({
    super.key,
    required this.driverId,
    required this.driverName,
    required this.driverPhoneNumber,
  });

  @override
  State<UpdateDriverScreen> createState() => _UpdateDriverScreenState();
}

class _UpdateDriverScreenState extends State<UpdateDriverScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _driverName;
  late String _driverPhoneNumber;
  final DriverInfo _driverInfo = DriverInfo();

  @override
  void initState() {
    super.initState();
    _driverName = widget.driverName;
    _driverPhoneNumber = widget.driverPhoneNumber;
  }

  void _updateDriver() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await _driverInfo.updateDriver(
          driverId: widget.driverId,
          name: _driverName,
          phoneNumber: _driverPhoneNumber,
        );
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Driver Details'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  initialValue: _driverName,
                  decoration: AppStyles.inputDecoration.copyWith(
                    labelText: 'Driver Name',
                  ),
                  style: const TextStyle(color: Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the driver name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _driverName = value!;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _driverPhoneNumber,
                  decoration: AppStyles.inputDecoration.copyWith(
                    labelText: 'Driver Phone Number',
                  ),
                  style: const TextStyle(color: Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the driver phone number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _driverPhoneNumber = value!;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateDriver,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFFD22525),
                    backgroundColor: const Color(0xA3DCDCDC),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: const Text('Update Driver Details'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
