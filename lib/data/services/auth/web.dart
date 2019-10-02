import 'package:firebase/firebase.dart';

import '../../classes/index.dart';

class FBAuth {
  final _auth = auth();

  Future _setPersistenceWeb(Auth _auth) async {
    try {
      var selectedPersistence = 'local';
      await _auth.setPersistence(selectedPersistence);
    } catch (e) {
      print('_auth.setPersistence -> $e');
    }
  }

  Future<AuthUser> login(String username, String password) async {
    await _setPersistenceWeb(_auth);
    try {
      final _result =
          await _auth.signInWithEmailAndPassword(username, password);
      if (_result != null && _result?.user != null) {
        final _user = AuthUser(
          uid: _result.user.uid,
          displayName: _result.user.displayName,
          email: _result.user?.email,
          isAnonymous: _result.user.isAnonymous,
          isEmailVerified: _result.user.emailVerified,
        );
        return _user;
      }
    } catch (e) {
      print('FBAuthUtils -> _loginWeb -> $e');
    }
    return null;
  }

  Future<AuthUser> startAsGuest() async {
    await _setPersistenceWeb(_auth);
    try {
      final _result = await _auth.signInAnonymously();
      if (_result != null && _result?.user != null) {
        final _user = AuthUser(
          uid: _result.user.uid,
          displayName: _result.user.displayName,
          email: _result.user?.email,
          isAnonymous: _result.user.isAnonymous,
          isEmailVerified: _result.user.emailVerified,
        );
        return _user;
      }
    } catch (e) {
      print('FBAuthUtils -> startAsGuest -> $e');
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

  Stream<AuthUser> onAuthChanged() {
    return _auth.onAuthStateChanged.map((user) {
      if (user == null) return null;
      final _user = AuthUser(
        uid: user.uid,
        displayName: user.displayName,
        email: user?.email,
        isAnonymous: user.isAnonymous,
        isEmailVerified: user.emailVerified,
      );
      return _user;
    });
  }

  Future<AuthUser> currentUser() async {
    await _setPersistenceWeb(_auth);
    try {
      final _result = _auth.currentUser;
      if (_result != null) {
        final _user = AuthUser(
          uid: _result.uid,
          displayName: _result.displayName,
          email: _result?.email,
          isAnonymous: _result.isAnonymous,
          isEmailVerified: _result.emailVerified,
        );
        return _user;
      }
    } catch (e) {
      print('FBAuthUtils -> currentUser -> $e');
    }
    return null;
  }

  Future editInfo({String displayName, String photoUrl}) async {
    final _user = _auth.currentUser;
    final _info = UserProfile();
    if (displayName != null) _info.displayName = displayName;
    if (photoUrl != null) _info.photoURL = photoUrl;
    try {
      await _user.updateProfile(_info);
    } catch (e) {
      throw 'Error editInfo -> $e';
    }
  }

  Future forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email);
    } catch (e) {
      throw 'Error forgotPassword -> $e';
    }
  }

  Future sendEmailVerification() async {
    try {
      final _user = _auth.currentUser;
      await _user.sendEmailVerification();
    } catch (e) {
      throw 'Error sendEmailVerification -> $e';
    }
  }

  Future<AuthUser> createAccount(String username, String password,
      {String displayName, String photoUrl}) async {
    final _user =
        await _auth.createUserWithEmailAndPassword(username, password);
    if (_user != null) {
      await editInfo(displayName: displayName, photoUrl: photoUrl);
    }
    return await currentUser();
  }
}
