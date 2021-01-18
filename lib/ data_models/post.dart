
import 'package:flutter/material.dart';

class Post {
  final String postId;
  final String userId;
  final String groupId;
  final String title;
  final String audioUrl;
  final String audioStoragePath;
  final String audioDuration;
  final DateTime postDateTime;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const Post({
    @required this.postId,
    @required this.userId,
    @required this.groupId,
    @required this.title,
    @required this.audioUrl,
    @required this.audioStoragePath,
    @required this.audioDuration,
    @required this.postDateTime,
  });

  Post copyWith({
    String postId,
    String userId,
    String groupId,
    String title,
    String audioUrl,
    String audioStoragePath,
    String audioDuration,
    DateTime postDateTime,
  }) {
    if ((postId == null || identical(postId, this.postId)) &&
        (userId == null || identical(userId, this.userId)) &&
        (groupId == null || identical(groupId, this.groupId)) &&
        (title == null || identical(title, this.title)) &&
        (audioUrl == null || identical(audioUrl, this.audioUrl)) &&
        (audioStoragePath == null || identical(audioStoragePath, this.audioStoragePath)) &&
        (audioDuration == null || identical(audioDuration, this.audioDuration)) &&
        (postDateTime == null || identical(postDateTime, this.postDateTime))) {
      return this;
    }

    return new Post(
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      groupId: groupId ?? this.groupId,
      title: title ?? this.title,
      audioUrl: audioUrl ?? this.audioUrl,
      audioStoragePath: audioStoragePath ?? this.audioStoragePath,
      audioDuration: audioDuration ?? this.audioDuration,
      postDateTime: postDateTime ?? this.postDateTime,
    );
  }

  @override
  String toString() {
    return 'Post{postId: $postId, userId: $userId, groupId: $groupId, title: $title, audioUrl: $audioUrl, audioStoragePath: $audioStoragePath, audioDuration: $audioDuration, postDateTime: $postDateTime}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Post &&
          runtimeType == other.runtimeType &&
          postId == other.postId &&
          userId == other.userId &&
          groupId == other.groupId &&
          title == other.title &&
          audioUrl == other.audioUrl &&
          audioStoragePath == other.audioStoragePath &&
          audioDuration == other.audioDuration &&
          postDateTime == other.postDateTime);

  @override
  int get hashCode =>
      postId.hashCode ^
      userId.hashCode ^
      groupId.hashCode ^
      title.hashCode ^
      audioUrl.hashCode ^
      audioStoragePath.hashCode ^
      audioDuration.hashCode ^
      postDateTime.hashCode;

  factory Post.fromMap(Map<String, dynamic> map) {
    return new Post(
      postId: map['postId'] as String,
      userId: map['userId'] as String,
      groupId: map['groupId'] as String,
      title: map['title'] as String,
      audioUrl: map['audioUrl'] as String,
      audioStoragePath: map['audioStoragePath'] as String,
      audioDuration: map['audioDuration'] as String,
      postDateTime: map['postDateTime'] == null
      ? null : DateTime.parse(map['postDateTime'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'postId': this.postId,
      'userId': this.userId,
      'groupId': this.groupId,
      'title': this.title,
      'audioUrl': this.audioUrl,
      'audioStoragePath': this.audioStoragePath,
      'audioDuration': this.audioDuration,
      'postDateTime': this.postDateTime.toIso8601String(),
    } as Map<String, dynamic>;
  }

//</editor-fold>

}