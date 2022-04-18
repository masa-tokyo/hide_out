class Member {
  final int createdAt;
  final bool isAlerted;
  final DateTime lastPostDateTime;
  final int timeZoneOffsetInMinutes;
  final String userId;
  final String name;
  final String photoUrl;
  final String? audioUrl;

  /// Modified:
  ///   - DateTime is parsed
  ///   - fromMap "map['audioUrl'] as String?"
//<editor-fold desc="Data Methods">

  const Member({
    required this.createdAt,
    required this.isAlerted,
    required this.lastPostDateTime,
    required this.timeZoneOffsetInMinutes,
    required this.userId,
    required this.name,
    required this.photoUrl,
    this.audioUrl,
  });

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
          photoUrl == other.photoUrl &&
          audioUrl == other.audioUrl);

  @override
  int get hashCode =>
      createdAt.hashCode ^
      isAlerted.hashCode ^
      lastPostDateTime.hashCode ^
      timeZoneOffsetInMinutes.hashCode ^
      userId.hashCode ^
      name.hashCode ^
      photoUrl.hashCode ^
      audioUrl.hashCode;

  @override
  String toString() {
    return 'Member{' +
        ' createdAt: $createdAt,' +
        ' isAlerted: $isAlerted,' +
        ' lastPostDateTime: $lastPostDateTime,' +
        ' timeZoneOffsetInMinutes: $timeZoneOffsetInMinutes,' +
        ' userId: $userId,' +
        ' name: $name,' +
        ' photoUrl: $photoUrl,' +
        ' audioUrl: $audioUrl,' +
        '}';
  }

  Member copyWith({
    int? createdAt,
    bool? isAlerted,
    DateTime? lastPostDateTime,
    int? timeZoneOffsetInMinutes,
    String? userId,
    String? name,
    String? photoUrl,
    String? audioUrl,
  }) {
    return Member(
      createdAt: createdAt ?? this.createdAt,
      isAlerted: isAlerted ?? this.isAlerted,
      lastPostDateTime: lastPostDateTime ?? this.lastPostDateTime,
      timeZoneOffsetInMinutes:
          timeZoneOffsetInMinutes ?? this.timeZoneOffsetInMinutes,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      audioUrl: audioUrl ?? this.audioUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdAt': this.createdAt,
      'isAlerted': this.isAlerted,
      'lastPostDateTime': this.lastPostDateTime.toIso8601String(),
      'timeZoneOffsetInMinutes': this.timeZoneOffsetInMinutes,
      'userId': this.userId,
      'name': this.name,
      'photoUrl': this.photoUrl,
      'audioUrl': this.audioUrl,
    };
  }

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      createdAt: map['createdAt'] as int,
      isAlerted: map['isAlerted'] as bool,
      lastPostDateTime: DateTime.parse(map['lastPostDateTime'] as String),
      timeZoneOffsetInMinutes: map['timeZoneOffsetInMinutes'] as int,
      userId: map['userId'] as String,
      name: map['name'] as String,
      photoUrl: map['photoUrl'] as String,
      audioUrl: map['audioUrl'] as String?,
    );
  }

//</editor-fold>
}
