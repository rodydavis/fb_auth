class FirestoreJsonAccessToken {

  FirestoreJsonAccessToken(this.json);

  final Map<String, dynamic> json;

  String get refreshToken => json['refresh_token'] ?? json['refreshToken'] ;

  String get createdDate => json['createdAt'] as String;
  DateTime get createdAt => DateTime.parse(createdDate);

  DateTime get expiresAt =>
      createdAt.add(new Duration(seconds: expiresInSeconds));

  String get displayName => json['displayName'] as String;

  String get email => json['email'] as String;

  String get kind => json['kind'] as String;

  String get idToken => json['idToken'] ?? json['id_token'];

  String get localId => json['localId'] ?? json['user_id'] as String;

  int get expiresInSeconds => int.tryParse(json["expiresIn"]);

  bool get emailVerified => json['emailVerified'];

  bool isExpired() {
    bool expired = false;

    if (createdAt != null) {
      DateTime now = DateTime.now();
      expired = createdAt.difference(now).inSeconds < 0;
    }

    return expired;
  }
}
