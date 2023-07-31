import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/buddy_group.dart';
import '../models/buddy_group_event.dart';
import '../models/buddy_group_event_member.dart';
import 'config.dart';

class BuddyServices {
  static const String baseUrl = Config.apiEndpoint;

  static Future<BuddyGroup> createGroup(
      String name, String description, int userId, String jwtToken) async {
    final createUrl = Uri.parse("$baseUrl/buddy/group/create");
    http.Response response = await http.post(
      createUrl,
      body: {
        'name': name,
        'description': description,
        'user': userId.toString(),
      },
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 201) {
      try {
        BuddyGroup group = BuddyGroup.fromJson(response.body);
        return group;
      } catch (e) {
        throw Exception('Error when processing request');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized access');
    } else {
      throw Exception('Create group failed');
    }
  }

  static Future<BuddyGroupEvent> createGroupEvent(
      BuddyGroupEvent buddyGroupEvent, String jwtToken) async {
    final createUrl = Uri.parse("$baseUrl/buddy/group/event/create");
    http.Response response = await http.post(
      createUrl,
      body: buddyGroupEvent.toJson(),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      try {
        BuddyGroupEvent groupEvent = BuddyGroupEvent.fromJson(response.body);
        return groupEvent;
      } catch (e) {
        throw Exception('Error when processing request');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized access');
    } else {
      throw Exception('Create event failed');
    }
  }

  static Future<void> registerGroupEvent(
      int userId, int eventId, String jwtToken) async {
    final createUrl = Uri.parse("$baseUrl/buddy/group/event/register");
    http.Response response = await http.post(
      createUrl,
      body: jsonEncode({"buddy_group_event": eventId, "user": userId}),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      try {
        return;
      } catch (e) {
        throw Exception('Error when processing request');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized access');
    } else {
      throw Exception('Register event failed');
    }
  }

  static Future<List<BuddyGroup>> viewCreatedGroupsByUserId(
      int userId, String jwtToken) async {
    final viewUrl = Uri.parse("$baseUrl/buddy/groups/view/created/$userId");
    http.Response response = await http.get(
      viewUrl,
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      try {
        List<BuddyGroup> result = (jsonDecode(response.body) as List)
            .map((json) => BuddyGroup.fromJson(jsonEncode(json)))
            .toList();
        return result;
      } catch (e) {
        throw Exception('Error when processing request');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized access');
    } else {
      throw Exception('View created groups failed');
    }
  }

  static Future<List<BuddyGroup>> viewJoinedGroupsByUserId(
      int userId, String jwtToken) async {
    final viewUrl = Uri.parse("$baseUrl/buddy/groups/view/joined/$userId");
    http.Response response = await http.get(
      viewUrl,
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      try {
        List<BuddyGroup> result = (jsonDecode(response.body) as List)
            .map((json) => BuddyGroup.fromJson(jsonEncode(json)))
            .toList();
        return result;
      } catch (e) {
        throw Exception('Error when processing request');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized access');
    } else {
      throw Exception('View joined groups failed');
    }
  }

  static Future<BuddyGroup> viewGroupById(int groupId, String jwtToken) async {
    final viewUrl = Uri.parse("$baseUrl/buddy/group/$groupId");
    http.Response response = await http.get(
      viewUrl,
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      try {
        BuddyGroup result = BuddyGroup.fromJson(response.body);
        return result;
      } catch (e) {
        throw Exception('Error when processing request');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized access');
    } else {
      throw Exception('View group by id failed');
    }
  }

  static Future<List<BuddyGroupEventMember>> viewGroupEventMembersByEventId(
      int eventId, String jwtToken) async {
    final viewUrl = Uri.parse("$baseUrl/buddy/group/event/$eventId/members");
    http.Response response = await http.get(
      viewUrl,
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      try {
        List<BuddyGroupEventMember> result = (jsonDecode(response.body) as List)
            .map((json) => BuddyGroupEventMember.fromJson(jsonEncode(json)))
            .toList();
        return result;
      } catch (e) {
        throw Exception('Error when processing request');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized access');
    } else {
      throw Exception('View event members failed');
    }
  }

  static Future<List<BuddyGroupEvent>> viewJoinedGroupEventsByUserId(
      int userId, String jwtToken) async {
    final viewUrl =
        Uri.parse("$baseUrl/buddy/group/events/view/joined/$userId");
    http.Response response = await http.get(
      viewUrl,
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      try {
        List<BuddyGroupEvent> result = (jsonDecode(response.body) as List)
            .map((json) => BuddyGroupEvent.fromJson(jsonEncode(json)))
            .toList();
        return result;
      } catch (e) {
        throw Exception('Error when processing request');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized access');
    } else {
      throw Exception('View joined events failed');
    }
  }

  static Future<List<BuddyGroup>> viewAllGroups(String jwtToken) async {
    final viewUrl = Uri.parse("$baseUrl/buddy/groups");
    http.Response response = await http.get(
      viewUrl,
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      try {
        List<BuddyGroup> result = (jsonDecode(response.body) as List)
            .map((json) => BuddyGroup.fromJson(jsonEncode(json)))
            .toList();
        return result;
      } catch (e) {
        throw Exception('Error when processing request');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized access');
    } else {
      throw Exception('View all groups failed');
    }
  }
}
