import 'package:flutter/material.dart';
import 'package:pet_medical/screens/pet_card_details_screen/pet_room.dart';

import '../../../models/pets.dart';
import '../../../utils/pets_icons.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  final TextStyle boldStyle;
  final String perCreator;
  final splashColor = {
    'cat': Colors.pink[100],
    'dog': Colors.blue[100],
    'other': Colors.grey[100]
  };

  PetCard(
      {Key? key,
      required this.pet,
      required this.boldStyle,
      required this.perCreator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
      onTap: () => Navigator.push<Widget>(
        context,
        MaterialPageRoute(
          builder: (context) => PetRoom(pet: pet),
        ),
      ),
      splashColor: splashColor[pet.type],
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Text(pet.name, style: boldStyle),
            ),
          ),
          Text(
            perCreator,
            style: const TextStyle(fontSize: 10),
          ),
          _getPetIcon(pet.type)
        ],
      ),
    ));
  }

  Widget _getPetIcon(String type) {
    Widget petIcon;
    if (type == 'cat') {
      petIcon = IconButton(
        icon: const Icon(
          Pets.cat,
          color: Colors.pinkAccent,
        ),
        onPressed: () {},
      );
    } else if (type == 'dog') {
      petIcon = IconButton(
        icon: const Icon(
          Pets.dog_seating,
          color: Colors.blueAccent,
        ),
        onPressed: () {},
      );
    } else {
      petIcon = IconButton(
        icon: const Icon(
          Icons.pets,
          color: Colors.blueGrey,
        ),
        onPressed: () {},
      );
    }
    return petIcon;
  }
}
