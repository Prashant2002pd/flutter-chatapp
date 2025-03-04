import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  Future<UserCredential> signUpWithEmailAndPassword({required String email, required String password}) async {
    // Sign up with email and password
    try {
      UserCredential? userCredential=await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      rethrow;
    } catch (e) {
      print("error");
      print(e);
      rethrow;
    }
  }


  Future<UserCredential> signInWithEmailAndPassword({required String email, required String password}) async {
    // Sign in with email and password
    UserCredential? userCredential;
    try {
      userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(userCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      rethrow;
    } catch (e) {
      print("error");
      print(e);
      rethrow;
    }
    return userCredential!;

  }

  Future<void> signOut() async {
    // Sign out
    await FirebaseAuth.instance.signOut();
  }

  //create user document
  Future<void> createUserDocument(UserCredential? UserCredential, String username) async {
    // Create user document
    // This is where you can create a user document in Firestore
    if(UserCredential != null && UserCredential.user != null){
      // Create a user document in Firestore
      await FirebaseFirestore.instance.collection('users').doc(UserCredential.user!.uid).set({
        'uid': UserCredential.user!.uid,
        'email': UserCredential.user!.email,
        'username': username,
      });
    }
  }

  //get current user
  User? getCurrentUser(){
    // Get the current user
    return FirebaseAuth.instance.currentUser;
  }

}