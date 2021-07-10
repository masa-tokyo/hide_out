
class Group {
  final String? groupId;
  final String? groupName;
  final String? description;
  final String? ownerId;
  final int? autoExitDays;
  final int? createdAt;
  final int? lastActivityAt;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const Group({
    required this.groupId,
    required this.groupName,
    required this.description,
    required this.ownerId,
    required this.autoExitDays,
    required this.createdAt,
    required this.lastActivityAt,
  });

  Group copyWith({
    String? groupId,
    String? groupName,
    String? description,
    String? ownerId,
    int? autoExitDays,
    int? createdAt,
    int? lastActivityAt,
  }) {
    if ((groupId == null || identical(groupId, this.groupId)) &&
        (groupName == null || identical(groupName, this.groupName)) &&
        (description == null || identical(description, this.description)) &&
        (ownerId == null || identical(ownerId, this.ownerId)) &&
        (autoExitDays == null || identical(autoExitDays, this.autoExitDays)) &&
        (createdAt == null || identical(createdAt, this.createdAt)) &&
        (lastActivityAt == null ||
            identical(lastActivityAt, this.lastActivityAt))) {
      return this;
    }

    return new Group(
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
      autoExitDays: autoExitDays ?? this.autoExitDays,
      createdAt: createdAt ?? this.createdAt,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
    );
  }

  @override
  String toString() {
    return 'Group{groupId: $groupId, groupName: $groupName, description: $description, ownerId: $ownerId, autoExitDays: $autoExitDays, createdAt: $createdAt, lastActivityAt: $lastActivityAt}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Group &&
          runtimeType == other.runtimeType &&
          groupId == other.groupId &&
          groupName == other.groupName &&
          description == other.description &&
          ownerId == other.ownerId &&
          autoExitDays == other.autoExitDays &&
          createdAt == other.createdAt &&
          lastActivityAt == other.lastActivityAt);

  @override
  int get hashCode =>
      groupId.hashCode ^
      groupName.hashCode ^
      description.hashCode ^
      ownerId.hashCode ^
      autoExitDays.hashCode ^
      createdAt.hashCode ^
      lastActivityAt.hashCode;

  factory Group.fromMap(Map<String, dynamic> map) {
    return new Group(
      groupId: map['groupId'] as String?,
      groupName: map['groupName'] as String?,
      description: map['description'] as String?,
      ownerId: map['ownerId'] as String?,
      autoExitDays: map['autoExitDays'] as int?,
      createdAt: map['createdAt'] ==null
          ? null: map['createdAt'] as int?,
      lastActivityAt: map['lastActivityAt'] ==null
          ? null : map['lastActivityAt'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'groupId': this.groupId,
      'groupName': this.groupName,
      'description': this.description,
      'ownerId': this.ownerId,
      'autoExitDays': this.autoExitDays,
      'createdAt': this.createdAt,
      'lastActivityAt': this.lastActivityAt,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}