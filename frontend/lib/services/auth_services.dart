import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_user.dart';
import 'config.dart';

class AuthServices {
  static const String baseUrl = Config.apiEndpoint;

  static Future<AuthUser> login(String username, String password) async {
    final loginUrl = Uri.parse("$baseUrl/user/login");

    http.Response response = await http
        .post(loginUrl, body: {'username': username, 'password': password});

    if (response.statusCode == 200) {
      try {
        AuthUser authUser = AuthUser.fromJson(response.body);
        await saveUser(authUser);
        return authUser;
      } catch (e) {
        throw Exception('Error when processing request');
      }
    } else {
      throw Exception('Login failed');
    }
  }

  static Future<bool> signUp(AuthUser signupUser) async {
    final signUpUrl = Uri.parse('$baseUrl/user/signup');
    final response = await http.post(
      signUpUrl,
      body: signupUser.toJson(),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Sign up failed');
    }
  }

  static Future<void> saveUser(AuthUser authUser) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('auth_user', authUser.toJson());
  }

  static Future<AuthUser> loadUser() async {
    final preferences = await SharedPreferences.getInstance();
    String strAuthUser = preferences.getString('auth_user') ?? "";
    return AuthUser.fromJson(strAuthUser);
  }
}
