import 'package:firebase_auth/firebase_auth.dart';

abstract class Auth {
  /// Emits the current [User] when the auth state changes.
  Stream<User?> get authStateChanges;

  /// The currently signed‐in [User], or `null` if none.
  User? get currentUser;

  /// Signs in anonymously and returns the signed‐in [User].
  Future<User?> signInAnonymously();

  /// Signs out the current user.
  Future<void> signOut();
}