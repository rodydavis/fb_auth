[![Buy Me A Coffee](https://img.shields.io/badge/Donate-Buy%20Me%20A%20Coffee-yellow.svg)](https://www.buymeacoffee.com/rodydavis)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=WSH3GVC49GNNJ)

# fb_auth

A Shared Firebase Auth Plugin for Mobile, Web and Desktop. Included AuthBloc for minimal setup! Single dynamic import and compile time ready for ios, android, macos, windows, linux and web.

## Getting Started

Setup your Bloc

```dart
final _auth = AuthBloc();
```

Follow Installation Instructions for Web: https://pub.dev/packages/firebase

Update `/web/index.html` in the body tag.

```html
<!-- The core Firebase JS SDK is always required and must be listed first -->
  <script src="https://www.gstatic.com/firebasejs/6.3.3/firebase-app.js"></script>

  <!-- TODO: Add SDKs for Firebase products that you want to use
      https://firebase.google.com/docs/web/setup#config-web-app -->
  <script src="https://www.gstatic.com/firebasejs//6.3.3/firebase-auth.js"></script>
  <script src="https://www.gstatic.com/firebasejs/6.3.3/firebase-firestore.js"></script>
  <script src="https://www.gstatic.com/firebasejs/6.3.3/firebase-storage.js"></script>
  <script src="https://www.gstatic.com/firebasejs/6.3.3/firebase-functions.js"></script>

  <script>
    // Your web app's Firebase configuration
    var firebaseConfig = {
      apiKey: "API_KEY",
      authDomain: "AUTH_DOMAIN",
      databaseURL: "DATABASE_URL",
      projectId: "PROJECT_ID",
      storageBucket: "STORAGE_BUCKET",
      messagingSenderId: "MESSAGING_SENDER_ID",
      appId: "APP_ID"
    };
    // Initialize Firebase
    firebase.initializeApp(firebaseConfig);
  </script>
```

As an alternative, you can avoid the`<script>` item with the `firebaseConfig` configuration by initializing the `FbApp` instance in your app as it is done in the plugin example `main.dart` file.

```dart
  final _app = FbApp(
      apiKey: "API_KEY",
      authDomain: "AUTH_DOMAIN",
      databaseURL: "DATABASE_URL",
      projectId: "PROJECT_ID",
      storageBucket: "STORAGE_BUCKET",
      messagingSenderId: "MESSAGING_SENDER_ID",
      appId: "APP_ID",
      measurementId: "MEASUREMENT_ID"
  );
```
If the `<script>` item is present, it takes precedence over the initialization of the `FbApp` instance in dart code.

Follow Installation Instructions for Mobile: https://pub.dev/packages/firebase_auth

- Update `ios/Runner` and add the `GoogleService-Info.plist` downloaded from firebase

- Update `android/app` and add the `google-services.json` downloaded from firebase
- Update `android/build.gradle` and update the classpath:

```gradle
    classpath 'com.google.gms:google-services:4.2.0'
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

- Guest

```dart
_auth.dispatch(LoginGuest());
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
