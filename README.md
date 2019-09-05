# fb_auth

A new flutter plugin project.

## Getting Started

Setup your Bloc

```dart
final _auth = AuthBloc();
```



## Actions

- Check Current User

```dart
_auth.dispatch(CheckUser());
```

- Listen for Auth Changes

```dart
_userChanged = _fbAuth.onAuthChanged().listen((user) {
    _auth.dispatch(UpdateUser(user));
});
```

- Logout

```dart
_auth.dispatch(LogoutEvent(_user));
```

- Login

```dart
  _auth.dispatch(LoginEvent(_email, _password));
```

- Create Account

```dart
_auth.dispatch(CreateAccount(_email, _password, displayName: _name));
```

- Edit Info

```dart
_auth.dispatch(EditInfo(displayName: _name));
```

- Forgot Password

```dart
_auth.dispatch(ForgotPassword(_email));
```

- Send Email Verification

```dart
_auth.dispatch(SendEmailVerification());
```