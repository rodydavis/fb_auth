import 'package:firebase_auth/firebase_auth.dart';

import '../../classes/index.dart';

class FBAuth {
  final _auth = FirebaseAuth.instance;

  Future<AuthUser> login(String username, String password) async {
    try {
      final _result = await _auth.signInWithEmailAndPassword(
          email: username, password: password);
      if (_result != null && _result?.user != null) {
        final _user = AuthUser(
          uid: _result.user.uid,
          displayName: _result.user.displayName,
          email: _result.user?.email,
          isAnonymous: _result.user.isAnonymous,
          isEmailVerified: _result.user.isEmailVerified,
        );
        return _user;
      }
    } catch (e) {
      print('FBAuthUtils -> _loginMobile -> $e');
    }
    return null;
  }

  Stream<AuthUser> onAuthChanged() {
    return _auth.onAuthStateChanged.map((user) {
      if (user == null) return null;
      final _user = AuthUser(
        uid: user.uid,
        displayName: user.displayName,
        email: user?.email,
        isAnonymous: user.isAnonymous,
        isEmailVerified: user.isEmailVerified,
      );
      return _user;
    });
  }

  Future<AuthUser> startAsGuest() async {
    final _result = await _auth.signInAnonymously();
    if (_result != null && _result?.user != null) {
      final _user = AuthUser(
        uid: _result.user.uid,
        displayName: _result.user.displayName,
        email: _result.user?.email,
        isAnonymous: _result.user.isAnonymous,
        isEmailVerified: _result.user.isEmailVerified,
      );
      return _user;
    }
    return null;
  }

  Future logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('FBAuthUtils -> logout -> $e');
    }
    return null;
  }

  Future<AuthUser> currentUser() async {
    try {
      final _result = await _auth.currentUser();
      if (_result != null) {
        final _user = AuthUser(
          uid: _result.uid,
          displayName: _result.displayName,
          email: _result?.email,
          isAnonymous: _result.isAnonymous,
          isEmailVerified: _result.isEmailVerified,
        );
        return _user;
      }
    } catch (e) {
      print('FBAuthUtils -> currentUser -> $e');
    }
    return null;
  }

  Future editInfo({String displayName, String photoUrl}) async {
    final _user = await _auth.currentUser();
    final _info = UserUpdateInfo();
    if (displayName != null) _info.displayName = displayName;
    if (photoUrl != null) _info.photoUrl = photoUrl;
    try {
      await _user.updateProfile(_info);
    } catch (e) {
      throw 'Error editInfo -> $e';
    }
  }

  Future forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw 'Error forgotPassword -> $e';
    }
  }

  Future sendEmailVerification() async {
    try {
      final _user = await _auth.currentUser();
      await _user.sendEmailVerification();
    } catch (e) {
      throw 'Error sendEmailVerification -> $e';
    }
  }

  Future<AuthUser> createAccount(String username, String password,
      {String displayName, String photoUrl}) async {
    final _user = await _auth.createUserWithEmailAndPassword(
        email: username, password: password);
    if (_user != null) {
      await editInfo(displayName: displayName, photoUrl: photoUrl);
    }
    return await currentUser();
  }
}
