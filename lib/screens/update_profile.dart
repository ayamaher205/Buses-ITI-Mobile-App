import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfileScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String role;

  const UpdateProfileScreen({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
  }) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late SharedPreferences prefs;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initPrefs();
    _firstNameController.text = widget.firstName;
    _lastNameController.text = widget.lastName;
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _updateUserProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No access token found')),
      );
      return;
    }

    final updateData = {
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
    };

    if (_passwordController.text.isNotEmpty) {
      updateData['password'] = _passwordController.text;
    }

    final response = await http.patch(
      Uri.parse('${dotenv.env['URL']!}/users/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode(updateData),
    );

    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
      Navigator.pop(context, {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    if (_passwordController.text != _confirmPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _updateUserProfile,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: TextEditingController(text: widget.email),
                decoration: InputDecoration(labelText: 'Email'),
                enabled: false,
              ),
              TextFormField(
                controller: TextEditingController(text: widget.role),
                decoration: InputDecoration(labelText: 'Role'),
                enabled: false,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'New Password'),
                obscureText: true,
                validator: _validatePassword,
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: 'Confirm New Password'),
                obscureText: true,
                validator: _validatePassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
