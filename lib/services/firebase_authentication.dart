// import 'dart:developer';

// import 'package:finshare/util/constants.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/services.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Authentication {
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//   Future<FirebaseUser> handleSignIn() async {
//     print("Handle sign is is invoked");
//     FirebaseUser user;

//     bool _isSignedIn = await _googleSignIn.isSignedIn();
//     print("Value of bool " + _isSignedIn.toString());

//     if (_isSignedIn) {
//       user = await _firebaseAuth.currentUser();
//       return user;
//     }
//     GoogleSignInAccount _googleUser;
//     try {
//       _googleUser = await _googleSignIn?.signIn();
//     } catch (error) {
//       print("Error Caught");
//       return null;
//     }
//     if (_googleUser == null) return null;
//     final GoogleSignInAuthentication _googleAuth = await _googleUser?.authentication;
//     if (_googleAuth == null) return null;

//     final AuthCredential _authCredential =
//         GoogleAuthProvider.getCredential(idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);

//     user = (await _firebaseAuth.signInWithCredential(_authCredential)).user;

//     SharedPreferences _prefs = await SharedPreferences.getInstance();
//     _prefs.setString(AppConstants.userID, user.uid);

//     log("Google user signed as :" + _prefs.getString(AppConstants.userID));
//     return user;
//   }

//   Future<FirebaseUser> getCurrentUser() async {
//     FirebaseUser user = await _firebaseAuth.currentUser();
//     return user;
//   }

//   Future<FirebaseUser> handleSignInEmail(String userid, String password) async {
//     print(userid);
//     print(password);
//     AuthResult result;
//     try {
//       result = await _firebaseAuth.signInWithEmailAndPassword(email: userid, password: password);
//     } on PlatformException catch (e) {
//       print(e);
//     }
//     final FirebaseUser user = result.user;

//     assert(user != null);
//     assert(await user.getIdToken() != null);

//     final FirebaseUser currentUser = await _firebaseAuth.currentUser();
//     assert(user.uid == currentUser.uid);

//     print('signInEmail succeeded: $user');

//     return user;
//   }

//   Future<FirebaseUser> handleSignUp(String userid, String password) async {
//     print(userid);
//     print(password);
//     AuthResult result;

//     try {
//       result = await _firebaseAuth.createUserWithEmailAndPassword(email: userid, password: password);
//     } catch (e) {
//       print(e);
//     }

//     final FirebaseUser user = result.user;

//     assert(user != null);
//     assert(await user.getIdToken() != null);

//     return user;
//   }

//   handleSignOut() async {
//     _googleSignIn.disconnect();
//     SharedPreferences _prefs = await SharedPreferences.getInstance();
//     _prefs.remove(AppConstants.userID);
//     _prefs.remove(AppConstants.isRegistered);
//     await _firebaseAuth.signOut().then((value) {
//       print("User is Signed out");
//     });
//   }
// }
