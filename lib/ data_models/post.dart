class Post {
  final String? postId;
  final String? userId;
  final String? groupId;
  final String? userName;
  final String? title;
  final String? audioUrl; //the actual place where the audio file is stored
  final String?
      audioStoragePath; //storageId to access to file data at Firebase Storage
  final String? audioDuration;
  final DateTime? postDateTime;
  final bool? isListened;
  final List<String> excludedUserIds;

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
    required this.excludedUserIds,
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
    List<String>? excludedUserIds,
  }) {
    return Post(
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
      excludedUserIds: excludedUserIds ?? this.excludedUserIds,
    );
  }

  @override
  String toString() {
    return 'Post{' +
        ' postId: $postId,' +
        ' userId: $userId,' +
        ' groupId: $groupId,' +
        ' userName: $userName,' +
        ' title: $title,' +
        ' audioUrl: $audioUrl,' +
        ' audioStoragePath: $audioStoragePath,' +
        ' audioDuration: $audioDuration,' +
        ' postDateTime: $postDateTime,' +
        ' isListened: $isListened,' +
        ' removedUserIds: $excludedUserIds,' +
        '}';
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
          isListened == other.isListened &&
          excludedUserIds == other.excludedUserIds);

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
      isListened.hashCode ^
      excludedUserIds.hashCode;

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
      // String(UTC) to DateTime(local)
      postDateTime: map['postDateTime'] == null
          ? null
          : DateTime.parse(map['postDateTime'] as String).toLocal(),
      isListened: map['isListened'] == null
          ? false
          : map['isListened'] as bool? ?? false,
      excludedUserIds: map['removedUserIds'] as List<String>? ?? [],
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
      'removedUserIds': this.excludedUserIds,
    } as Map<String, dynamic>;
  }

//</editor-fold>
}
