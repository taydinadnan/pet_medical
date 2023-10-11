import 'package:flutter/material.dart';
import 'package:pet_medical/screens/home/home_list.dart';
import 'package:pet_medical/screens/auth/login_screen.dart';
import 'package:pet_medical/repository/auth.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomeList();
          } else {
            return const LoginScreen();
          }
        });
  }
}
