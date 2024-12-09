import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mediasocial/entities/models/app_user.dart';
import 'package:mediasocial/entities/repository/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<AppUser?> registerWithEmailPassword(
      String name, String email, String password) async {
    try {
      // Attempt to create user
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Create new user object
      AppUser user =
          AppUser(uid: userCredential.user!.uid, email: email, name: name);

      // Save user details to Firestore
      await firebaseFirestore.collection("users").doc(user.uid).set({
        'name': user.name,
        'email': user.email,
      });

      // Return user
      return user;
    } catch (e) {
      throw Exception("Registration Failed: $e");
    }
  }
  // AppUser{uid,name,email}

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      DocumentSnapshot userDoc = await firebaseFirestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception("User document does not exist.");
      }

      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: userDoc['name'],
      );

      return user;
    } catch (e) {
      if (e is FirebaseAuthException) {
        print("Firebase Auth Error: ${e.code} - ${e.message}");
      } else {
        print("Other Error: $e");
      }
      throw Exception("Login Failed: $e");
    }
  }
  // AppUser{uid,name,email}

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }
  // logout cant access the instance.currentUser

  @override
  Future<AppUser?> getCurrenUser() async {
    // logged in user
    final firebaseUser = firebaseAuth.currentUser;
    // not logged in
    if (firebaseUser == null) return null;

    // fetch user from firebase
    DocumentSnapshot userDoc =
        await firebaseFirestore.collection("users").doc(firebaseUser.uid).get();

    // check if user exist
    if (!userDoc.exists) {
      return null;
    }
    // user exist
    return AppUser(
        uid: firebaseUser.uid,
        email: firebaseUser.email!,
        name: userDoc['name']);
  }
  // loggedIn ? AppUser(uid,name,email) : null
}
