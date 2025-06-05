import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:word_cards_mainor_2025_spring/controllers/auth/auth.dart';

/// Firebase implementation of [Auth]
class FirebaseAuthImpl implements Auth {
  final FirebaseAuth _firebase = FirebaseAuth.instance;

  @override
  Stream<User?> get authStateChanges => _firebase.authStateChanges();

  @override
  User? get currentUser => _firebase.currentUser;

  @override
  Future<User?> signInAnonymously() async {
    UserCredential cred = await _firebase.signInAnonymously();
    return cred.user;
  }

  @override
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    UserCredential cred = await _firebase.signInWithEmailAndPassword(email: email, password: password);
    return cred.user;
  }

  @override
  Future<void> signOut() => _firebase.signOut();
}