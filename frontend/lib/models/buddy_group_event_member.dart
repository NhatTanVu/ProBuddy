import 'dart:convert';
import 'package:intl/intl.dart';

class BuddyGroupEventMember {
  int? eventMemberId;
  DateTime? registeredDate;
  bool? isJoined;
  bool? isPaid;
  DateTime? paidDate;
  double? paidAmount;
  int? buddyGroupEvent;
  int? user;

  BuddyGroupEventMember(
      {this.eventMemberId,
      this.registeredDate,
      this.isJoined,
      this.isPaid,
      this.paidDate,
      this.paidAmount,
      this.buddyGroupEvent,
      this.user});

  static BuddyGroupEventMember fromJson(String jsonString) {
    var json = jsonDecode(jsonString);

    return BuddyGroupEventMember(
        eventMemberId: json['id'],
        registeredDate: DateTime.parse(json['registered_date']),
        isJoined: json['is_joined'],
        isPaid: json['is_paid'],
        paidDate: (json['paid_date'] == null) ? null : DateTime.parse(json['paid_date']),
        paidAmount: json['paid_amount'],
        buddyGroupEvent: json['buddy_group_event'],
        user: json['user']);
  }
}
