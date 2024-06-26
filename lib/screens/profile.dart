import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late SharedPreferences prefs;
  String firstName = '';
  String lastName = '';
  String email = '';
  String role = '';
  bool isEditing = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initPrefsAndFetchUserProfile();
  }

  Future<void> _initPrefsAndFetchUserProfile() async {
    prefs = await SharedPreferences.getInstance();
    await _fetchUserProfile();
  }

Future<void> _fetchUserProfile() async {
  try {
    final accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      throw Exception('No access token found');
    }

    final response = await http.get(
      Uri.parse('${dotenv.env['URL']!}/users/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final userData = json.decode(response.body)['user'];
      if (mounted) {
        setState(() {
          firstName = userData['firstName'] ?? '';
          lastName = userData['lastName'] ?? '';
          email = userData['email'] ?? '';
          role = userData['role'] ?? '';
        });

        _firstNameController.text = firstName;
        _lastNameController.text = lastName;
        _emailController.text = email;
        _roleController.text = role;
      }
    } else {
      final errorData = json.decode(response.body);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load profile: ${errorData['message']}')),
        );
      }
    }
  } catch (e) {
    print('Error fetching user profile: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile: $e')),
      );
    }
  }
}


  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updateUserProfile() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    final accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No access token found')),
      );
      return;
    }

    final response = await http.patch(
      Uri.parse('${dotenv.env['URL']!}/users/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'password': _passwordController.text.isNotEmpty ? _passwordController.text : null,
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
        title: Text('User Profile'),
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
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_640.png'),
            ),
            SizedBox(height: 20),
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
              enabled: false,
            ),
            TextField(
              controller: _roleController,
              decoration: InputDecoration(labelText: 'Role'),
              enabled: false,
            ),
            if (isEditing) ...[
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'New Password'),
                obscureText: true,
              ),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: 'Confirm New Password'),
                obscureText: true,
              ),
            ],
            SizedBox(height: 16),
        
          ],
        ),
      ),
    );
  }
}
