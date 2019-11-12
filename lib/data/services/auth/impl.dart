import '../../classes/index.dart';

abstract class FBAuthImpl {
  final FbApp app;

  FBAuthImpl(this.app);

  Future<AuthUser> login(String username, String password) async {
    throw 'Platform Not Supported';
  }

  Future<AuthUser> createAccount(String username, String password,
      {String displayName, String photoUrl}) async {
    throw 'Platform Not Supported';
  }

  Future logout() async {
    throw 'Platform Not Supported';
  }

  Future<AuthUser> currentUser() async {
    throw 'Platform Not Supported';
  }

  Future<AuthUser> startAsGuest() async {
    throw 'Platform Not Supported';
  }

  Stream<AuthUser> onAuthChanged() {
    throw 'Platform Not Supported';
  }

  Future editInfo({String displayName, String photoUrl}) async {
    throw 'Platform Not Supported';
  }

  Future forgotPassword(String email) async {
    throw 'Platform Not Supported';
  }

  Future sendEmailVerification() async {
    throw 'Platform Not Supported';
  }

  Future loginCustomToken(String token) async {
    throw 'Platform Not Supported';
  }

  Future loginGoogle({String idToken, String accessToken}) async {
    throw 'Platform Not Supported';
  }
}
