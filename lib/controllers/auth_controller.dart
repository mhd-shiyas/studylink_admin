import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studylink_admin/core/utils.dart';

class AdminAuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _uid;
  String get uid => _uid!;

  AdminAuthProvider() {
    checkSignInStatus();
  }

  // Check if user is already signed in
  Future<void> checkSignInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isSignedIn = prefs.getBool("is_signed_in") ?? false;
    _uid = prefs.getString("uid");
    notifyListeners();
  }

  // Save login session
  Future<void> saveLoginSession(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("is_signed_in", true);
    prefs.setString("uid", uid);
    _isSignedIn = true;
    _uid = uid;
    notifyListeners();
  }

  // Sign Up (Admin Registration)
  Future<void> signUp({
    required String email,
    required String password,
    required BuildContext context,
    required Function onSuccess,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        await saveLoginSession(userCredential.user!.uid);
        onSuccess();
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }

  // Login (Admin Authentication)
  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
    required Function onSuccess,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        await saveLoginSession(userCredential.user!.uid);
        onSuccess();
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }

  Future<void> resetPassword({
    required BuildContext context,
    required String email,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      showSnackBar(context, "Password reset link sent to $email");
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout (Clear session)
  Future<void> logout({required Function onSuccess,}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut();
    await prefs.clear();
    _isSignedIn = false;
    _uid = null;
    onSuccess();
    notifyListeners();
  }
}
