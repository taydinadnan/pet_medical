import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_medical/repository/auth.dart';
import 'package:pet_medical/repository/user_data.dart';
import 'package:pet_medical/repository/widget_tree.dart';
import 'package:pet_medical/screens/auth/widgets/auth_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? errorMessage = '';
  bool isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  Future<String> createUserWithEmailAndPassword() async {
    setState(() {
      isLoading = true;
    });

    try {
      await Auth().createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      setState(() {
        isLoading = false;
      });
      return "success";
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.message;
      });
      return "error";
    }
  }

  void _navigateToHomeList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WidgetTree()),
    );
  }

  Widget _buildRegistrationButton() {
    return ElevatedButton(
      onPressed: isLoading
          ? null
          : () {
              createUserWithEmailAndPassword().then((result) {
                if (result == "success") {
                  saveUserDataToFirestore(
                      _emailController.text, _usernameController.text);
                  _navigateToHomeList();
                }
              });
            },
      child: isLoading
          ? const CircularProgressIndicator()
          : const Text('Register'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Create a new account'),
              const SizedBox(height: 20),
              buildTextField(_emailController, 'Email', false),
              const SizedBox(height: 10),
              buildTextField(_passwordController, 'Password', true),
              const SizedBox(height: 10),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
              ),
              const SizedBox(height: 20),
              buildErrorMessage(errorMessage),
              _buildRegistrationButton(),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _emailController.clear();
                  _passwordController.clear();
                },
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
