import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './bloc.dart';
import '../../../fb_auth.dart';
import '../../classes/auth_user.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    @required this.app,
    this.saveUser,
    this.deleteUser,
  }) : _auth = FBAuth(app);

  final FbApp app;

  final FBAuth _auth;

  @override
  AuthState get initialState => InitialAuthState();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is CheckUser) {
      yield* _mapCheckToState(event);
    }
    if (event is LoginEvent) {
      yield* _mapLoginToState(event);
    }
    if (event is LogoutEvent) {
      yield* _mapLogoutToState(event);
    }
    if (event is CreateAccount) {
      yield* _mapCreateToState(event);
    }
    if (event is UpdateUser) {
      yield* _mapUpdateToState(event);
    }
    if (event is EditInfo) {
      yield* _mapEditInfoToState(event);
    }
    if (event is ForgotPassword) {
      yield* _mapForgotPasswordToState(event);
    }
    if (event is SendEmailVerification) {
      yield* _mapVerifyToState(event);
    }
    if (event is LoginGuest) {
      yield* _mapGuestToState(event);
    }
    if (event is LoginGoogle) {
      yield* _mapGoogleToState(event);
    }
    if (event is ChangeUser) {
      yield LoggedInState(event.user);
    }
  }

  /// Called every time the user info changes. You can use this method for updating a database.
  final Function(AuthUser) saveUser;

  /// Called when the user logs out. You can use this method for updating a database.
  final Function() deleteUser;

  Stream<AuthState> _mapGoogleToState(LoginGoogle event) async* {
    yield AuthLoadingState();
    final _user = await _auth.loginGoogle(
        idToken: event.idToken, accessToken: event.accessToken);
    if (_user != null) {
      if (saveUser != null) saveUser(_user);
      yield LoggedInState(_user);
    } else {
      yield LoggedOutState();
    }
  }

  Stream<AuthState> _mapGuestToState(LoginGuest event) async* {
    yield AuthLoadingState();
    final _user = await _auth.startAsGuest();
    if (_user != null) {
      if (saveUser != null) saveUser(_user);
      yield LoggedInState(_user);
    } else {
      yield LoggedOutState();
    }
  }

  Stream<AuthState> _mapCheckToState(CheckUser event) async* {
    yield AuthLoadingState();
    final _user = await _auth.currentUser();
    if (_user != null) {
      if (saveUser != null) saveUser(_user);
      yield LoggedInState(_user);
    } else {
      yield LoggedOutState();
    }
  }

  Stream<AuthState> _mapCreateToState(CreateAccount event) async* {
    yield AuthLoadingState();
    try {
      AuthUser _user = await _auth.createAccount(event.username, event.password,
          displayName: event?.displayName, photoUrl: event?.photoUrl);
      if (_user != null) {
        if (saveUser != null) saveUser(_user);
        yield LoggedInState(_user);
      } else {
        yield AuthErrorState('Error creating user!');
      }
    } catch (e) {
      yield AuthErrorState('Email already exists!');
    }
  }

  Stream<AuthState> _mapLoginToState(LoginEvent event) async* {
    yield AuthLoadingState();
    final _user = await _auth.login(event.username, event.password);
    if (_user != null) {
      if (saveUser != null) saveUser(_user);
      yield LoggedInState(_user);
    } else {
      yield AuthErrorState('Username or Password Incorrect!');
    }
  }

  Stream<AuthState> _mapLogoutToState(LogoutEvent event) async* {
    yield AuthLoadingState();
    await _auth.logout();
    if (deleteUser != null) deleteUser();
    yield LoggedOutState();
  }

  Stream<AuthState> _mapVerifyToState(SendEmailVerification event) async* {
    await _auth.sendEmailVerification();
  }

  Stream<AuthState> _mapEditInfoToState(EditInfo event) async* {
    yield AuthLoadingState();
    await _auth.editInfo(
        displayName: event?.displayName, photoUrl: event?.photoUrl);
    final _user = await _auth.currentUser();
    if (saveUser != null) saveUser(_user);
    yield LoggedInState(_user);
  }

  Stream<AuthState> _mapUpdateToState(UpdateUser event) async* {
    if (event?.user != null) {
      if (saveUser != null) saveUser(event.user);
      yield LoggedInState(event.user);
    } else {
      yield LoggedOutState();
    }
  }

  Stream<AuthState> _mapForgotPasswordToState(ForgotPassword event) async* {
    await _auth.forgotPassword(event.email);
  }

  static AuthUser currentUser(BuildContext context) {
    final auth = BlocProvider.of<AuthBloc>(context);
    final state = auth.state;
    if (state is LoggedInState) {
      return state.user;
    }
    return null;
  }
}
