import 'dart:async';

import 'package:fb_auth/fb_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'plugins/desktop/desktop.dart';

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
    _userChanged.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _auth = AuthBloc(saveUser: _saveUser, deleteUser: _deleteUser, app: _app);
    _auth.dispatch(CheckUser());
    final _fbAuth = FBAuth(_app);
    _userChanged = _fbAuth.onAuthChanged().listen((user) {
      _auth.dispatch(UpdateUser(user));
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

class AuthCheck extends StatelessWidget {
  const AuthCheck({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is LoggedInState) {
          return HomeScreen();
        }
        return LoginScreen();
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _createAccount = true;
  final _formKey = GlobalKey<FormState>();
  String _email, _password, _name;

  @override
  Widget build(BuildContext context) {
    final _auth = BlocProvider.of<AuthBloc>(context);
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text('Login to Firebase'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: _createAccount,
                  child: ListTile(
                    title: TextFormField(
                      decoration: InputDecoration(labelText: 'Display Name'),
                      onSaved: (val) => _name = val,
                    ),
                  ),
                ),
                ListTile(
                  title: TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (val) => val.isEmpty ? 'Email Required' : null,
                    onSaved: (val) => _email = val,
                  ),
                ),
                ListTile(
                  title: TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    validator: (val) =>
                        val.isEmpty ? 'Password Required' : null,
                    onSaved: (val) => _password = val,
                  ),
                ),
                if (_createAccount) ...[
                  ListTile(
                      title: RaisedButton(
                    child: Text('Sign Up'),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _auth.dispatch(CreateAccount(_email, _password,
                            displayName: _name));
                      }
                    },
                  )),
                ] else ...[
                  ListTile(
                      title: RaisedButton(
                    child: Text('Login'),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _auth.dispatch(LoginEvent(_email, _password));
                      }
                    },
                  )),
                ],
                ListTile(
                    title: FlatButton(
                  child: Text(_createAccount
                      ? 'Already have an account?'
                      : 'Create a new account?'),
                  onPressed: () {
                    if (mounted)
                      setState(() {
                        _createAccount = !_createAccount;
                      });
                  },
                )),
                if (state is AuthLoadingState) ...[CircularProgressIndicator()],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = AuthBloc.currentUser(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${_user?.displayName ?? 'Guest'}'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Logout'),
          onPressed: () {
            BlocProvider.of<AuthBloc>(context).dispatch(LogoutEvent(_user));
          },
        ),
      ),
    );
  }
}
