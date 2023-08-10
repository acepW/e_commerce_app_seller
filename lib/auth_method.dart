import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_seller/consts/firebase_consts.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:e_commerce_app_seller/models/user_model.dart' as model;

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 final User? user = authInstance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user details
  Future<model.UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.UserModel.fromSnap(documentSnapshot);
  }

  // Signing Up User

  Future<String> signUpUser({
    required Timestamp createdAt,
    required String email,
    required String name,
    required String password,
    required String username,
    required String role,
    required String alamat,
    required List userCart,
    required List userWish,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email != null && email.isNotEmpty) {
        String? profileUrl;

        // registering user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        model.UserModel _user = model.UserModel(
          createdAt: Timestamp.now(),
          name: name,
          username: username,
          id: cred.user!.uid,
          email: email,
          role: role,
          alamat: alamat,
          userCart: userCart,
          userWish: userWish,
        );

        // adding user in our database
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(_user.toJson());

        res = "success";
      } else {
        res = "Maaf tidak ada yang boleh kosong";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Maaf tidak ada yang boleh kosong";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
