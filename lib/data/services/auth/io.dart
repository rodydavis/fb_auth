import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import '../../classes/index.dart';
import '../../utils/directory.dart';
import '../rest_api/client.dart';

class FBAuth {
  final FbApp app;
  final bool useRestClient;
  File _saveFile;
  final _auth = FirebaseAuth.instance;

  FBAuth(
    this.app, {
    this.useRestClient = false,
  }) {
    _client = FbClient(
      app,
      onLoad: () async {
        final dir = await PathUtils.getDocumentDir();
        _saveFile = File('${dir.path}/fb_auth.json');
        Map<String, dynamic> storage = Map<String, dynamic>();
        if (await _saveFile.exists()) {
          try {
            storage = json.decode(await _saveFile.readAsString())
                as Map<String, dynamic>;
            return storage;
          } catch (_) {
            await _saveFile.delete();
          }
        }
        return null;
      },
      onSave: (data) async {
        try {
          await _saveFile.writeAsString(json.encode(data));
        } catch (e) {}
      },
    );
  }
  bool get useClient => isDesktop || useRestClient;
  bool get isDesktop =>
      Platform.isWindows || Platform.isWindows || Platform.isMacOS;

  FbClient _client;

  Future<AuthUser> login(String username, String password) async {
    if (useClient) {
    } else {
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
    }
    return null;
  }

  Stream<AuthUser> onAuthChanged() {
    if (useClient) {
    } else {
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
    return null;
  }

  Future<AuthUser> startAsGuest() async {
    if (useClient) {
      try {
        return _client.startAsGuest();
      } catch (e) {}
    } else {
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
    }
    return null;
  }

  Future logout() async {
    if (useClient) {
    } else {
      try {
        await _auth.signOut();
      } catch (e) {
        print('FBAuthUtils -> logout -> $e');
      }
    }
    try {
      await _saveFile.delete();
    } catch (e) {}
    return null;
  }

  Future<AuthUser> currentUser() async {
    if (useClient) {
    } else {
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
    }
    return null;
  }

  Future editInfo({String displayName, String photoUrl}) async {
    if (useClient) {
    } else {
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
  }

  Future forgotPassword(String email) async {
    if (useClient) {
    } else {
      try {
        await _auth.sendPasswordResetEmail(email: email);
      } catch (e) {
        throw 'Error forgotPassword -> $e';
      }
    }
  }

  Future sendEmailVerification() async {
    if (useClient) {
    } else {
      try {
        final _user = await _auth.currentUser();
        await _user.sendEmailVerification();
      } catch (e) {
        throw 'Error sendEmailVerification -> $e';
      }
    }
  }

  Future<AuthUser> createAccount(String username, String password,
      {String displayName, String photoUrl}) async {
    if (useClient) {
    } else {
      final _user = await _auth.createUserWithEmailAndPassword(
          email: username, password: password);
      if (_user != null) {
        await editInfo(displayName: displayName, photoUrl: photoUrl);
      }
      return await currentUser();
    }
    return null;
  }
}
