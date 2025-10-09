import 'package:check_in/core/utils/toast_util.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  FirebaseService._internal();
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Sign-in method
  Future<bool> signIn({required String email, required String password}) async {
    try {
      final response = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (response.user != null) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      ToastUtil.showErrorToast(error.toString());
      return false;
    }
  }

  // Sign-up in method
  Future<bool> signUp(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final response = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (response.user != null) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      ToastUtil.showErrorToast(error.toString());
      return false;
    }
  }

  // logout method

  Future<bool> logout() async {
    try {
      firebaseAuth.signOut();
      return true;
    } catch (error) {
      return false;
    }
  }
}
