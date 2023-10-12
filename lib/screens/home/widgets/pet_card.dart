import 'package:flutter/material.dart';
import 'package:pet_medical/models/pets.dart';
import 'package:pet_medical/repository/user_data.dart';
import 'package:pet_medical/screens/pet_card_details_screen/pet_room.dart';
import 'package:pet_medical/utils/pets_icons.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  final TextStyle boldStyle;
  final String petCreator;
  final Map<String, Color> splashColor = {
    'cat': Colors.pink[100]!,
    'dog': Colors.blue[100]!,
    'other': Colors.grey[100]!,
  };

  PetCard({
    Key? key,
    required this.pet,
    required this.boldStyle,
    required this.petCreator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.push(
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
            FutureBuilder<List<Map<String, dynamic>>>(
              future: getAllUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return _buildUserList(context, snapshot.data);
                }
              },
            ),
            _getPetIcon(pet.type),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList(
      BuildContext context, List<Map<String, dynamic>>? users) {
    final user = users?.firstWhere(
      (user) => user['uid'] == pet.petCreator,
    );

    if (user != null) {
      return _buildUserListItem(context, user);
    } else {
      return const Text('User not found');
    }
  }

  Widget _buildUserListItem(BuildContext context, Map<String, dynamic> user) {
    return Text('Owner: ${user['username']}');
  }

  Widget _getPetIcon(String type) {
    final petIconColor = _getPetIconColor(type);
    Icon petIcon;

    if (type == 'cat') {
      petIcon = Icon(Pets.cat, color: petIconColor);
    } else if (type == 'dog') {
      petIcon = Icon(Pets.dog_seating, color: petIconColor);
    } else {
      petIcon = Icon(Icons.pets, color: petIconColor);
    }
    return IconButton(
      icon: petIcon,
      onPressed: () {},
    );
  }

  Color _getPetIconColor(String type) {
    switch (type) {
      case 'cat':
        return Colors.pinkAccent;
      case 'dog':
        return Colors.blueAccent;
      default:
        return Colors.blueGrey;
    }
  }
}
