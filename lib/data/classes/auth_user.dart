import 'package:flutter/widgets.dart';

class AuthUser {
  final String uid;
  final String displayName;
  final String email;

  AuthUser({
    @required this.uid,
    @required this.displayName,
    @required this.email,
    @required this.isEmailVerified,
    @required this.isAnonymous,
  });
  final bool isEmailVerified;
  final bool isAnonymous;

  @override
  String toString() {
    return '$displayName';
  }
}
