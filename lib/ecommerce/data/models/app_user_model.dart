class AppUserModel {
  final String uid;
  final String displayName;
  final String email;
  final String? photoUrl;

  const AppUserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    this.photoUrl,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'displayName': displayName,
        'email': email,
        'photoUrl': photoUrl,
      };

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      uid: json['uid'] as String? ?? '',
      displayName: json['displayName'] as String? ?? 'User',
      email: json['email'] as String? ?? '',
      photoUrl: json['photoUrl'] as String?,
    );
  }
}
