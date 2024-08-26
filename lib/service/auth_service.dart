import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import '../model/blog_user_model.dart';

class AuthService extends ChangeNotifier {
  final String baseUrl = 'http://192.168.1.112:3000/api/v1'; // Update with your backend URL
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  User? _user;

  User? get user => _user;

  Future<User> signUp(String email, String password, String username) async {
    try {
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
        final errorResponse = jsonDecode(response.body);
        throw Exception('${errorResponse['msg']}');
      }
    } catch (e) {
      print('Sign up error: $e');
      rethrow; // Re-throw the error to handle it further up the call stack
    }
  }

  Future<User> signIn(String email, String password) async {
    try {
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
        final errorResponse = jsonDecode(response.body);
        throw Exception('${errorResponse['msg']}');
      }
    } catch (e) {
      print('Sign in error: $e');
      rethrow; // Re-throw the error to handle it further up the call stack
    }
  }

  Future<void> storeToken(String token) async {
    try {
      await storage.write(key: 'token', value: token);
      print('Token stored: $token'); // Print the token when it's stored
    } catch (e) {
      print('Error storing token: $e');
    }
  }

  Future<String?> getToken() async {
    try {
      return await storage.read(key: 'token');
    } catch (e) {
      print('Error retrieving token: $e');
      return null;
    }
  }

  Future<String> getUsernameFromToken() async {
    try {
      final token = await getToken();
      if (token != null) {
        final decodedToken = JwtDecoder.decode(token);
        return decodedToken['username'] ?? 'Unknown';
      }
      return 'Unknown';
    } catch (e) {
      print('Error decoding token: $e');
      return 'Unknown';
    }
  }

  Future<void> logout() async {
    try {
      _user = null;
      await storage.delete(key: 'token');
      notifyListeners();
    } catch (e) {
      print('Error during logout: $e');
    }
  }
}
