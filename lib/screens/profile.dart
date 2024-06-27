import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bus_iti/screens/update_profile.dart';

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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateProfileScreen(
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    role: role,
                  ),
                ),
              );
              if (result != null && result is Map<String, String>) {
                setState(() {
                  firstName = result['firstName']!;
                  lastName = result['lastName']!;
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
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_640.png'),
            ),
            const SizedBox(height: 20),
            _buildProfileField('First Name', firstName),
            _buildProfileField('Last Name', lastName),
            _buildProfileField('Email', email),
            _buildProfileField('Role', role),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: TextEditingController(text: value),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        enabled: false,
      ),
    );
  }
}
