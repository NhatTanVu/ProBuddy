import 'dart:convert';
import 'package:intl/intl.dart';

class AuthUser {
  int? userId;
  String? jwtToken;
  String? refreshToken;
  String? userName;
  String? password;
  String? firstName;
  String? lastName;
  String? email;
  String? gender;
  DateTime? dob;
  String? address;
  List<dynamic>? userInterests;
  List<dynamic>? userServices;

  AuthUser(
      {required this.userId,
      required this.jwtToken,
      required this.refreshToken,
      required this.userName,
      this.password,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.gender,
      required this.dob,
      required this.address,
      required this.userInterests,
      required this.userServices});

  AuthUser.fromEmpty()
      : userId = null,
        jwtToken = null,
        refreshToken = null,
        userName = "",
        password = "",
        firstName = "",
        lastName = "",
        email = "",
        gender = null,
        dob = null,
        address = "",
        userInterests = null,
        userServices = null;

  factory AuthUser.fromJson(String jsonString) {
    var json = jsonDecode(jsonString);
    var interests = json['interests'];
    var services = json['services'];

    return AuthUser(
        userId: json['id'],
        jwtToken: json['access'],
        refreshToken: json['refresh'],
        userName: json['username'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['email'],
        gender: json['gender'],
        dob: DateTime.parse(json['date_of_birth']),
        address: json['address'],
        userInterests: interests,
        userServices: services);
  }

  String toJson() {
    Map<String, Object?> obj = {
      'id': userId,
      'access': jwtToken,
      'refresh': refreshToken,
      'username': userName,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'gender': gender,
      'date_of_birth': DateFormat('yyyy-MM-dd').format(dob!),
      'address': address,
      'interests': userInterests,
      'services': userServices
    };
    if (obj["id"] == null) {
      obj.remove("id");
    }
    if (obj["jwt_token"] == null) {
      obj.remove("jwt_token");
    }
    if (obj["refresh_token"] == null) {
      obj.remove("refresh_token");
    }
    return jsonEncode(obj);
  }
}
