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
    apiKey: "API_KEY",
    authDomain: "AUTH_DOMAIN",
    databaseURL: "DATABASE_URL",
    projectId: "PROJECT_ID",
    storageBucket: "STORAGE_BUCKET",
    messagingSenderId: "MESSAGING_SENDER_ID",
    appId: "APP_ID",
  );

  AuthBloc _auth;
  StreamSubscription<AuthUser> _userChanged;

  @override
  void dispose() {
    _auth.close();
    _userChanged?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _auth = AuthBloc(saveUser: _saveUser, deleteUser: _deleteUser, app: _app);
    _auth.add(CheckUser());
    final _fbAuth = FBAuth(_app);
    _userChanged = _fbAuth.onAuthChanged().listen((user) {
      _auth.add(UpdateUser(user));
    });
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
