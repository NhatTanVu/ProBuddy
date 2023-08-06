import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/buddy_group.dart';
import '../models/buddy_group_event.dart';
import '../models/buddy_group_event_member.dart';
import 'config.dart';

class BuddyServices {
  static const String baseUrl = Config.apiEndpoint;

  static Future<void> createGroup(String name, String description, int userId,
      File? image, String jwtToken) async {
    final createUrl = Uri.parse("$baseUrl/buddy/group/create");
    var request = http.MultipartRequest('POST', createUrl);
    request.headers['Authorization'] =
        'Bearer $jwtToken'; // Add JWT token header
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }
    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['user'] = userId.toString();

    final response = await request.send();
    if (response.statusCode == 201) {
      try {
        return;
      } catch (e) {
        throw Exception('Error when processing request');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized access');
    } else {
      throw Exception('Create group failed');
    }
  }

  static Future<void> joinGroup(
      int userId, int groupId, String jwtToken) async {
    final joinUrl = Uri.parse("$baseUrl/buddy/group/join");
    http.Response response = await http.post(
      joinUrl,
      body: jsonEncode({"buddy_group": groupId, "user": userId}),
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
      throw Exception('Join group failed');
    }
  }

  static Future<void> leaveGroup(
      int userId, int groupId, String jwtToken) async {
    final leaveUrl = Uri.parse("$baseUrl/buddy/group/leave");
    http.Response response = await http.delete(
      leaveUrl,
      body: jsonEncode({"buddy_group": groupId, "user": userId}),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      try {
        return;
      } catch (e) {
        throw Exception('Error when processing request');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized access');
    } else {
      throw Exception('Leave group failed');
    }
  }

  static Future<void> deleteGroup(int groupId, String jwtToken) async {
    final deleteUrl = Uri.parse("$baseUrl/buddy/group/delete/$groupId");
    http.Response response = await http.delete(
      deleteUrl,
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 204) {
      try {
        return;
      } catch (e) {
        throw Exception('Error when processing request');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized access');
    } else {
      throw Exception('Delete group failed');
    }
  }

  static Future<void> createGroupEvent(
      BuddyGroupEvent buddyGroupEvent, String jwtToken) async {
    final createUrl = Uri.parse("$baseUrl/buddy/group/event/create");
    var request = http.MultipartRequest('POST', createUrl);
    request.headers['Authorization'] =
        'Bearer $jwtToken'; // Add JWT token header
    if (buddyGroupEvent.imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'image', buddyGroupEvent.imageFile!.path));
    }
    request.fields['name'] = buddyGroupEvent.name ?? "";
    request.fields['description'] = buddyGroupEvent.description ?? "";
    request.fields['created_by'] = buddyGroupEvent.createdBy.toString();
    request.fields['location'] = buddyGroupEvent.location ?? "";
    request.fields['start_date'] =
        DateFormat('yyyy-MM-dd').format(buddyGroupEvent.startDate!);
    request.fields['buddy_group'] = buddyGroupEvent.buddyGroup.toString();

    final response = await request.send();
    if (response.statusCode == 201) {
      try {
        return;
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
    final registerUrl = Uri.parse("$baseUrl/buddy/group/event/register");
    http.Response response = await http.post(
      registerUrl,
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

  static Future<void> unregisterGroupEvent(
      int userId, int eventId, String jwtToken) async {
    final unregisterUrl = Uri.parse("$baseUrl/buddy/group/event/unregister");
    http.Response response = await http.delete(
      unregisterUrl,
      body: jsonEncode({"buddy_group_event": eventId, "user": userId}),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      try {
        return;
      } catch (e) {
        throw Exception('Error when processing request');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized access');
    } else {
      throw Exception('Unregister event failed');
    }
  }

  static Future<void> deleteGroupEvent(int eventId, String jwtToken) async {
    final deleteUrl = Uri.parse("$baseUrl/buddy/group/event/delete/$eventId");
    http.Response response = await http.delete(
      deleteUrl,
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 204) {
      try {
        return;
      } catch (e) {
        throw Exception('Error when processing request');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized access');
    } else {
      throw Exception('Delete event failed');
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
