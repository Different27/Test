import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository {
  late final FirebaseAuth _firebaseAuth;
  late final GoogleSignIn _googleSignIn;

  // Constructor
  UserRepository({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn}) {
    _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
    _googleSignIn = googleSignIn ?? GoogleSignIn();
  }
  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassWord(
      String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(), password: password);
  }

  // Register with email and password
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(), password: password);
  }

  //Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // User cancelled the sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  // Get current user
  Future<User?> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  // Check if user is signed in
  Future<bool> isSignedIn() async {
    return _firebaseAuth.currentUser != null;
  }
}
