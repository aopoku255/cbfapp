import 'dart:convert';
import 'dart:ffi';

import 'package:cbfapp/models/user_model.dart';
import 'package:cbfapp/util/constants.dart';

import '../util/baseUrl.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String userDetailsUrl = '$baseUrl${apiRoutes['USER_DETAILS']}';

  Future<UserInfoModel> fetchUserDetails(int userId) async {
    final response = await http.get(Uri.parse('${userDetailsUrl}/${userId}'));

    if (response.statusCode == 200) {
      print(response.body);

      return UserInfoModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load speakers: ${response.statusCode}');
    }
  }
}