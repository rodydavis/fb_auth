class FirebaseUser {
  FirebaseUser(this.json, this.idToken);

  @override
  final Map<String, dynamic> json;

  final String idToken;

  String get displayName => json['displayName'];

  String get email => json['email'];

  String get photoUrl => json['photoUrl'];

  String get uid => json['localId'];

  bool get registered => json['registered'] ?? false;

  List<ProviderInfo> get providerUserInfo {
    if (json['providerUserInfo'] == null) return null;
    return List.from(json['providerUserInfo']).map((i) {
      final _data = i as Map<String, dynamic>;
      return ProviderInfo(_data['providerId'], _data['federatedId']);
    }).toList();
  }

  bool get isAnonymous => email == null || email.isEmpty;

  bool get isEmailVerified => json['emailVerified'];

  String get passwordHash => json['passwordHash'];

  double get passwordUpdatedAt => json['passwordUpdatedAt'];

  DateTime get validSince => json['validSince'];

  bool get disabled => json['disabled'];

  DateTime get lastLoginAt => json['lastLoginAt'];

  DateTime get createdAt => json['createdAt'];

  bool get customAuth => json['customAuth'];
}

class ProviderInfo {
  ProviderInfo(this.providerId, this.federatedId);

  final String providerId, federatedId;
}
