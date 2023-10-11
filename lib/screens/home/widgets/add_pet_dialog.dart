import 'package:flutter/material.dart';
import 'package:pet_medical/models/pets.dart';
import 'package:pet_medical/repository/data_repository.dart';

class AddPetDialog extends StatefulWidget {
  const AddPetDialog({Key? key}) : super(key: key);

  @override
  State<AddPetDialog> createState() => _AddPetDialogState();
}

class _AddPetDialogState extends State<AddPetDialog> {
  String? petName;
  String character = '';

  final DataRepository repository = DataRepository();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Add Pet'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(
                autofocus: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Enter a Pet Name'),
                onChanged: (text) => petName = text,
              ),
              RadioListTile(
                title: const Text('Cat'),
                value: 'cat',
                groupValue: character,
                onChanged: (value) {
                  setState(() {
                    character = (value ?? '');
                  });
                },
              ),
              RadioListTile(
                title: const Text('Dog'),
                value: 'dog',
                groupValue: character,
                onChanged: (value) {
                  setState(() {
                    character = (value ?? '');
                  });
                },
              ),
              RadioListTile(
                title: const Text('Other'),
                value: 'other',
                groupValue: character,
                onChanged: (value) {
                  setState(() {
                    character = (value ?? '');
                  });
                },
              )
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () async {
                if (petName != null && character.isNotEmpty) {
                  final newPet =
                      Pet(petName!, type: character, vaccinations: []);
                  await repository.addPet(newPet);
                }
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: const Text('Add')),
        ]);
  }
}
