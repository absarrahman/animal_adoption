import 'package:animal_adoption/constants/string_constants.dart';
import 'package:animal_adoption/models/animal_model.dart';
import 'package:animal_adoption/models/base_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdoptionModel extends BaseModel {
  late String? animalUuid;
  late String? bookedUuid;
  late int? createdAt;
  late String? postDescription;
  late String? postName;
  late String? userUUID;

  AdoptionModel({
    required uuid,
    required this.animalUuid,
    required this.bookedUuid,
    required this.createdAt,
    required this.postDescription,
    required this.postName,
    required this.userUUID,
  });

  AdoptionModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    uuid = snapshot.data()![ModelConstants.uuid];
    animalUuid = snapshot.data()![ModelConstants.animalUuid];
    bookedUuid = snapshot.data()![ModelConstants.bookedUuid];
    createdAt = snapshot.data()![ModelConstants.createdAt];
    postDescription = snapshot.data()![ModelConstants.postDescription];
    postName = snapshot.data()![ModelConstants.postName];
    userUUID = snapshot.data()![ModelConstants.userUuid];
  }
}
