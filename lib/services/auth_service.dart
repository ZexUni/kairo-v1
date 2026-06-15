import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KairoUser {
  final String uid;
  final String? email;
  final String? displayName;

  const KairoUser({
    required this.uid,
    this.email,
    this.displayName,
  });
}

class KairoUserCredential {
  final KairoUser? user;
  const KairoUserCredential({this.user});
}

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal() {
    _init();
  }

  FirebaseAuth? get _auth {
    try {
      if (Firebase.apps.isNotEmpty) {
        return FirebaseAuth.instance;
      }
    } catch (_) {}
    return null;
  }

  FirebaseFirestore? get _firestore {
    try {
      if (Firebase.apps.isNotEmpty) {
        return FirebaseFirestore.instance;
      }
    } catch (_) {}
    return null;
  }

  GoogleSignIn? get _googleSignIn {
    try {
      return GoogleSignIn();
    } catch (_) {}
    return null;
  }

  KairoUser? _localUser;
  final StreamController<KairoUser?> _authStreamController = StreamController<KairoUser?>.broadcast();

  KairoUser? get currentUser {
    try {
      if (Firebase.apps.isNotEmpty) {
        final fbUser = FirebaseAuth.instance.currentUser;
        if (fbUser != null) {
          return KairoUser(
            uid: fbUser.uid,
            email: fbUser.email,
            displayName: fbUser.displayName,
          );
        }
      }
    } catch (e) {
      debugPrint("AuthService error reading currentUser: $e");
    }
    return _localUser;
  }

  Stream<KairoUser?> get authStateChanges => _authStreamController.stream;

  void _init() {
    try {
      if (Firebase.apps.isNotEmpty) {
        FirebaseAuth.instance.authStateChanges().listen((fbUser) {
          _authStreamController.add(currentUser);
          notifyListeners();
        });
      }
    } catch (e) {
      debugPrint("AuthService init listener failed: $e");
    }
  }

  Future<KairoUserCredential> signUpWithEmail(String email, String password) async {
    final auth = _auth;
    if (auth != null) {
      try {
        final credential = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final user = credential.user;
        final kairoUser = user != null
            ? KairoUser(uid: user.uid, email: user.email, displayName: user.displayName)
            : null;
        _authStreamController.add(kairoUser);
        notifyListeners();
        return KairoUserCredential(user: kairoUser);
      } catch (e) {
        rethrow;
      }
    } else {
      // Offline mode
      await Future.delayed(const Duration(milliseconds: 500));
      _localUser = KairoUser(
        uid: 'local_user',
        email: email,
        displayName: email.split('@').first,
      );
      _authStreamController.add(_localUser);
      notifyListeners();
      return KairoUserCredential(user: _localUser);
    }
  }

  Future<KairoUserCredential> signInWithEmail(String email, String password) async {
    final auth = _auth;
    if (auth != null) {
      try {
        final credential = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        final user = credential.user;
        final kairoUser = user != null
            ? KairoUser(uid: user.uid, email: user.email, displayName: user.displayName)
            : null;
        _authStreamController.add(kairoUser);
        notifyListeners();
        return KairoUserCredential(user: kairoUser);
      } catch (e) {
        rethrow;
      }
    } else {
      // Offline mode
      await Future.delayed(const Duration(milliseconds: 500));
      _localUser = KairoUser(
        uid: 'local_user',
        email: email,
        displayName: email.split('@').first,
      );
      _authStreamController.add(_localUser);
      notifyListeners();
      return KairoUserCredential(user: _localUser);
    }
  }

  Future<KairoUserCredential> signInWithGoogle() async {
    final auth = _auth;
    final gSignIn = _googleSignIn;
    if (auth != null && gSignIn != null) {
      try {
        final GoogleSignInAccount? googleUser = await gSignIn.signIn();
        if (googleUser == null) {
          throw FirebaseAuthException(
            code: 'ERROR_ABORTED_BY_USER',
            message: 'Sign in aborted by user',
          );
        }

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential = await auth.signInWithCredential(credential);
        final user = userCredential.user;
        final kairoUser = user != null
            ? KairoUser(uid: user.uid, email: user.email, displayName: user.displayName)
            : null;
        _authStreamController.add(kairoUser);
        notifyListeners();
        return KairoUserCredential(user: kairoUser);
      } catch (e) {
        rethrow;
      }
    } else {
      // Offline mode
      await Future.delayed(const Duration(milliseconds: 500));
      _localUser = const KairoUser(
        uid: 'local_user',
        email: 'google_guest@kairo.app',
        displayName: 'Google Guest',
      );
      _authStreamController.add(_localUser);
      notifyListeners();
      return KairoUserCredential(user: _localUser);
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    final auth = _auth;
    if (auth != null) {
      await auth.sendPasswordResetEmail(email: email);
    } else {
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  Future<void> signOut() async {
    final auth = _auth;
    final gSignIn = _googleSignIn;
    try {
      if (auth != null) await auth.signOut();
      if (gSignIn != null) await gSignIn.signOut();
    } catch (e) {
      debugPrint("Firebase signOut error: $e");
    }
    _localUser = null;
    _authStreamController.add(null);
    notifyListeners();
  }

  Future<void> syncProfileToFirestore(String userId, Map<String, dynamic> profileData) async {
    final firestore = _firestore;
    if (firestore != null) {
      try {
        await firestore.collection('users').doc(userId).set(
          profileData,
          SetOptions(merge: true),
        );
      } catch (e) {
        debugPrint("Firestore sync failed: $e");
      }
    }
  }

  Future<bool> checkProfileExistsInFirestore(String userId) async {
    final firestore = _firestore;
    if (firestore != null) {
      try {
        final doc = await firestore.collection('users').doc(userId).get();
        return doc.exists;
      } catch (e) {
        debugPrint("Firestore check failed: $e");
        return false;
      }
    }
    return false;
  }
}
