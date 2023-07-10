import 'package:http/http.dart' as http;
import '../models/buddy_group.dart';
import 'config.dart';

class BuddyServices {
  static const String baseUrl = Config.apiEndpoint;

  static Future<BuddyGroup> createGroup(
      String name, String description, int userId, String jwtToken) async {
    final createUrl = Uri.parse("$baseUrl/buddy/create_buddy_group");
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
    } else {
      throw Exception('Create group failed');
    }
  }
}
