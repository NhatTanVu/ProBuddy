import 'dart:convert';
import 'dart:io';

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
  String? image;
  File? imageFile;

  BuddyGroupEvent(
      {this.eventId,
      required this.name,
      required this.description,
      required this.startDate,
      required this.location,
      this.image,
      this.imageFile,
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
        image = null,
        imageFile = null,
        endDate = null,
        createdBy = null,
        buddyGroup = null,
        isFinished = null;

  static BuddyGroupEvent fromJson(String jsonString) {
    var json = jsonDecode(jsonString);

    return BuddyGroupEvent(
        eventId: json['id'],
        name: json['name'],
        description: json['description'],
        startDate: DateTime.parse(json['start_date']),
        location: json['location'],
        image: json['image'],
        createdBy: json['created_by'],
        buddyGroup: json['buddy_group'],
        isFinished: json['is_finished']);
  }
}
