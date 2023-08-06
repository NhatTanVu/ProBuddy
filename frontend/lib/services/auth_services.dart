import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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
    var request = http.MultipartRequest('POST', signUpUrl);
    if (signupUser.imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'image', signupUser.imageFile!.path));
    }
    request.fields['username'] = signupUser.userName ?? "";
    request.fields['password'] = signupUser.password ?? "";
    request.fields['email'] = signupUser.email ?? "";
    request.fields['first_name'] = signupUser.firstName ?? "";
    request.fields['last_name'] = signupUser.lastName ?? "";
    request.fields['gender'] = signupUser.gender ?? "";
    request.fields['date_of_birth'] =
        (signupUser.dob != null) ? DateFormat('yyyy-MM-dd').format(signupUser.dob!) : "";
    request.fields['address'] = signupUser.address ?? "";
    request.fields['interests'] = signupUser.userInterests?.join(",") ?? "";
    request.fields['services'] = signupUser.userServices?.join(",") ?? "";

    final response = await request.send();    
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

  static Future<void> logout(String jwtToken, String refreshToken) async {
    final logoutUrl = Uri.parse("$baseUrl/user/logout");

    http.Response response = await http.post(
      logoutUrl,
      body: jsonEncode({'refresh_token': refreshToken}),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );
  }
}
