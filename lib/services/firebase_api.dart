import 'dart:developer';

import 'package:animal_adoption/constants/string_constants.dart';
import 'package:animal_adoption/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAPI {
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // Sign in

  static Future<UserModel?> signIn({required String email, required String password, required String collectionPath}) async {
    UserModel? userModel;
    try {
      await firebaseAuth.signInWithEmailAndPassword(email: email.trim(), password: password.trim()).then((result) async {
        String _uId = result.user!.uid;
        userModel = await _setUserModel(uID: _uId, collectionPath: collectionPath);
      });
      return userModel;
    } catch (e) {
      log("Something went wrong ${e.toString()}");
      return null;
    }
  }

  // sign up

  static Future<UserModel?> signUp({required Map<String, dynamic> userJSON, required String collectionPath}) async {
    UserModel? _userModel;
    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(email: userJSON[ModelConstants.email], password: userJSON[ModelConstants.userPassword])
          .then((result) async {
        String _uID = result.user!.uid;
        _addUserToDB(uID: _uID, collectionPath: collectionPath, userJSON: userJSON);
        _userModel = await _setUserModel(uID: _uID, collectionPath: collectionPath);
      });
      return _userModel;
    } catch (e) {
      log("Failed to signup ${e.toString()}");
      return null;
    }
  }

  //Sign out

  static Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  static Future<UserModel?> _setUserModel({required String uID, required String collectionPath}) async {
    return _fireStore.collection(collectionPath).doc(uID).get().then((doc) => UserModel.fromSnapshot(doc));
  }

  static Future<void> _addUserToDB({required String uID, required String collectionPath, required Map<String, dynamic> userJSON}) async {
    await _fireStore.collection(collectionPath).doc(uID).set(userJSON);
  }

  //Add

  static Future<void> addData({required String collectionPath, required Map<String, dynamic> json}) async {
    try {
      await _fireStore.collection(collectionPath).add(json);
    } catch (e) {
      log("Failed to add data ${e.toString()}");
    }
  }

  static Future<String?> addDataAndGetDocID({required String collectionPath, required Map<String, dynamic> json}) async {
    String? docID;
    try {
      _fireStore.collection(collectionPath).add(json).then((value) {
        docID = value.id;
      });
      return docID;
    } catch (e) {
      log("Failed to add data ${e.toString()}");
      return null;
    }
  }

  //Remove

  static Future<void> removeData({required String uID, required String collectionPath}) async {
    try {
      await _fireStore.collection(collectionPath).doc(uID).delete();
    } catch (e) {
      log("Failed to remove ${e.toString()}");
    }
  }

  //Update
  static Future<void> updateData({required String collectionPath, required String uID, required Map<String, dynamic> newJsonData}) async {
    try {
      await _fireStore.collection(collectionPath).doc(uID).update(newJsonData);
    } catch (e) {
      log("Failed to update ${e.toString()}");
    }
  }
}
