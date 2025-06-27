import 'dart:convert';
import 'dart:ffi';

import 'package:cbfapp/models/user_model.dart';
import 'package:cbfapp/util/constants.dart';

import '../models/users_model.dart';
import '../util/baseUrl.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String userDetailsUrl = '$baseUrl${apiRoutes['USER_DETAILS']}';
  final String allUsers = '$baseUrl/user/get-allusers';

  Future<UserInfoModel> fetchUserDetails(int userId) async {
    final response = await http.get(Uri.parse('${userDetailsUrl}/${userId}'));

    if (response.statusCode == 200) {
      print(response.body);

      return UserInfoModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load speakers: ${response.statusCode}');
    }
  }

  Future<UsersInfoModel?> fetchAllUsers() async {
    final url = Uri.parse('$baseUrl/user/get-allusers');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {

        final jsonBody = json.decode(response.body);
        return UsersInfoModel.fromJson(jsonBody);
      } else {
        print('Server error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Fetch failed: $e');
      return null;
    }
  }
}