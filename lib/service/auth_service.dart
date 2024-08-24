import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../modulw/module.dart';

class AuthService extends ChangeNotifier {
  final String baseUrl = 'http://localhost:3000/api/v1'; // Update with your backend URL
  final FlutterSecureStorage storage = FlutterSecureStorage();

  User? _user;

  User? get user => _user;

  Future<User> signUp(String email, String password, String username) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/signUp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password, 'username': username}),
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body)['data']['user'];
      _user = User.fromJson(json);
      await storeToken(_user!.token);
      notifyListeners();
      return _user!;
    } else {
      throw Exception('Failed to sign up');
    }
  }

  Future<User> signIn(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/signIn'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      _user = User(email: email, username: json['username'], token: json['token']);
      await storeToken(_user!.token);
      notifyListeners();
      return _user!;
    } else {
      throw Exception('Failed to sign in');
    }
  }

  Future<void> storeToken(String token) async {
    await storage.write(key: 'token', value: token);
    print('Token stored: $token'); // Print the token when it's stored
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<void> logout() async {
    _user = null;
    await storage.delete(key: 'token');
    notifyListeners();
  }
}
