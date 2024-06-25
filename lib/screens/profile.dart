import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String firstName = '';
  String lastName = '';
  String email = '';
  String role = '';
  String imageUrl = '';
  bool isEditing = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final response =
        await http.get(Uri.parse('${dotenv.env['URL']!}/users/me'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        firstName = data['first_name'];
        lastName = data['last_name'];
        role = data['role'];
        email = data['email'];
        imageUrl = data['image_url'];
      });
      _firstNameController.text = firstName;
      _lastNameController.text = lastName;
      _emailController.text = email;
      _roleController.text = role;
    } else {
      // Handle error
      throw Exception('Failed to load profile');
    }
  }

  Future<void> _updateUserProfile() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    final response = await http.patch(
      Uri.parse('${dotenv.env['URL']!}/users/me'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'password': _passwordController.text.isNotEmpty
            ? _passwordController.text
            : _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        firstName = _firstNameController.text;
        lastName = _lastNameController.text;
        isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (isEditing) {
                _updateUserProfile();
              } else {
                setState(() {
                  isEditing = true;
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            imageUrl.isNotEmpty
                ? CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(imageUrl),
                  )
                : CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person),
                  ),
            SizedBox(height: 16),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
              enabled: isEditing,
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
              enabled: isEditing,
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              enabled: !isEditing,
            ),
            TextField(
              controller: _roleController,
              decoration: InputDecoration(labelText: 'Role'),
              enabled: !isEditing,
            ),
            if (isEditing) ...[
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'New Password'),
                obscureText: true,
              ),
              TextField(
                controller: _confirmPasswordController,
                decoration:
                    InputDecoration(labelText: 'Confirm New Password'),
                obscureText: true,
              ),
            ],
            SizedBox(height: 16),
            Text(
              role,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
