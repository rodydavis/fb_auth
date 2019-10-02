import 'dart:async';

import 'package:fb_auth/fb_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'plugins/desktop/desktop.dart';
import 'ui/auth/check.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setTargetPlatformForDesktop();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _app = FbApp(
    // apiKey: "API_KEY",
    // authDomain: "AUTH_DOMAIN",
    // databaseURL: "DATABASE_URL",
    // projectId: "PROJECT_ID",
    // storageBucket: "STORAGE_BUCKET",
    // messagingSenderId: "MESSAGING_SENDER_ID",
    // appId: "APP_ID",
    apiKey: "AIzaSyCBotmOEP9eOpsvh0HFWRqtMki5qcQdzgk",
    authDomain: "ampstor.firebaseapp.com",
    databaseURL: "https://ampstor.firebaseio.com",
    projectId: "ampstor",
    storageBucket: "ampstor.appspot.com",
    messagingSenderId: "561515444898",
    appId: "1:561515444898:web:9060ee5d860d2ef2",
  );

  AuthBloc _auth;
  StreamSubscription<AuthUser> _userChanged;

  @override
  void dispose() {
    _auth.dispose();
    _userChanged?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _auth = AuthBloc(saveUser: _saveUser, deleteUser: _deleteUser, app: _app);
    _auth.dispatch(CheckUser());
    final _fbAuth = FBAuth(_app);
    final _authUpdate = _fbAuth.onAuthChanged();
    if (_authUpdate != null) {
      _userChanged = _authUpdate.listen((user) {
        _auth.dispatch(UpdateUser(user));
      });
    }
    super.initState();
  }

  static _deleteUser() async {}

  static _saveUser(user) async {}

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(builder: (_) => _auth),
      ],
      child: MaterialApp(
        home: AuthCheck(),
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(),
//       ),
//     );
//   }
// }
