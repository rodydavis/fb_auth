import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../classes/index.dart';
import 'helpers/index.dart';

class FbClient {
  FbClient(
    this.app, {
    @required this.onSave,
    @required this.onLoad,
  });

  final FbApp app;
  final Future<Map<String, dynamic>> Function() onLoad;

  final Future Function(Map<String, dynamic>) onSave;

  Future<AuthUser> login(String username, String password) async {
    final result = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${app.apiKey}',
      body: {
        "email": username,
        "password": password,
        "returnSecureToken": true,
      },
    );
    final token = await _saveToken(result);
    return _getUser(token?.idToken);
  }

  Future<AuthUser> createAccount(String username, String password,
      {String displayName, String photoUrl}) async {
    http.Response result = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${app.apiKey}',
      body: {
        "email": username,
        "password": password,
        "returnSecureToken": true,
      },
    );
    FirestoreJsonAccessToken token = await _saveToken(result);
    await editInfo(displayName: displayName, photoUrl: photoUrl);
    token = await _loadToken();
    return _getUser(token?.idToken);
  }

  Future<FirestoreJsonAccessToken> _saveToken(http.Response result) async {
    final _data = json.decode(result.body);
    final token = FirestoreJsonAccessToken(_data, DateTime.now());
    await onSave(_data);
    return token;
  }

  Future logout() async {
    // throw 'Platform Not Supported';
  }

  Future<AuthUser> currentUser() async {
    // throw 'Platform Not Supported';
    return null;
  }

  Future<AuthUser> startAsGuest() async {
    final result = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${app.apiKey}',
      body: {
        "returnSecureToken": true,
      },
    );
    FirestoreJsonAccessToken token = await _saveToken(result);
    return _getUser(token?.idToken);
  }

  Future<AuthUser> _getUser(String uid) async {
    http.Response result = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=${app.apiKey}',
      body: {
        "idToken": uid,
        "returnSecureToken": true,
      },
    );
    final _data = json.decode(result.body);
    final _users = List.from(_data);

    if (result != null)
      for (var item in _users) {
        final _user = FirebaseUser(item, uid);
        if (_user.uid == uid) {
          return AuthUser(
            displayName: _user?.displayName,
            email: _user?.email,
            isAnonymous: _user?.isAnonymous ?? true,
            isEmailVerified: _user?.isEmailVerified ?? false,
            uid: _user?.uid,
          );
        }
      }
    return null;
  }

  Stream<AuthUser> onAuthChanged() {
    // throw 'Platform Not Supported';
    return null;
  }

  Future editInfo({String displayName, String photoUrl}) async {
    FirestoreJsonAccessToken token = await _loadToken();
    final result = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:update?key=${app.apiKey}',
      body: {
        "idToken": token?.idToken,
        if (displayName != null) ...{
          'displayName': displayName,
        },
        if (photoUrl != null) ...{
          'photoUrl': photoUrl,
        },
        "deleteAttribute": [
          if (displayName == null) 'DISPLAY_NAME',
          if (photoUrl == null) 'PHOTO_URL',
        ],
        "returnSecureToken": true,
      },
    );
    await _saveToken(result);
  }

  Future<FirestoreJsonAccessToken> _loadToken() async {
    final _data = await onLoad();
    final token = FirestoreJsonAccessToken(_data, DateTime.now());
    return token;
  }

  Future forgotPassword(String email) async {
    // throw 'Platform Not Supported';
  }

  Future sendEmailVerification() async {
    // throw 'Platform Not Supported';
  }
}
