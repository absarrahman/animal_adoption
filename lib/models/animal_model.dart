import 'package:animal_adoption/models/base_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/string_constants.dart';

class AnimalModel extends BaseModel {
  late String animalBreed;
  late String animalType;
  late String imageUrl;

  AnimalModel({
    required uuid,
    required this.animalBreed,
    required this.animalType,
    required this.imageUrl,
  });

  AnimalModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    animalBreed = snapshot.data()![ModelConstants.animalBreed];
    animalType = snapshot.data()![ModelConstants.animalType];
    uuid = snapshot.data()![ModelConstants.uuid];
    imageUrl = snapshot.data()![ModelConstants.imageUrl];
  }
}
