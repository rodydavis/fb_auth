import 'package:firebase/firebase.dart';

import '../../classes/index.dart';
import 'impl.dart';

class FBAuth implements FBAuthImpl {
  final FbApp app;
  Auth _auth;

  FBAuth(this.app) {
    if (apps.isEmpty) {
      initializeApp(
          apiKey: this.app.apiKey,
          authDomain: this.app.authDomain,
          databaseURL: this.app.databaseURL,
          projectId: this.app.projectId,
          storageBucket: this.app.storageBucket,
          messagingSenderId: this.app.messagingSenderId,
          appId: this.app.appId,
          measurementId: this.app.measurementId
      );
    }
    _auth = auth();
  }

  Future _setPersistenceWeb(Auth _auth) async {
    // try {
    //   var selectedPersistence = 'local';
    //   await _auth.setPersistence(selectedPersistence);
    // } catch (e) {
    //   print('_auth.setPersistence -> $e');
    // }
  }

  @override
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
          photoUrl: _result.user.photoURL,
        );
        return _user;
      }
    } catch (e) {
      print('FBAuthUtils -> _loginWeb -> $e');
    }
    return null;
  }

  @override
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
          photoUrl: _result.user.photoURL,
        );
        return _user;
      }
    } catch (e) {
      print('FBAuthUtils -> startAsGuest -> $e');
    }
    return null;
  }

  @override
  Future logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('FBAuthUtils -> logout -> $e');
    }
    return null;
  }

  @override
  Stream<AuthUser> onAuthChanged() {
    return _auth.onAuthStateChanged.map((user) {
      if (user == null) return null;
      final _user = AuthUser(
        uid: user.uid,
        displayName: user.displayName,
        email: user?.email,
        isAnonymous: user.isAnonymous,
        isEmailVerified: user.emailVerified,
        photoUrl: user.photoURL,
      );
      return _user;
    });
  }

  @override
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
          photoUrl: _result.photoURL,
        );
        return _user;
      }
    } catch (e) {
      print('FBAuthUtils -> currentUser -> $e');
    }
    return null;
  }

  @override
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

  @override
  Future forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email);
    } catch (e) {
      throw 'Error forgotPassword -> $e';
    }
  }

  @override
  Future sendEmailVerification() async {
    try {
      final _user = _auth.currentUser;
      await _user.sendEmailVerification();
    } catch (e) {
      throw 'Error sendEmailVerification -> $e';
    }
  }

  @override
  Future<AuthUser> createAccount(String username, String password,
      {String displayName, String photoUrl}) async {
    UserCredential _user;
    try {
      _user = await _auth.createUserWithEmailAndPassword(username, password);
      if (_user != null) {
        await editInfo(displayName: displayName, photoUrl: photoUrl);
      }
    } catch (e) {}
    if (_user == null) {
      try {
        _user = await _auth.signInWithEmailAndPassword(username, password);
      } catch (err) {
        throw Exception(err);
      }
    }
    return await currentUser();
  }

  @override
  Future loginCustomToken(String token) async {
    await _setPersistenceWeb(_auth);
    try {
      final _result = await _auth.signInAndRetrieveDataWithCustomToken(token);
      if (_result != null && _result?.user != null) {
        final _user = AuthUser(
          uid: _result.user.uid,
          displayName: _result.user.displayName,
          email: _result.user?.email,
          isAnonymous: _result.user.isAnonymous,
          isEmailVerified: _result.user.emailVerified,
          photoUrl: _result.user.photoURL,
        );
        return _user;
      }
    } catch (e) {
      print('FBAuthUtils -> loginCustomToken -> $e');
    }
    return null;
  }

  @override
  Future loginGoogle({String idToken, String accessToken}) async {
    final _cred = GoogleAuthProvider.credential(idToken, accessToken);
    await _setPersistenceWeb(_auth);
    try {
      final _result = await _auth.signInWithCredential(_cred);
      if (_result != null && _result?.user != null) {
        final _user = AuthUser(
          uid: _result.user.uid,
          displayName: _result.user.displayName,
          email: _result.user?.email,
          isAnonymous: _result.user.isAnonymous,
          isEmailVerified: _result.user.emailVerified,
          photoUrl: _result.user.photoURL,
        );
        return _user;
      }
    } catch (e) {
      print('FBAuthUtils -> loginCustomToken -> $e');
    }
    return null;
  }
}
