import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../classes/index.dart';
import '../auth/unsupported.dart';
import 'helpers/index.dart';

class FbClient implements FBAuth {
  FbClient(
    this.app, {
    @required this.onSave,
    @required this.onLoad,
  });

  @override
  final FbApp app;

  @override
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
    return _getUser(token);
  }

  @override
  Future<AuthUser> currentUser() async {
    // throw 'Platform Not Supported';
    return null;
  }

  @override
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

  @override
  Future forgotPassword(String email) async {
    // throw 'Platform Not Supported';
  }

  @override
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
    return _getUser(token);
  }

  @override
  Future logout() async {
    // throw 'Platform Not Supported';
  }

  @override
  Stream<AuthUser> onAuthChanged() {
    // throw 'Platform Not Supported';
    return null;
  }

  @override
  Future sendEmailVerification() async {
    // throw 'Platform Not Supported';
  }

  @override
  Future<AuthUser> startAsGuest() async {
    final result = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${app.apiKey}',
      body: json.encode({
        "returnSecureToken": true,
      }),
    );
    FirestoreJsonAccessToken token = await _saveToken(result);
    return _getUser(token);
  }

  final Future<Map<String, dynamic>> Function() onLoad;

  final Future Function(Map<String, dynamic>) onSave;

  Future<FirestoreJsonAccessToken> _saveToken(http.Response result) async {
    final _data = json.decode(result.body);
    print('Token -> $_data');
    final token = FirestoreJsonAccessToken(_data, DateTime.now());
    await onSave(_data);
    return token;
  }

  Future<AuthUser> _getUser(FirestoreJsonAccessToken token) async {
    http.Response result = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=${app.apiKey}',
        body: json.encode({
          "idToken": token.idToken,
          "returnSecureToken": true,
        }));
    final _users = List.from(json.decode(result.body)['users']);
    if (result != null)
      for (var item in _users) {
        final _user = FirebaseUser(item, token.idToken);
        if (_user.uid == token.localId) {
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

  Future<FirestoreJsonAccessToken> _loadToken() async {
    final _data = await onLoad();
    final token = FirestoreJsonAccessToken(_data, DateTime.now());
    return token;
  }
}
