import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:bus_iti/screens/home.dart';
import 'package:bus_iti/services/user_auth.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Center(
        child: isSmallScreen
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Logo(),
                  _FormContent(),
                ],
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: _Logo()),
                  Expanded(child: _FormContent()),
                ],
              ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'images/iti-logo.png',
          height: isSmallScreen ? 100 : 200,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Welcome to ITI!",
            textAlign: TextAlign.center,
            style: isSmallScreen
                ? Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.black)
                : Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.black),
          ),
        )
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent();

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  final UserAuth _userAuth = UserAuth();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        final user = await _userAuth.login(_email, _password);
        if (user != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.grey),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF9f9e9e)),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                } else if (!EmailValidator.validate(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
              onSaved: (value) {
                _email = value!;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.grey),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF9f9e9e)),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                prefixIcon: Icon(Icons.lock_outline_rounded),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                } else if (value.length < 8) {
                  return "Password can't be less than 8 characters.";
                } else if (value.length > 25) {
                  return "Password can't be more than 25 characters.";
                }
                return null;
              },
              onSaved: (value) {
                _password = value!;
              },
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xA3DCDCDC),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Color(0xFFD22525),
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
