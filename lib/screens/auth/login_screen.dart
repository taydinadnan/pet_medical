import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_medical/screens/auth/register_screen.dart';
import 'package:pet_medical/repository/auth.dart';
import 'package:pet_medical/screens/auth/widgets/auth_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? errorMessage = '';
  bool isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    setState(() {
      isLoading = true;
    });

    try {
      await Auth().signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
        isLoading = false;
      });
    }

    if (isLoading) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: isLoading ? null : signInWithEmailAndPassword,
      child:
          isLoading ? const CircularProgressIndicator() : const Text('Login'),
    );
  }

  Widget _buildRegisterButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RegisterScreen(),
          ),
        );
        _passwordController.clear();
        _emailController.clear();
      },
      child: const Text('Create an account'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Login to your account'),
              const SizedBox(height: 20),
              buildTextField(_emailController, 'Email', false),
              const SizedBox(height: 10),
              buildTextField(_passwordController, 'Password', true),
              const SizedBox(height: 20),
              _buildLoginButton(),
              const SizedBox(height: 20),
              buildErrorMessage(errorMessage),
              _buildRegisterButton(),
            ],
          ),
        ),
      ),
    );
  }
}
