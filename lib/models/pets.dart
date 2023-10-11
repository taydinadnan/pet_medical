import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_medical/models/vaccination.dart';

class Pet {
  String name;
  String? notes;
  String type;
  List<Vaccination> vaccinations;
  String? referenceId;
  String userId;

  Pet(this.name,
      {this.notes,
      required this.type,
      this.referenceId,
      required this.vaccinations,
      required this.userId});

  factory Pet.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    data['userId'] = snapshot.reference.parent.parent?.id ??
        ''; // Provide a default value if null
    final newPet = Pet.fromJson(data);
    newPet.referenceId = snapshot.reference.id;
    return newPet;
  }

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      json['name'] as String,
      notes: json['notes'] as String?,
      type: json['type'] as String,
      vaccinations: _convertVaccinations(json['vaccinations'] as List<dynamic>),
      userId:
          json['userId'] as String, // Include the user ID in the constructor
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'notes': notes,
      'type': type,
      'vaccinations': _vaccinationList(vaccinations),
      'userId': userId, // Include the user ID when converting to JSON
    };
  }

  @override
  String toString() => 'Pet<$name>';
}

List<Vaccination> _convertVaccinations(List<dynamic> vaccinationMap) {
  final vaccinations = <Vaccination>[];

  for (final vaccination in vaccinationMap) {
    vaccinations.add(Vaccination.fromJson(vaccination as Map<String, dynamic>));
  }
  return vaccinations;
}

List<Map<String, dynamic>> _vaccinationList(List<Vaccination>? vaccinations) {
  if (vaccinations == null) {
    return [];
  }
  final vaccinationMap = <Map<String, dynamic>>[];
  for (var vaccination in vaccinations) {
    vaccinationMap.add(vaccination.toJson());
  }
  return vaccinationMap;
}
