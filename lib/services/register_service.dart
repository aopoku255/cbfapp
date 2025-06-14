import 'dart:convert';
import 'package:cbfapp/models/register_model.dart';
import 'package:cbfapp/util/constants.dart';
import 'package:http/http.dart' as http;

import '../util/baseUrl.dart';

class RegisterService {
  final registerUrl = '$baseUrl${apiRoutes['REGISTER']}';

  Future<RegisterModel> registerUser(String email) async {
    final response = await http.post(
      Uri.parse(registerUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );

    print('Response: ${response.body}');

    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      return RegisterModel.fromJson(data); // Full success response
    } else if (response.statusCode == 409) {
      // Don't try to parse to model, just throw message
      throw Exception(data['message'] ?? 'User already registered');
    } else {
      throw Exception('Failed to register user');
    }
  }

}
