import 'package:fb_auth/fb_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            BlocProvider.of<AuthBloc>(context).add(LogoutEvent(_user));
          },
        ),
      ),
    );
  }
}
