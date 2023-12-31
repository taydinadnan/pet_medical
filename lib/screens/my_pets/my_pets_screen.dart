import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_medical/models/pets.dart'; // Import your pet model
import 'package:pet_medical/repository/auth.dart';
import 'package:pet_medical/repository/data_repository.dart';
import 'package:pet_medical/screens/home/widgets/pet_card.dart';

class MyPetsScreen extends StatefulWidget {
  const MyPetsScreen({super.key});

  @override
  State<MyPetsScreen> createState() => _MyPetsScreenState();
}

class _MyPetsScreenState extends State<MyPetsScreen> {
  late final User? user;
  final DataRepository repository = DataRepository();
  List<Pet> userPets = [];

  @override
  void initState() {
    super.initState();
    user = Auth().currentUser;
    fetchUserPets();
  }

  Future<void> fetchUserPets() async {
    if (user != null) {
      final userPetsStream = repository.getPetsForUser(user!.uid);

      userPetsStream.listen((userPetsSnapshot) {
        if (userPetsSnapshot.docs.isNotEmpty) {
          setState(() {
            userPets = userPetsSnapshot.docs
                .map((doc) => Pet.fromSnapshot(doc))
                .toList();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("PETS COUNT: ${userPets.length}");
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pets'),
      ),
      body: userPets.isNotEmpty
          ? ListView.builder(
              itemCount: userPets.length,
              itemBuilder: (context, index) {
                final pet = userPets[index];

                pet.name = capitalizeFirstLetterOfEachWord(pet.name);

                return ListTile(
                  title: PetCard(
                    pet: pet,
                    boldStyle: const TextStyle(fontWeight: FontWeight.bold),
                    petCreator: user!.uid,
                  ),
                );
              },
            )
          : const Center(
              child: Text("You don't have any pets yet."),
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
}
