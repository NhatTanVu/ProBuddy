import 'dart:convert';

class BuddyGroup {
  int? groupId;
  String? name;
  String? description;

  BuddyGroup(
      {
        required this.groupId,
        required this.name,
        required this.description,
      });

  static BuddyGroup fromJson(String jsonString) {
    var json = jsonDecode(jsonString);

    return BuddyGroup(
      groupId: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}