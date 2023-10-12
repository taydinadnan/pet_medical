import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_medical/models/vaccination.dart';

class Pet {
  String name;
  String? notes;
  String type;
  List<Vaccination> vaccinations;
  String? referenceId;
  String petCreator;

  Pet(
    this.name, {
    this.notes,
    required this.type,
    this.referenceId,
    required this.vaccinations,
    required this.petCreator,
  });

  factory Pet.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    data['userId'] = snapshot.reference.parent.parent?.id ?? '';
    final newPet = Pet.fromJson(data);
    newPet.referenceId = snapshot.reference.id;
    return newPet;
  }

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      json['name'] as String,
      notes: json['notes'] as String?,
      type: json['type'] as String,
      vaccinations: (json['vaccinations'] as List<dynamic>)
          .map((vaccination) => Vaccination.fromJson(vaccination))
          .toList(),
      petCreator: json['petCreator'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'notes': notes,
      'type': type,
      'vaccinations': vaccinations.map((v) => v.toJson()).toList(),
      'petCreator': petCreator,
    };
  }

  @override
  String toString() => 'Pet<$name>';
}
