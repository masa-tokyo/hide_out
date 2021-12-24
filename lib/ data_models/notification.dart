import 'package:collection/collection.dart' show IterableExtension;
import 'package:hide_out/utils/constants.dart';

class Notification {
  final NotificationType? notificationType;
  final int? createdAt;
  final String? notificationId;
  final String? userId; //user who gets notification
  final String? postId;
  final String? groupId;
  final String? content;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const Notification({
    required this.notificationType,
    required this.createdAt,
    required this.notificationId,
    required this.userId,
    required this.postId,
    required this.groupId,
    required this.content,
  });

  Notification copyWith({
    NotificationType? notificationType,
    int? createdAt,
    String? notificationId,
    String? userId,
    String? postId,
    String? groupId,
    String? content,
  }) {
    if ((notificationType == null ||
            identical(notificationType, this.notificationType)) &&
        (createdAt == null || identical(createdAt, this.createdAt)) &&
        (notificationId == null ||
            identical(notificationId, this.notificationId)) &&
        (userId == null || identical(userId, this.userId)) &&
        (postId == null || identical(postId, this.postId)) &&
        (groupId == null || identical(groupId, this.groupId)) &&
        (content == null || identical(content, this.content))) {
      return this;
    }

    return new Notification(
      notificationType: notificationType ?? this.notificationType,
      createdAt: createdAt ?? this.createdAt,
      notificationId: notificationId ?? this.notificationId,
      userId: userId ?? this.userId,
      postId: postId ?? this.postId,
      groupId: groupId ?? this.groupId,
      content: content ?? this.content,
    );
  }

  @override
  String toString() {
    return 'Notification{notificationType: $notificationType, createdAt: $createdAt, notificationId: $notificationId, userId: $userId, postId: $postId, groupId: $groupId, content: $content}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Notification &&
          runtimeType == other.runtimeType &&
          notificationType == other.notificationType &&
          createdAt == other.createdAt &&
          notificationId == other.notificationId &&
          userId == other.userId &&
          postId == other.postId &&
          groupId == other.groupId &&
          content == other.content);

  @override
  int get hashCode =>
      notificationType.hashCode ^
      createdAt.hashCode ^
      notificationId.hashCode ^
      userId.hashCode ^
      postId.hashCode ^
      groupId.hashCode ^
      content.hashCode;

  factory Notification.fromMap(Map<String, dynamic> map) {
    return new Notification(
      notificationType: NotificationType.values.firstWhereOrNull((element) =>
          element.toString() ==
          "NotificationType.${map['notificationType']}"),
      createdAt: map['createdAt'] as int?,
      notificationId: map['notificationId'] as String?,
      userId: map['userId'] as String?,
      postId: map['postId'] as String?,
      groupId: map['groupId'] as String?,
      content: map['content'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'notificationType': this.notificationType.toString().substring(17),
      'createdAt': this.createdAt,
      'notificationId': this.notificationId,
      'userId': this.userId,
      'postId': this.postId,
      'groupId': this.groupId,
      'content': this.content,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
