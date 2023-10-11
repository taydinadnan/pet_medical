import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_medical/repository/auth.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() => const Text('Firebase Auth');

  Widget _userUid() => Text(user?.email ?? 'User email');

  Widget _signOutButton() =>
      ElevatedButton(onPressed: signOut, child: const Text('Sign Out'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _userUid(),
            _signOutButton(),
          ],
        ),
      ),
    );
  }
}
