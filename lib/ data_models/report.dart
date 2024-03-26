class Report {
  final String reportId;
  final String postId;
  final String postOwnerId;
  final String reporterId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isResolved; //for self-introduction
  final String? notificationId;

//<editor-fold desc="Data Methods">
  const Report({
    required this.reportId,
    required this.postId,
    required this.postOwnerId,
    required this.reporterId,
    required this.createdAt,
    required this.updatedAt,
    required this.isResolved,
    this.notificationId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Report &&
          runtimeType == other.runtimeType &&
          reportId == other.reportId &&
          postId == other.postId &&
          postOwnerId == other.postOwnerId &&
          reporterId == other.reporterId &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          isResolved == other.isResolved &&
          notificationId == other.notificationId);

  @override
  int get hashCode =>
      reportId.hashCode ^
      postId.hashCode ^
      postOwnerId.hashCode ^
      reporterId.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      isResolved.hashCode ^
      notificationId.hashCode;

  @override
  String toString() {
    return 'Report{' +
        ' reportId: $reportId,' +
        ' postId: $postId,' +
        ' postOwnerId: $postOwnerId,' +
        ' reporterId: $reporterId,' +
        ' createdAt: $createdAt,' +
        ' updatedAt: $updatedAt,' +
        ' isResolved: $isResolved,' +
        ' notificationId: $notificationId,' +
        '}';
  }

  Report copyWith({
    String? reportId,
    String? postId,
    String? postOwnerId,
    String? reporterId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isResolved,
    String? notificationId,
  }) {
    return Report(
      reportId: reportId ?? this.reportId,
      postId: postId ?? this.postId,
      postOwnerId: postOwnerId ?? this.postOwnerId,
      reporterId: reporterId ?? this.reporterId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isResolved: isResolved ?? this.isResolved,
      notificationId: notificationId ?? this.notificationId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reportId': this.reportId,
      'postId': this.postId,
      'postOwnerId': this.postOwnerId,
      'reporterId': this.reporterId,
      'createdAt': this.createdAt,
      'updatedAt': this.updatedAt,
      'isResolved': this.isResolved,
      'notificationId': this.notificationId,
    };
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      reportId: map['reportId'] as String,
      postId: map['postId'] as String,
      postOwnerId: map['postOwnerId'] as String,
      reporterId: map['reporterId'] as String,
      createdAt: map['createdAt'] as DateTime,
      updatedAt: map['updatedAt'] as DateTime,
      isResolved: map['isResolved'] as bool,
      notificationId: map['notificationId'] as String,
    );
  }

//</editor-fold>
}
