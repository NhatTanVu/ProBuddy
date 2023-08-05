import 'dart:convert';

import 'auth_user.dart';
import 'buddy_group_event.dart';

class BuddyGroup {
  int? groupId;
  String? name;
  String? description;
  List<BuddyGroupEvent> events;
  AuthUser createdBy;
  List<int> memberIds;
  String? image;

  BuddyGroup(
      {required this.groupId,
      required this.name,
      required this.description,
      required this.image,
      required this.events,
      required this.createdBy,
      required this.memberIds});

  static BuddyGroup fromJson(String jsonString) {
    var json = jsonDecode(jsonString);

    return BuddyGroup(
        groupId: json['id'],
        name: json['name'],
        description: json['description'],
        image: json['image'],
        events: (json['events'] == null)
            ? []
            : ((json['events'] as List)
                .map((eventJson) =>
                    BuddyGroupEvent.fromJson(jsonEncode(eventJson)))
                .toList()),
        createdBy: AuthUser.fromJson(jsonEncode(json['user'])),
        memberIds: (json['members'] == null)
            ? []
            : ((json['members'] as List)
                .map((eventJson) => eventJson["user"] as int)
                .toList()));
  }
}
