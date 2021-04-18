import 'package:flutter/material.dart';

class Group {
  final String groupId;
  final String groupName;
  final String description;
  final String ownerId;
  final int autoExitDays;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const Group({
    @required this.groupId,
    @required this.groupName,
    @required this.description,
    @required this.ownerId,
    @required this.autoExitDays,
  });

  Group copyWith({
    String groupId,
    String groupName,
    String description,
    String ownerId,
    int autoExitDays,
  }) {
    if ((groupId == null || identical(groupId, this.groupId)) &&
        (groupName == null || identical(groupName, this.groupName)) &&
        (description == null || identical(description, this.description)) &&
        (ownerId == null || identical(ownerId, this.ownerId)) &&
        (autoExitDays == null || identical(autoExitDays, this.autoExitDays))) {
      return this;
    }

    return new Group(
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
      autoExitDays: autoExitDays ?? this.autoExitDays,
    );
  }

  @override
  String toString() {
    return 'Group{groupId: $groupId, groupName: $groupName, description: $description, ownerId: $ownerId, autoExitDays: $autoExitDays}';
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
          autoExitDays == other.autoExitDays);

  @override
  int get hashCode =>
      groupId.hashCode ^
      groupName.hashCode ^
      description.hashCode ^
      ownerId.hashCode ^
      autoExitDays.hashCode;

  factory Group.fromMap(Map<String, dynamic> map) {
    return new Group(
      groupId: map['groupId'] as String,
      groupName: map['groupName'] as String,
      description: map['description'] as String,
      ownerId: map['ownerId'] as String,
      autoExitDays: map['autoExitDays'] as int,
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
    } as Map<String, dynamic>;
  }

//</editor-fold>

}