import 'dart:convert';
import 'package:intl/intl.dart';

class BuddyGroupEvent {
  int? eventId;
  String? name;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  String? location;
  int? createdBy;
  int? buddyGroup;
  bool? isFinished;

  BuddyGroupEvent(
      {this.eventId,
      required this.name,
      required this.description,
      required this.startDate,
      required this.location,
      this.endDate,
      this.createdBy,
      this.buddyGroup,
      this.isFinished});

  BuddyGroupEvent.fromEmpty()
      : eventId = null,
        name = "",
        description = "",
        startDate = null,
        location = "",
        endDate = null,
        createdBy = null,
        buddyGroup = null,
        isFinished = null;

  String toJson() {
    Map<String, Object?> obj = {
      'name': name,
      'description': description,
      'start_date': DateFormat('yyyy-MM-dd').format(startDate!),
      'location': location,
      'created_by': createdBy,
      'buddy_group': buddyGroup
    };
    return jsonEncode(obj);
  }

  static BuddyGroupEvent fromJson(String jsonString) {
    var json = jsonDecode(jsonString);

    return BuddyGroupEvent(
        eventId: json['id'],
        name: json['name'],
        description: json['description'],
        startDate: DateTime.parse(json['start_date']),
        location: json['location'],
        createdBy: json['created_by'],
        buddyGroup: json['buddy_group'],
        isFinished: json['is_finished']);
  }
}
