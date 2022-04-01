import 'package:animal_adoption/constants/string_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String? uuid;
  late String? name;
  late String? email;
  late double? rating;
  late String? role;
  late String? nid;
  late String? phoneNumber;

  UserModel({
    this.uuid,
    this.name,
    this.email,
    this.rating = 0.0,
    this.role = RoleConstants.ROLE_GONNA_ADOPT_USER,
    this.phoneNumber,
    this.nid,
  });

  UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    name = snapshot.data()![ModelConstants.name];
    email = snapshot.data()![ModelConstants.email];
    uuid = snapshot.data()![ModelConstants.uuid];
    role = snapshot.data()![ModelConstants.role];
    nid = snapshot.data()![ModelConstants.userNID];
    rating = snapshot.data()![ModelConstants.userRating];
    phoneNumber = snapshot.data()![ModelConstants.userPhoneNumber];
  }
}
