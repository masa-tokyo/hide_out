class Group {
  final String groupId;
  final String groupName;
  final String description;
  final String? ownerId; //nullable after the last user leaves the group
  final String? ownerPhotoUrl;
  final int autoExitDays;
  final int createdAt;
  final int lastActivityAt;
  final List<GroupMember> members;

  ///modified: fromMap and toMap

//<editor-fold desc="Data Methods">

  const Group({
    required this.groupId,
    required this.groupName,
    required this.description,
    this.ownerId,
    this.ownerPhotoUrl,
    required this.autoExitDays,
    required this.createdAt,
    required this.lastActivityAt,
    required this.members,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Group &&
          runtimeType == other.runtimeType &&
          groupId == other.groupId &&
          groupName == other.groupName &&
          description == other.description &&
          ownerId == other.ownerId &&
          ownerPhotoUrl == other.ownerPhotoUrl &&
          autoExitDays == other.autoExitDays &&
          createdAt == other.createdAt &&
          lastActivityAt == other.lastActivityAt &&
          members == other.members);

  @override
  int get hashCode =>
      groupId.hashCode ^
      groupName.hashCode ^
      description.hashCode ^
      ownerId.hashCode ^
      ownerPhotoUrl.hashCode ^
      autoExitDays.hashCode ^
      createdAt.hashCode ^
      lastActivityAt.hashCode ^
      members.hashCode;

  @override
  String toString() {
    return 'Group{' +
        ' groupId: $groupId,' +
        ' groupName: $groupName,' +
        ' description: $description,' +
        ' ownerId: $ownerId,' +
        ' ownerPhotoUrl: $ownerPhotoUrl,' +
        ' autoExitDays: $autoExitDays,' +
        ' createdAt: $createdAt,' +
        ' lastActivityAt: $lastActivityAt,' +
        ' memberNames: $members,' +
        '}';
  }

  Group copyWith({
    String? groupId,
    String? groupName,
    String? description,
    String? ownerId,
    String? ownerPhotoUrl,
    int? autoExitDays,
    int? createdAt,
    int? lastActivityAt,
    List<GroupMember>? memberNames,
  }) {
    return Group(
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
      ownerPhotoUrl: ownerPhotoUrl ?? this.ownerPhotoUrl,
      autoExitDays: autoExitDays ?? this.autoExitDays,
      createdAt: createdAt ?? this.createdAt,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      members: memberNames ?? this.members,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupId': this.groupId,
      'groupName': this.groupName,
      'description': this.description,
      'ownerId': this.ownerId,
      'ownerPhotoUrl': this.ownerPhotoUrl,
      'autoExitDays': this.autoExitDays,
      'createdAt': this.createdAt,
      'lastActivityAt': this.lastActivityAt,
      'members': this.members.map((member) {
        return {
          'userId': member.userId,
          'name': member.name,
          'photoUrl': member.photoUrl,

        };
      }).toList(),
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
        groupId: map['groupId'] as String,
        groupName: map['groupName'] as String,
        description: map['description'] as String,
        ownerId: map['ownerId'] as String?,
        ownerPhotoUrl: map['ownerPhotoUrl'] as String?,
        autoExitDays: map['autoExitDays'] as int,
        createdAt: map['createdAt'] as int,
        lastActivityAt: map['lastActivityAt'] as int,
        members: [...map['members']]
            .map((e) => GroupMember.fromMap(e))
            .toList());
  }
//</editor-fold>
}

class GroupMember {
  final String userId;
  final String name;
  final String photoUrl;

  ///not modified
//<editor-fold desc="Data Methods">

  const GroupMember({
    required this.userId,
    required this.name,
    required this.photoUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupMember &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          name == other.name &&
          photoUrl == other.photoUrl);

  @override
  int get hashCode => userId.hashCode ^ name.hashCode ^ photoUrl.hashCode;

  @override
  String toString() {
    return 'GroupMember{' +
        ' userId: $userId,' +
        ' name: $name,' +
        ' photoUrl: $photoUrl,' +
        '}';
  }

  GroupMember copyWith({
    String? userId,
    String? name,
    String? photoUrl,
  }) {
    return GroupMember(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': this.userId,
      'name': this.name,
      'photoUrl': this.photoUrl,
    };
  }

  factory GroupMember.fromMap(Map<String, dynamic> map) {
    return GroupMember(
      userId: map['userId'] as String,
      name: map['name'] as String,
      photoUrl: map['photoUrl'] as String,
    );
  }

//</editor-fold>
}
