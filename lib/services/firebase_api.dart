import 'dart:developer';
import 'dart:typed_data';

import 'package:animal_adoption/constants/string_constants.dart';
import 'package:animal_adoption/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseAPI {
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Sign in

  static Future<UserModel?> signIn({required String email, required String password, required String collectionPath}) async {
    UserModel? userModel;
    try {
      await firebaseAuth.signInWithEmailAndPassword(email: email.trim(), password: password.trim()).then((result) async {
        String _uId = result.user!.uid;
        userModel = await setUserModel(uID: _uId, collectionPath: collectionPath);
      });
      log("Successfully signed in");
      return userModel;
    } on FirebaseException catch (e) {
      log("Something went wrong during sign in ${e.message}");
      return null;
    }
  }

  // sign up

  static Future<UserModel?> signUp({required Map<String, dynamic> userJSON, required String collectionPath, required String password}) async {
    UserModel? _userModel;
    try {
      await firebaseAuth.createUserWithEmailAndPassword(email: userJSON[ModelConstants.email], password: password).then((result) async {
        String _uID = result.user!.uid;
        userJSON[ModelConstants.uuid] = _uID;
        _addUserToDB(uID: _uID, collectionPath: collectionPath, userJSON: userJSON);
        _userModel = await setUserModel(uID: _uID, collectionPath: collectionPath);
      });
      log("Successfully registered");
      return _userModel;
    } on FirebaseException catch (e) {
      log("Failed to signup ${e.message}");
      return null;
    }
  }

  //Sign out

  static Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  static Future<UserModel?> setUserModel({required String uID, required String collectionPath}) async {
    return _fireStore.collection(collectionPath).doc(uID).get().then((doc) => UserModel.fromSnapshot(doc));
  }

  static Future<void> _addUserToDB({required String uID, required String collectionPath, required Map<String, dynamic> userJSON}) async {
    await _fireStore.collection(collectionPath).doc(uID).set(userJSON);
  }

  //Add

  static Future<void> addData({required String collectionPath, required Map<String, dynamic> json}) async {
    try {
      await _fireStore.collection(collectionPath).add(json);
      log("Successfully added");
    } catch (e) {
      log("Failed to add data ${e.toString()}");
    }
  }

  static Future<String?> addDataAndGetDocID({required String collectionPath, required Map<String, dynamic> json}) async {
    try {
      final doc = await _fireStore.collection(collectionPath).add(json);
      log("Successfully added ${doc.id}");
      return doc.id;
    } catch (e) {
      log("Failed to add data ${e.toString()}");
      return null;
    }
  }

  //Remove

  static Future<void> removeData({required String uID, required String collectionPath}) async {
    try {
      await _fireStore.collection(collectionPath).doc(uID).delete();
      log("Successfully removed");
    } catch (e) {
      log("Failed to remove ${e.toString()}");
    }
  }

  //Update
  static Future<void> updateData({required String collectionPath, String? uID, required Map<String, dynamic> newJsonData}) async {
    try {
      await _fireStore.collection(collectionPath).doc(uID).update(newJsonData);
      log("Successfully updated");
    } catch (e) {
      log("Failed to update ${e.toString()}");
    }
  }

  // Get collection ref

  static CollectionReference<Map<String, dynamic>> getCollectionRef({required String collectionPath}) {
    return _fireStore.collection(collectionPath);
  }

  // Upload file

  static Future<String?> uploadFile({required Uint8List bytes, required String fileName, required String refPath}) async {
    try {
      TaskSnapshot imageData = await _storage.ref("$refPath/$fileName").putData(bytes);
      return imageData.ref.getDownloadURL();
    } catch (e) {
      log("Error occurred $e");
      return null;
    }
  }
}
