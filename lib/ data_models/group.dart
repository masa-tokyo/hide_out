import 'package:flutter/material.dart';

class Group {
  final String groupId;
  final String groupName;
  final String description;
  final String ownerId;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const Group({
    @required this.groupId,
    @required this.groupName,
    @required this.description,
    @required this.ownerId,
  });

  Group copyWith({
    String groupId,
    String groupName,
    String description,
    String ownerId,
  }) {
    if ((groupId == null || identical(groupId, this.groupId)) &&
        (groupName == null || identical(groupName, this.groupName)) &&
        (description == null || identical(description, this.description)) &&
        (ownerId == null || identical(ownerId, this.ownerId))) {
      return this;
    }

    return new Group(
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
    );
  }

  @override
  String toString() {
    return 'Group{groupId: $groupId, groupName: $groupName, description: $description, ownerId: $ownerId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Group &&
          runtimeType == other.runtimeType &&
          groupId == other.groupId &&
          groupName == other.groupName &&
          description == other.description &&
          ownerId == other.ownerId);

  @override
  int get hashCode =>
      groupId.hashCode ^ groupName.hashCode ^ description.hashCode ^ ownerId.hashCode;

  factory Group.fromMap(Map<String, dynamic> map) {
    return new Group(
      groupId: map['groupId'] as String,
      groupName: map['groupName'] as String,
      description: map['description'] as String,
      ownerId: map['ownerId'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'groupId': this.groupId,
      'groupName': this.groupName,
      'description': this.description,
      'ownerId': this.ownerId,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}