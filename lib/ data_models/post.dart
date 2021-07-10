

class Post {
  final String? postId;
  final String? userId;
  final String? groupId;
  final String? userName;
  final String? title;
  final String? audioUrl; //the actual place where the audio file is stored
  final String? audioStoragePath; //storageId to access to file data at Firebase Storage
  final String? audioDuration;
  final DateTime? postDateTime;
  final bool? isListened;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const Post({
    required this.postId,
    required this.userId,
    required this.groupId,
    required this.userName,
    required this.title,
    required this.audioUrl,
    required this.audioStoragePath,
    required this.audioDuration,
    required this.postDateTime,
    required this.isListened,
  });

  Post copyWith({
    String? postId,
    String? userId,
    String? groupId,
    String? userName,
    String? title,
    String? audioUrl,
    String? audioStoragePath,
    String? audioDuration,
    DateTime? postDateTime,
    bool? isListened,
  }) {
    if ((postId == null || identical(postId, this.postId)) &&
        (userId == null || identical(userId, this.userId)) &&
        (groupId == null || identical(groupId, this.groupId)) &&
        (userName == null || identical(userName, this.userName)) &&
        (title == null || identical(title, this.title)) &&
        (audioUrl == null || identical(audioUrl, this.audioUrl)) &&
        (audioStoragePath == null || identical(audioStoragePath, this.audioStoragePath)) &&
        (audioDuration == null || identical(audioDuration, this.audioDuration)) &&
        (postDateTime == null || identical(postDateTime, this.postDateTime)) &&
        (isListened == null || identical(isListened, this.isListened))) {
      return this;
    }

    return new Post(
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      groupId: groupId ?? this.groupId,
      userName: userName ?? this.userName,
      title: title ?? this.title,
      audioUrl: audioUrl ?? this.audioUrl,
      audioStoragePath: audioStoragePath ?? this.audioStoragePath,
      audioDuration: audioDuration ?? this.audioDuration,
      postDateTime: postDateTime ?? this.postDateTime,
      isListened: isListened ?? this.isListened,
    );
  }

  @override
  String toString() {
    return 'Post{postId: $postId, userId: $userId, groupId: $groupId, userName: $userName, title: $title, audioUrl: $audioUrl, audioStoragePath: $audioStoragePath, audioDuration: $audioDuration, postDateTime: $postDateTime, isListened: $isListened}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Post &&
          runtimeType == other.runtimeType &&
          postId == other.postId &&
          userId == other.userId &&
          groupId == other.groupId &&
          userName == other.userName &&
          title == other.title &&
          audioUrl == other.audioUrl &&
          audioStoragePath == other.audioStoragePath &&
          audioDuration == other.audioDuration &&
          postDateTime == other.postDateTime &&
          isListened == other.isListened);

  @override
  int get hashCode =>
      postId.hashCode ^
      userId.hashCode ^
      groupId.hashCode ^
      userName.hashCode ^
      title.hashCode ^
      audioUrl.hashCode ^
      audioStoragePath.hashCode ^
      audioDuration.hashCode ^
      postDateTime.hashCode ^
      isListened.hashCode;

  factory Post.fromMap(Map<String, dynamic> map) {
    return new Post(
      postId: map['postId'] as String?,
      userId: map['userId'] as String?,
      groupId: map['groupId'] as String?,
      userName: map['userName'] as String?,
      title: map['title'] as String?,
      audioUrl: map['audioUrl'] as String?,
      audioStoragePath: map['audioStoragePath'] as String?,
      audioDuration: map['audioDuration'] as String?,
      postDateTime: map['postDateTime'] == null
    ? null : DateTime.parse(map['postDateTime'] as String),
      isListened: map['isListened'] == null
      ? false : map['isListened'] as bool?,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'postId': this.postId,
      'userId': this.userId,
      'groupId': this.groupId,
      'userName': this.userName,
      'title': this.title,
      'audioUrl': this.audioUrl,
      'audioStoragePath': this.audioStoragePath,
      'audioDuration': this.audioDuration,
      'postDateTime': this.postDateTime!.toIso8601String(),
      'isListened': this.isListened,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}