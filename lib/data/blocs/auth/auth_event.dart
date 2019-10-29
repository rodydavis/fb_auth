import 'package:meta/meta.dart';

import '../../classes/index.dart';

@immutable
abstract class AuthEvent {}

class CheckUser extends AuthEvent {}

class LoginEvent extends AuthEvent {
  LoginEvent(this.username, this.password);

  final String username, password;
}

class LoginGuest extends AuthEvent {}

class CreateAccount extends AuthEvent {
  CreateAccount(this.username, this.password,
      {this.displayName, this.photoUrl});

  final String username, password;
  final String displayName, photoUrl;
}

class ChangeUser extends AuthEvent {
  ChangeUser(this.user);

  final AuthUser user;
}

class LogoutEvent extends AuthEvent {
  LogoutEvent(this.user);

  final AuthUser user;
}

class UpdateUser extends AuthEvent {
  UpdateUser(this.user);

  final AuthUser user;
}

class ForgotPassword extends AuthEvent {
  ForgotPassword(this.email);

  final String email;
}

class LoginGoogle extends AuthEvent {
  LoginGoogle({
    this.accessToken,
    this.idToken,
  });

  final String idToken;
  final String accessToken;
}

class SendEmailVerification extends AuthEvent {}

class EditInfo extends AuthEvent {
  EditInfo(this.user, {this.displayName, this.photoUrl});

  final String displayName, photoUrl;
  final AuthUser user;
}
