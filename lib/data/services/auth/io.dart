import 'dart:convert';
import 'dart:io';

import '../../classes/index.dart';
import '../../utils/directory.dart';
import '../mobile/sdk.dart';
import '../rest_api/client.dart';

class FBAuth {
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
    if (isMobile) {
      _sdk = FbSdk();
    }
  }
  bool get useClient => isDesktop || useRestClient;
  static bool get isDesktop =>
      Platform.isWindows || Platform.isWindows || Platform.isMacOS;
  static bool get isMobile => Platform.isIOS || Platform.isAndroid;
  FbSdk _sdk;
  FbClient _client;

  Future<AuthUser> login(String username, String password) async {
    if (useClient) {
      return _client.login(username, password);
    } else {
      return _sdk.login(username, password);
    }
    return null;
  }

  Stream<AuthUser> onAuthChanged() {
    if (useClient) {
      return _client.onAuthChanged();
    } else {
      return _sdk.onAuthChanged();
    }
  }

  Future<AuthUser> startAsGuest() async {
    try {
      if (useClient) {
        return _client.startAsGuest();
      } else {
        return _sdk.startAsGuest();
      }
    } catch (e) {}
    return null;
  }

  Future logout() async {
    if (useClient) {
      await _client.logout();
    } else {
      await _sdk.logout();
    }
    try {
      await _saveFile.delete();
    } catch (e) {}
    return null;
  }

  Future<AuthUser> currentUser() async {
    if (useClient) {
      return _client.currentUser();
    } else {
      return _sdk.currentUser();
    }
  }

  Future editInfo({String displayName, String photoUrl}) async {
    if (useClient) {
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

  Future forgotPassword(String email) async {
    if (useClient) {
      return _client.forgotPassword(email);
    } else {
      return _sdk.forgotPassword(email);
    }
  }

  Future sendEmailVerification() async {
    if (useClient) {
      return _client.sendEmailVerification();
    } else {
      return _sdk.sendEmailVerification();
    }
  }

  Future<AuthUser> createAccount(String username, String password,
      {String displayName, String photoUrl}) async {
    if (useClient) {
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
    return null;
  }
}
