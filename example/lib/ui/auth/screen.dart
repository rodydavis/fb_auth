import 'package:fb_auth/fb_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                        _auth.add(CreateAccount(_email, _password,
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
                        _auth.add(LoginEvent(_email, _password));
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
                ListTile(
                    title: RaisedButton(
                  child: Text('Start as Guest'),
                  onPressed: () {
                    _auth.add(LoginGuest());
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
