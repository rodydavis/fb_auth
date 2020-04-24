import 'dart:convert';
import 'dart:io';

import '../../classes/index.dart';
import '../../utils/directory.dart';
import '../sdk/sdk.dart';
import '../rest_api/client.dart';
import 'impl.dart';

class FBAuth implements FBAuthImpl {
  final FbApp app;
  final bool useRestClient;
  File _saveFile;

  FBAuth(
    this.app, {
    this.useRestClient = false,
  }) {
    if (useClient) {
      _client = FbClient(
        app,
        onLoad: () async {
          await _loadFile();
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
            if (data == null) {
              await _saveFile.delete();
            } else {
              await _saveFile.writeAsString(json.encode(data));
            }
          } catch (e) {}
        },
      );
    }
    else {
      _sdk = FbSdk();
    }
  }

  Future _loadFile() async {
    if (_saveFile == null) {
      final dir = await PathUtils.getDocumentDir();
      _saveFile = File('${dir.path}/fb_auth.json');
    }
  }

  bool get useClient => useRestClient || Platform.isWindows || Platform.isLinux;

  FbSdk _sdk;
  FbClient _client;

  @override
  Future<AuthUser> login(String username, String password) async {
    if (useClient) {
      await _loadFile();
      return _client.login(username, password);
    } else {
      return _sdk.login(username, password);
    }
  }

  @override
  Stream<AuthUser> onAuthChanged() {
    if (useClient) {
      return _client.onAuthChanged();
    } else {
      return _sdk.onAuthChanged();
    }
  }

  @override
  Future<AuthUser> startAsGuest() async {
    try {
      if (useClient) {
        await _loadFile();
        return _client.startAsGuest();
      } else {
        return _sdk.startAsGuest();
      }
    } catch (e) {}
    return null;
  }

  @override
  Future logout() async {
    if (useClient) {
      await _loadFile();
      await _client.logout();
    } else {
      await _sdk.logout();
    }
    try {
      await _saveFile.delete();
    } catch (e) {}
    return null;
  }

  @override
  Future<AuthUser> currentUser() async {
    if (useClient) {
      await _loadFile();
      return _client.currentUser();
    } else {
      return _sdk.currentUser();
    }
  }

  @override
  Future editInfo({String displayName, String photoUrl}) async {
    if (useClient) {
      await _loadFile();
      return _client.editInfo(
        displayName: displayName,
        photoUrl: photoUrl,
      );
    } else {
      return _sdk.editInfo(
        displayName: displayName,
        photoUrl: photoUrl,
      );
    }
  }

  @override
  Future forgotPassword(String email) async {
    if (useClient) {
      await _loadFile();
      return _client.forgotPassword(email);
    } else {
      return _sdk.forgotPassword(email);
    }
  }

  @override
  Future sendEmailVerification() async {
    if (useClient) {
      await _loadFile();
      return _client.sendEmailVerification();
    } else {
      return _sdk.sendEmailVerification();
    }
  }

  @override
  Future<AuthUser> createAccount(String username, String password,
      {String displayName, String photoUrl}) async {
    if (useClient) {
      await _loadFile();
      return _client.createAccount(
        username,
        password,
        photoUrl: photoUrl,
        displayName: displayName,
      );
    } else {
      return _sdk.createAccount(
        username,
        password,
        photoUrl: photoUrl,
        displayName: displayName,
      );
    }
  }

  @override
  Future loginCustomToken(String token) async {
    if (useClient) {
      return _client.loginCustomToken(token);
    } else {
      return _sdk.loginCustomToken(token);
    }
  }

  @override
  Future loginGoogle({String idToken, String accessToken}) async {
    if (useClient) {
      return _client.loginGoogle(
        idToken: idToken,
        accessToken: accessToken,
      );
    } else {
      return _sdk.loginGoogle(
        idToken: idToken,
        accessToken: accessToken,
      );
    }
  }
}
