import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up with email and password
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print(e);
    }
  }

  Future<String?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Retrieve the user's role from Firestore
      DocumentSnapshot userSnapshot = await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();
      String? role = userSnapshot['role'];

      return role; // Return the user's role
    } catch (e) {
      return null; // Return null in case of login failure
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? getCurrentUserId() {
    final User? user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return null; // User is not signed in
    }
  }

  Future<String?> getUserRole(String email) async {
    try {
      // Retrieve the user document from Firestore using the user's email
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If the user document exists, return the role
        return querySnapshot.docs[0]['role'];
      } else {
        // User document not found
        return null;
      }
    } catch (e) {
      // Handle any errors
      print('Error getting user role: $e');
      return null;
    }
  }

  Future<bool> checkIfUserExists(String email) async {
    try {
      // Query Firestore to check if a user document with the provided email exists
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      // Handle any errors
      print('Error checking user existence: $e');
      return false;
    }
  }

  bool isUserLoggedIn() {
    return auth.currentUser != null;
  }
}
