import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthentication{
  final authService = AuthService();
  final googleSignIn = GoogleSignIn(scopes: ['email']);

  Stream<User?> get currentUser => authService.currentUser;

  loginGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (error) {
      // ignore: avoid_print
      print(error);
    }
  }

  logout() {
    authService.logout();
  }
}