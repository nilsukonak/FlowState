import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginProvider with ChangeNotifier {
  User? _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => _user;
  String? get uid => _user?.uid;
  LoginProvider() {
    _user = _auth.currentUser;
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    //taskprovider?.setUserId(null);
    notifyListeners();
  }

  Future<UserCredential> signIn(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    _user = userCredential.user;

    notifyListeners();

    return userCredential;
  }

  Future<void> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn.instance;

    await googleSignIn.initialize(
      serverClientId:
          '1036716919728-i9i0nqscdft2e5rm8m45j6fej5dhvca5.apps.googleusercontent.com',
    );

    final googleUser = await googleSignIn.authenticate();

    final googleAuth = googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);

    final user = userCredential.user;

    if (user == null) {
      throw Exception('Google sign-in failed.');
    }

    await FirebaseFirestore.instance.collection('user').doc(user.uid).set({
      'email': user.email,
      'name': user.displayName,
    }, SetOptions(merge: true));

    _user = user;
    notifyListeners();
  }

  Future<void> signUp(String email, String password) async {
    UserCredential uc = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await FirebaseFirestore.instance.collection('user').doc(uc.user!.uid).set({
      'email': email, //password gerek yok zaten tutuluyo
    });

    await _auth
        .signOut(); //kayıt olunca hemen girş yapmıs sayılmasn diye cıkıs yaptırtk

    _user = null;
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }
}
