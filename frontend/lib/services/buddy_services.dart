import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/buddy_group.dart';
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

  static Future<List<BuddyGroup>> viewGroupsByUserId(
      int userId, String jwtToken) async {
    final viewUrl = Uri.parse("$baseUrl/buddy/groups/view/$userId");
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
    }
    else {
      throw Exception('View groups failed');
    }
  }
}
