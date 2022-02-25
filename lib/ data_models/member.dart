class Member {
  final DateTime createdAt;
  final bool? isAlerted;
  final DateTime lastPostDateTime;
  final int timeZoneOffsetInMinutes;
  final String userId;
  final String name;
  final String photoUrl;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const Member({
    required this.createdAt,
    required this.isAlerted,
    required this.lastPostDateTime,
    required this.timeZoneOffsetInMinutes,
    required this.userId,
    required this.name,
    required this.photoUrl,
  });

  Member copyWith({
    DateTime? createdAt,
    bool? isAlerted,
    DateTime? lastPostDateTime,
    int? timeZoneOffsetInMinutes,
    String? userId,
    String? name,
    String? photoUrl,
  }) {
    if ((createdAt == null || identical(createdAt, this.createdAt)) &&
        (isAlerted == null || identical(isAlerted, this.isAlerted)) &&
        (lastPostDateTime == null ||
            identical(lastPostDateTime, this.lastPostDateTime)) &&
        (timeZoneOffsetInMinutes == null ||
            identical(timeZoneOffsetInMinutes, this.timeZoneOffsetInMinutes)) &&
        (userId == null || identical(userId, this.userId)) &&
        (name == null || identical(name, this.name)) &&
        (photoUrl == null || identical(photoUrl, this.photoUrl))) {
      return this;
    }

    return new Member(
      createdAt: createdAt ?? this.createdAt,
      isAlerted: isAlerted ?? this.isAlerted,
      lastPostDateTime: lastPostDateTime ?? this.lastPostDateTime,
      timeZoneOffsetInMinutes:
          timeZoneOffsetInMinutes ?? this.timeZoneOffsetInMinutes,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  String toString() {
    return 'Member{createdAt: $createdAt, isAlerted: $isAlerted, lastPostDateTime: $lastPostDateTime, timeZoneOffsetInMinutes: $timeZoneOffsetInMinutes, userId: $userId, name: $name, photoUrl: $photoUrl}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Member &&
          runtimeType == other.runtimeType &&
          createdAt == other.createdAt &&
          isAlerted == other.isAlerted &&
          lastPostDateTime == other.lastPostDateTime &&
          timeZoneOffsetInMinutes == other.timeZoneOffsetInMinutes &&
          userId == other.userId &&
          name == other.name &&
          photoUrl == other.photoUrl);

  @override
  int get hashCode =>
      createdAt.hashCode ^
      isAlerted.hashCode ^
      lastPostDateTime.hashCode ^
      timeZoneOffsetInMinutes.hashCode ^
      userId.hashCode ^
      name.hashCode ^
      photoUrl.hashCode;

  factory Member.fromMap(Map<String, dynamic> map) {
    return new Member(
      createdAt: map['createdAt'] as DateTime,
      isAlerted: map['isAlerted'] as bool?,
      lastPostDateTime: map['lastPostDateTime'] as DateTime,
      timeZoneOffsetInMinutes: map['timeZoneOffsetInMinutes'] as int,
      userId: map['userId'] as String,
      name: map['name'] as String,
      photoUrl: map['photoUrl'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'createdAt': this.createdAt.millisecondsSinceEpoch,
      'isAlerted': this.isAlerted,
      'lastPostDateTime': this.lastPostDateTime.toIso8601String(),
      'timeZoneOffsetInMinutes': this.timeZoneOffsetInMinutes,
      'userId': this.userId,
      'name': this.name,
      'photoUrl': this.photoUrl,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
