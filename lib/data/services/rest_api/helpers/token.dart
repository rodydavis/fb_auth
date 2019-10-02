class FirestoreJsonAccessToken {
  FirestoreJsonAccessToken(this.json, this.createdAt);

  final Map<String, dynamic> json;

  String get refreshToken => json["refresh_token"];

  final DateTime createdAt;

  DateTime get expiresAt =>
      createdAt.add(new Duration(seconds: expiresInSeconds));

  String get displayName => json['displayName'] as String;

  String get email => json['email'] as String;

  String get kind => json['kind'] as String;

  String get idToken => json['idToken'];

  String get localId => json['localId'] as String;

  int get expiresInSeconds => int.tryParse(json["expiresIn"]);

  bool get emailVerified => json['emailVerified'];
}
