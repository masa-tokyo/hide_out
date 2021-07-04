import 'package:flutter/material.dart';

class User {
  final String userId;
  final String displayName; //initial user name registered on firebase
  final String inAppUserName; //changeable user name on the app
  final String photoUrl;
  final String audioUrl; //for self-introduction
  final String audioStoragePath; //for self-introduction
  final String email;
  final int createdAt;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const User({
    @required this.userId,
    @required this.displayName,
    @required this.inAppUserName,
    @required this.photoUrl,
    @required this.audioUrl,
    @required this.audioStoragePath,
    @required this.email,
    @required this.createdAt,
  });

  User copyWith({
    String userId,
    String displayName,
    String inAppUserName,
    String photoUrl,
    String audioUrl,
    String audioStoragePath,
    String email,
    int createdAt,
  }) {
    if ((userId == null || identical(userId, this.userId)) &&
        (displayName == null || identical(displayName, this.displayName)) &&
        (inAppUserName == null ||
            identical(inAppUserName, this.inAppUserName)) &&
        (photoUrl == null || identical(photoUrl, this.photoUrl)) &&
        (audioUrl == null || identical(audioUrl, this.audioUrl)) &&
        (audioStoragePath == null ||
            identical(audioStoragePath, this.audioStoragePath)) &&
        (email == null || identical(email, this.email)) &&
        (createdAt == null || identical(createdAt, this.createdAt))) {
      return this;
    }

    return new User(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      inAppUserName: inAppUserName ?? this.inAppUserName,
      photoUrl: photoUrl ?? this.photoUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      audioStoragePath: audioStoragePath ?? this.audioStoragePath,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'User{userId: $userId, displayName: $displayName, inAppUserName: $inAppUserName, photoUrl: $photoUrl, audioUrl: $audioUrl, audioStoragePath: $audioStoragePath, email: $email, createdAt: $createdAt}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          displayName == other.displayName &&
          inAppUserName == other.inAppUserName &&
          photoUrl == other.photoUrl &&
          audioUrl == other.audioUrl &&
          audioStoragePath == other.audioStoragePath &&
          email == other.email &&
          createdAt == other.createdAt);

  @override
  int get hashCode =>
      userId.hashCode ^
      displayName.hashCode ^
      inAppUserName.hashCode ^
      photoUrl.hashCode ^
      audioUrl.hashCode ^
      audioStoragePath.hashCode ^
      email.hashCode ^
      createdAt.hashCode;

  factory User.fromMap(Map<String, dynamic> map) {
    return new User(
      userId: map['userId'] as String,
      displayName: map['displayName'] as String,
      inAppUserName: map['inAppUserName'] as String,
      photoUrl: map['photoUrl'] as String,
      audioUrl: map['audioUrl'] as String,
      audioStoragePath: map['audioStoragePath'] as String,
      email: map['email'] as String,
      createdAt: map['createdAt'] == null
          ? null : map['createdAt'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'userId': this.userId,
      'displayName': this.displayName,
      'inAppUserName': this.inAppUserName,
      'photoUrl': this.photoUrl,
      'audioUrl': this.audioUrl,
      'audioStoragePath': this.audioStoragePath,
      'email': this.email,
      'createdAt': this.createdAt,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
