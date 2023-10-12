import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_medical/repository/user_data.dart';
import 'package:pet_medical/screens/home/widgets/pet_card.dart';
import 'package:pet_medical/repository/auth.dart';
import 'package:pet_medical/repository/data_repository.dart';
import 'package:pet_medical/repository/widget_tree.dart';
import 'package:pet_medical/screens/my_pets/my_pets_screen.dart';
import 'package:pet_medical/screens/profile/profile_screen.dart';

import 'widgets/add_pet_dialog.dart';
import '../../models/pets.dart';

class HomeList extends StatefulWidget {
  const HomeList({Key? key}) : super(key: key);
  @override
  State<HomeList> createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  late final User? user;
  final DataRepository repository = DataRepository();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    user = Auth().currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return _buildHome(context);
  }

  Widget _buildHome(BuildContext context) {
    print("HELOOOO${_currentIndex}");
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'My Pets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      appBar: buildAppBar(),
      body: _buildPage(_currentIndex),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _addPet();
        },
        tooltip: 'Add Pet',
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FutureBuilder<Map<String, dynamic>?>(
            future: getUserData(user!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final userData = snapshot.data;
                final username = userData?['username'] ?? 'User';
                final usernameCapitalized = username.isNotEmpty
                    ? username[0].toUpperCase() + username.substring(1)
                    : username;

                return Text('$usernameCapitalized\'s Pets',
                    style: const TextStyle(fontSize: 20));
              }
            },
          ),
          _signOutButton(),
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return _homeScreen();
      case 1:
        return const MyPetsScreen();
      case 2:
        return ProfileScreen();
      default:
        return _homeScreen();
    }
  }

  StreamBuilder<QuerySnapshot<Object?>> _homeScreen() {
    return StreamBuilder<QuerySnapshot>(
        stream: repository.getStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const LinearProgressIndicator();

          return _buildPetList(context, snapshot.data?.docs ?? []);
        });
  }

  Widget _buildPetList(BuildContext context, List<DocumentSnapshot>? snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children:
          snapshot!.map((data) => _buildPetListItem(context, data)).toList(),
    );
  }

  Widget _buildPetListItem(BuildContext context, DocumentSnapshot snapshot) {
    final pet = Pet.fromSnapshot(snapshot);

    pet.name = capitalizeFirstLetterOfEachWord(pet.name);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: PetCard(
        pet: pet,
        boldStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        petCreator: user!.uid,
      ),
    );
  }

  String capitalizeFirstLetterOfEachWord(String text) {
    if (text.isEmpty) {
      return text;
    }
    List<String> words = text.split(' ');
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        words[i] = words[i][0].toUpperCase() + words[i].substring(1);
      }
    }
    return words.join(' ');
  }

  Future<void> signOut() async {
    await Auth().signOut();
    // ignore: use_build_context_synchronously
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const WidgetTree()));
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('Sign Out'),
    );
  }

  Future<void> _addPet() async {
    showDialog<Widget>(
      context: context,
      builder: (BuildContext context) {
        return const AddPetDialog();
      },
    );
  }
}
