import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_medical/screens/home/widgets/pet_card.dart';
import 'package:pet_medical/repository/auth.dart';
import 'package:pet_medical/repository/data_repository.dart';
import 'package:pet_medical/repository/widget_tree.dart';

import 'widgets/add_pet_dialog.dart';
import '../../models/pets.dart';

class HomeList extends StatefulWidget {
  const HomeList({Key? key}) : super(key: key);
  @override
  State<HomeList> createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  final DataRepository repository = DataRepository();
  final boldStyle =
      const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _signOutButton() => ElevatedButton(
      onPressed: () {
        signOut();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const WidgetTree()));
      },
      child: const Text('Sign Out'));

  @override
  Widget build(BuildContext context) {
    return _buildHome(context);
  }

  Widget _buildHome(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pets'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: repository.getStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const LinearProgressIndicator();

            return _buildList(context, snapshot.data?.docs ?? []);
          }),
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
            onPressed: () {
              _addPet();
            },
            tooltip: 'Add Pet',
            child: const Icon(Icons.add),
          ),
          _signOutButton()
        ],
      ),
    );
  }

  void _addPet() {
    showDialog<Widget>(
      context: context,
      builder: (BuildContext context) {
        return const AddPetDialog();
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot>? snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot!.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final pet = Pet.fromSnapshot(snapshot);

    return PetCard(pet: pet, boldStyle: boldStyle);
  }
}
